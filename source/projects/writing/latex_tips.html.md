---
Title: LaTeX tips
---

# LaTeX tips

I wanted to put together a bit of a beginner's guide to writing in LaTeX papers
and serve as a central resource to point people when writing research papers
and such.  To help with paper writing I wanted to put up a FAQ-style set of
tips to make writing easier and minimize formatting errors. 

## General tips

Some general things to keep in mind:

### Structuring your project

Properly structuring the files for your project will make it easier to track
edits and collaborate.

* At a minimum, use one file for each section
* For theses and books with multiple chapters use a directory for each chapter
* Use one main tex file that just contains the preamble and links 
  to all other files
* Keep a separate `packages.tex` file containing all the package imports and 
  settings. It will be easier to find and change package settings without 
  having to dig through the latex preamble and input statements.

### Building

It's a good idea to create a build file using make or latexmk.
I recommend a combination of the two. 
Programs like [TeXworks](https://www.tug.org/texworks/) and 
[Texpad](https://www.texpadapp.com) will compile your latex and BibTex 
properly but they can't always handle all image and document conversions
like running R or python code to generate images/sections.

Your TeX distribution should have 
installed latexmk with the other commands. 
make is great for general building
and executing special build commands, like converting images or executing
analysis code. latexmk is great for running the latex pipeline (see below)
enough times to get a document with all your references intact. latexmk can
be called from make or you can tell latexmk to cooperate with make (see the
[docs](https://www.ctan.org/pkg/latexmk/).

The LaTeX compilation pipeline is not exactly intuitive.
The minimal set of commands for compiling a LaTeX document 
(named `main.tex`) with BibTeX for references is

```sh
latex main
bibtex main
latex main
latex main
```

The first `latex` command compiles your document and generates a `main.aux`
file but this will be missing references. The `bibtex` command reads the aux
file and creates the bibliograpy list. The second `latex` command picks up the
bibliography list and incorporates it into the document. Then the last `latex`
command resolves all the references given the incorporated bibliography. For
more details see [this FAQ](http://www.tex.ac.uk/FAQ-usebibtex.html). 

### ChkTeX is your friend!

[ChkTeX](http://baruch.ev-en.org/proj/chktex/) is a linter for LaTeX. It can be
set up to warn you if you've made many of the mistakes like missing non-breaking
spaces, incorrect quote characters, etc. Incorporate it into your build pipeline
to get early warning on any potential mistakes.

### Use synctex

The synctex mode puts marks in the final pdf that links the text back to 
the source files. Then, with a pdf viewer with syntex support, like 
[Skim](http://skim-app.sourceforge.net) (which is installed as part of MaxTeX),
you can click on the pdf and it will open your editor to that spot in the 
source.

To put in the synctex information call latex with the `-synctex=1` option.

### Use a commenting package

Use a commenting package like, the [fixme](https://www.ctan.org/pkg/fixme)
package. It will make it easier to make notes to yourself as well as for
collaborators to make notes. These packages introduce special commands that
will make the text of the comment stand out from the rest of the text. They
also can produce a table of contents-type page listing everything which makes
it easier to find everything.

### files in tex format should be .tex

Many editors and commands look for files with the `.tex` extension so name them
as such. Using extensions like `.inc`, `.add`, etc for latex source text is
not a good idea.

## Writing tips

When actually writing you need to be aware of many of LaTeX's quirks otherwise
the output will be subtlely incorrect.

### References aren't nouns

Typically, references, if done properly, will not change the sentence if they
are dropped. Hence, a use like "like it is done in [44]" is a stylistic snafu.
Instead you should use "like it is done by Smith and John [44]". In addition,
it helps the comprehension of the work if previous work is referenced by
authors names or method names (e.g. O-MOMS [17]), but it should not be left to
a number.

### Be careful with latex quote characters

To create surrounding quotes with a single quote character in LaTeX you need to
use the backtick character at the front and the single quote character at the
end of the text you want to quote. For double quotes use a double backtick and
double single quotes.  The double quote character on the keyboard won't work. 

### accents, umlauts, etc

The `latex`, `pdflatex`, and `bibtex` commands only know the basic ascii
character set.  They don't handle things like accents and umlauts. Therefore,
you need to encode characters as a backslash, special character followed by the
character you want to augment. It's a good idea to isolate these with curly
braces.  For example, an umlaut ö should be written `{\"o}` in the source.  The
LaTeX wikibook has a list of all of them
[here](https://en.wikibooks.org/wiki/LaTeX/Special_Characters#Escaped_codes).

Some common symbols:

* right accent - `\'`
* left accent - `\``
* umlaut - `\"`

The alternative is to use the `xetex` command which supports UTF-8 characters
but you need to ensure the tools with UTF-8 support are always used. It may
be easier to just search/replace all special characters.

### Put non-breaking spaces (~) between references and text

The tilde character `~` in latex is a non-breaking space. LaTeX won't turn this
space into a new line when it computes layout. It's important to use this
between `\ref` and `\cite` commands and the previous text.  Otherwise, LaTeX
may put your reference number on a new line which looks ugly.

### Use autoref

The `\autoref` command (see [the latex
wiki](https://en.wikibooks.org/wiki/LaTeX/Labels_and_Cross-referencing#autoref)
for more info) from the
[hyperref](https://en.wikibooks.org/wiki/LaTeX/Hyperlinks) package will
automatically create the text before a reference (like Section, Figure, Table,
etc).  This text can be customized.  Normally you must do this yourself and
it's hard to keep things consistent manually as you write.

### figure/table labels go outside captions

There's nothing technically wrong with this though. You are labelling the
figure, not the caption itself. However, see 
[this article](http://stefaanlippens.net/latexcaptionlabel) by Stefaan Lippens
which explains why you need to make sure that the `\label` either goes inside
the `\caption` or *after* the caption.

### No whitespace immediately after `\caption{`

Spaces, newlines, etc immediately after the caption command *will* create
a printed space in the caption. This doesn't look nice. If you want to put
a newline after the curly brace then escape it with a backslash. So,

```tex
\caption{\
  This is the best image ever
}
```

### Escape spaces between a period and a capital letter mid-sentence

If you have a period character followed by whitespace followed by a capital
letter in the middle of the sentence then you need to escape the space with a
backslash (`e.g.\ Juniper berries`). Otherwise, there will be too much spacing
between the words.  LaTeX uses different spacing between within-sentence words
and between sentences. Any time the parser sees a period, followed by
whitespace, then a capital letter it will assume you want an inter-sentence
space not an inter-word space. Escaping the whitespace fixes this.

### Use prefixes for labels

This just makes everything more organized in my opinion. Especially with 
the `\autoref` command you can tell from reading the reference what the label
refers to. I like to use the following:

* `fig:` for figures
* `tbl:` for tables
* `sec:` for sections

### When to use 'et al.' 

When there is only one author, a citation 
typically refers to this author like "as proposed by Smith [34]"; when 
there are two authors the citation should list both, as in "as proposed by 
Smith and Jones [34]". However, if there are three or more authors, than 
one uses the latin phrase "et al.", i.e. "as proposed by Smith et al. 
[34]".

### Cite multiple references in one `\cite` command

The ref style '[1][2]' is suffering from 'chart junk' problems. If you
reference it as '[1, 2]' it is much more readable. However, some publishers
require the former. In this case even though the source is correct the final
text will still have, for example, '[1][2].' So, please, double check. 

## BibTex

Many of these are thanks to [Torsten Möller]().

### Don't trust internet references. 

They often contain abbreviations, are missing page numbers, or otherwise need
to be edited. This includes not trusting the publishers themselves or resources
like google scholar or Menedeley.  They are often very wrong or incomplete.

So far I see the following problems regularly

* Abbreviated author names. Even if the paper uses their full names?!?!?
* Abbreviated journal/conference titles
* Incorrect journal/conference titles
* Missing month field
* Missing page numbers

### Use the journal reference over the conference

Some conferences, like VisWeek, publish papers in the journal as well as at the
conference. For these I use the journal reference over the conference. However,
make sure that the journal and conference publications are the same first! Many
fields submit early research to conferences and later extend it when they
publish in the journal. Also, not all VisWeek papers are journal papers. Double
check before citing them as such. 

### Use the month macro

If you put text in the month field of a bib entry then BibTeX will copy this
verbatim over to the final document, ignoring abbrrviations and such. Using the
month macros let's BibTeX handle the abbreviations and everything internally. 

### Use `--` for the page numbers

LaTeX has 3 sizes of dashes. The double dash is the one to use for ranges.

### Don't trust the bibliography style sent by the journal

If you have useful information in the notes field or publisher they might still
show up in the final pdf even though they shouldn't be shown.  The style used
by TVCG does this for example.  To remedy this I recommend using a custom bib
style based on the one used by the journal.  Copy the style file they reference
(which may be in your system TeX installation) and edit it to remove the
production rules causing a problem then reference this bibliography.

### Use full author names

The bibliography style contains whether or not authors should be abbreviated.
This only works if you use full author names in the `.bib` file though
so make sure to use those. Sometimes figuring out an author's first name is
quite difficult! Also, be sure that the same author is named consistently,
e.g.  decide for either "Frank H. Post" or "Frank Post", but don't use both.

### Never use double curly braces for the entire entry

BibTeX respects letters within curly braces inside a bibtex entry. LaTeX is
smart about captializing the rest and some capitalization rules are handled
by the bibliography format. Putting the entire entry in double curly braces
will break the capitalization rules LaTeX uses.

This is wrong:

```tex
	Title = {{HyperMoVal: Interactive Visual Validation of Regression Models for Real-Time Simulation}}
```
This is correct:

```tex
  Title = {{HyperMoVal}: Interactive Visual Validation of Regression Models for Real-Time Simulation}
```

### Titles of journals and conferences should be in title case

Make sure that journal names and conference names 
have most of the words capitalized as they are proper names. Do NOT rely 
on the ACM/IEEE digital libraries. Their formatting is (typically) very 
wrong.

### Spell out the full name of the journal/conference

Don't use casual abbreviations that might be only known for a small time-span
or a small audience (like 'VAST', 'ICIP', etc.).

### Include the DOI

Include the doi for *all* references (and hide the 'URL').  Bibliography styles
like EGStyle picks them up and displays them as linked URLs which is pretty
awesome in this digital age. You don't want a DOI link AND a URL link.

### No extra references

Do not reference references that you do not reference in the text. There 
is no reason to fill up space. If there is a relevant work, that you want 
to cite, explain where, how, and why it is important. Not all bibliography
formats filter these references out so don't just include your entire
personal reference list.

The [bibtool]() command can filter bibliography entries out of a larger set
into just what's used in your paper.

### Citing URLs

It is common to include a date when citing a URL, like 
e.g. "http:/bla.org, Retrieved May 13, 2005" or "http:/bla.org, Last 
visited May 13, 2005". For other details, please check [The Writer's 
Handbook](http://writing.wisc.edu/Handbook/elecapa.html)

