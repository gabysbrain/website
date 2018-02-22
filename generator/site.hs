--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import GHC.IO.Encoding as E
import           Control.Monad (liftM)
import           Data.Monoid (mappend)
import           Hakyll
--import           Hakyll.Web.Sass (sassCompiler)
import           System.FilePath (replaceExtension, takeDirectory)
import qualified System.Process  as Process
import qualified Data.Set as S
import qualified Data.Text as T
import qualified Text.Pandoc as Pandoc
import           Text.Pandoc.Options

--------------------------------------------------------------------------------

bibFileName :: String
bibFileName = "bib/all.bib"

refCslFileName :: String
refCslFileName = "csl/apa-cv.csl"

inlineCslFileName :: String
inlineCslFileName = "csl/inline.csl"

main :: IO ()
main = do
  E.setLocaleEncoding E.utf8

  hakyll $ do

    match "images/*" $ do
      route   idRoute
      compile copyFileCompiler

    -- files for citations
    match "bib/*" $ compile biblioCompiler
    match "csl/*" $ compile cslCompiler
      
    {-match "css/*.scss" $ do-}
    {-route   $ setExtension "css"-}
    {-let compressCssItem = fmap compressCss-}
    {---compile (compressCssItem <$> sassCompiler)-}
    {-compile sassCompiler-}

    match "css/*.css" $ do
      route   idRoute
      compile compressCssCompiler

    match (fromList ["about.markdown", "research.markdown", "teaching.markdown"]) $ do
      route   $ setExtension "html"
      compile $ pandocCompiler
        -- >>= loadAndApplyTemplate "templates/page.html"  postCtx
        >>= loadAndApplyTemplate "templates/default.html" defaultContext
        >>= relativizeUrls

    match (fromList ["publications.markdown", "cv.markdown"]) $ do
      route   $ setExtension "html"
      compile $ pageCompiler
        -- >>= loadAndApplyTemplate "templates/page.html"  postCtx
        >>= loadAndApplyTemplate "templates/default.html" defaultContext
        >>= relativizeUrls

    match "cv.markdown" $ do
      route   $ setExtension "html"
      compile $ pageCompiler
        -- >>= loadAndApplyTemplate "templates/page.html"  postCtx
        >>= loadAndApplyTemplate "templates/cv.html" defaultContext
        >>= loadAndApplyTemplate "templates/default.html" defaultContext
        >>= relativizeUrls

    match "cv.markdown" $ version "pdf" $ do
      route   $ setExtension "pdf"
      compile $ do 
        csl <- load $ fromFilePath inlineCslFileName
        bib <- load $ fromFilePath bibFileName
        getResourceBody
           >>= readPandocBiblio def csl bib
           >>= (return . fmap writeXeTex)
           >>= loadAndApplyTemplate "templates/cv.tex" defaultContext
           >>= xelatex

    match "news.md" $ do
      compile $ pageCompiler
        >>= relativizeUrls

    match "posts/*" $ do
      route $ setExtension "html"
      compile $ blogCompiler
        >>= loadAndApplyTemplate "templates/post.html"  postCtx
        >>= loadAndApplyTemplate "templates/default.html" postCtx
        >>= relativizeUrls

    create ["blog.html"] $ do
      route idRoute
      compile $ do
        posts <- recentFirst =<< loadAll "posts/*"
        let archiveCtx =
              listField "posts" postCtx (return posts) `mappend`
              --constField "title" "Archives"            `mappend`
              defaultContext

        makeItem ""
          >>= loadAndApplyTemplate "templates/blogroll.html" archiveCtx
          >>= loadAndApplyTemplate "templates/default.html" archiveCtx
          >>= relativizeUrls

    -- TODO: make talks index page
    match "talks/*" $ do
      route idRoute
      compile copyFileCompiler

    match "index.html" $ do
      route idRoute
      compile $ do
        posts <- recentFirst =<< loadAll "posts/*"
        news <- loadBody "news.md"
        let indexCtx =
              listField "posts" postCtx (return posts) `mappend`
              constField "title" "Home"                `mappend`
              constField "news" news                `mappend`
              defaultContext

        getResourceBody
          >>= applyAsTemplate indexCtx
          >>= loadAndApplyTemplate "templates/default.html" indexCtx
          >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
  dateField "date" "%B %e, %Y" `mappend`
  defaultContext


--------------------------------------------------------------------------------
pandocPubsCompiler :: Compiler (Item String)
pandocPubsCompiler =
  let customExtensions = [ Ext_definition_lists ] -- from pandoc's options: http://hackage.haskell.org/package/pandoc-1.10.0.4/docs/Text-Pandoc-Options.html 
      defaultExtensions = writerExtensions defaultHakyllWriterOptions
      newExtensions = foldr S.insert defaultExtensions customExtensions
      writerOptions = defaultHakyllWriterOptions {
                        writerExtensions = newExtensions
                      }
  in pandocCompilerWith defaultHakyllReaderOptions writerOptions

pageCompiler :: Compiler (Item String)
pageCompiler = do
  csl <- load $ fromFilePath inlineCslFileName
  bib <- load $ fromFilePath bibFileName
  liftM writePandoc
        (getResourceBody >>= readPandocBiblio def csl bib)

blogCompiler :: Compiler (Item String)
blogCompiler = do
  csl <- load $ fromFilePath refCslFileName
  bib <- load $ fromFilePath bibFileName
  liftM writePandoc
        (getResourceBody >>= readPandocBiblio def csl bib)

--writeXeTex :: Item Pandoc.Pandoc -> Compiler (Item String)
writeXeTex = 
  Pandoc.writeLaTeX Pandoc.def {Pandoc.writerTeXLigatures = False}

xelatex :: Item String -> Compiler (Item TmpFile)
xelatex item = do
    TmpFile texPath <- newTmpFile "xelatex.tex"
    let tmpDir  = takeDirectory texPath
        pdfPath = replaceExtension texPath "pdf"

    unsafeCompiler $ do
        writeFile texPath $ itemBody item
        _ <- Process.system $ unwords ["xelatex"
             , "-halt-on-error", "-output-directory"
             , tmpDir, texPath
             --, ">/dev/null", "2>&1"
             ]
        return ()

    makeItem $ TmpFile pdfPath

