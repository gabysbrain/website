---
layout: post
title: Multiblog
date: 2012-06-14 16:54
comments: true
tags: blog
---

With the new website I wanted 2 sources of posts, regular blog posts and
projects.  This boils down to having 2 separate index pages, one for my blog
posts and one for my projects.  The issue with jekyll/Octopress is that all
valid files in any `_posts` directory are all combinied into one big list.
Jekyll/Octopress doesn't differentiate the posts stored in different places on
the file system.  I wanted two separate index pages.  One would list all my
blog posts in the standard blog index format and the other would be a
different layout listing all my projects.

<!--more-->

I found [this thread](http://groups.google.com/group/jekyll-rb/browse_thread/thread/50a5f36fee313f29?pli=1)
as well as [this post](http://www.garron.me/blog/multi-blog-site-jekyll.html)
detail how to use the categories attribute in the yaml front matter to
distinguish which blog posts are part of. However, I wanted to use the
category attribute to produce a categorized list of all my projects.  What I
found is that all variables in the yaml front matter are available so I can
use effectively the same method as the category one but checking against the
value of the `layout` variable instead of `category`.  This works great for me
since my blog posts and project "posts" have completely different layouts
anyway.

## Example yaml front matter

When creating a post I just have to make sure that for blog posts my yaml
front matter includes a `layout: post` line as shown below:

```
---
layout: post
title: "Reproducable research"
date: 2012-05-19 20:19
comments: true
categories: research
---
```

and projects include a `layout: project` line:

```
---
layout: project
title: "Tuner"
category: research
summary: We present an approach to optimizing a high-dimensional parameter space for computer simulations.
teaser: tuner.png
video: http://www.youtube.com/watch?v=f44P7ulT2yY
---
```

I then made sure that there were layout files called `post.html` and
`project.html` in my `source/_layout` directory in Octopress.

## Index pages

Then, when creating my [blog index](/blog/) page, I just have to check
if `layout = 'post'`

```
{% for post in paginator.posts %}
  {% if post.layout == 'post' %}
  {% assign content = post.content %}
    <article>
      {% include article.html %}
    </article>
  {% endif %}
{% endfor %}
```

For the projects list I manually list the categories right now.  So, for
example, the "Research" section of my [projects list](/projects) looks like

```
<h1>Research</h1>
{% for proj in site.posts %}
  {% if proj.layout == 'project' and proj.category == 'research' %}
    {% assign content = proj.content %}
    <div class="project-preview">
      {% include project.html %}
    </div>
  {% endif %}
{% endfor %}
```

## Rakefile

The last step was to make sure that creating new posts via the Rakefile
automatically add the layout directive.  My new post task now looks like:

```
desc "Begin a new post in #{source_dir}/#{posts_dir}"
task :new_post, :title do |t, args|
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  mkdir_p "#{source_dir}/#{posts_dir}"
  args.with_defaults(:title => 'new-post')
  title = args.title
  filename = "#{source_dir}/#{posts_dir}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.#{new_post_ext}"
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end
  puts "Creating new post: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "published: false"
    post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
    post.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
    post.puts "comments: true"
    post.puts "category: "
    post.puts "---"
  end
end
```

I also wanted to add a task called `new_project` to create a new project file
similar to how to create new Octopress posts.  That task also adds a bunch of
extra fields that the project layout uses for my projects like a teaser image,
and links for demo videos, citations, websites, etc.  My new project task
looks like

```
desc "Begin a new project in #{source_dir}/#{projects_dir}"
task :new_project, :title do |t, args|
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  mkdir_p "#{source_dir}/#{projects_dir}"
  args.with_defaults(:title => 'mr project')
  title = args.title
  filename = "#{source_dir}/#{projects_dir}/#{title.to_url}.#{new_post_ext}"
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end
  puts "Creating new project: #{filename}"
  open(filename, 'w') do |proj|
    proj.puts "---"
    proj.puts "layout: project"
    post.puts "published: false"
    proj.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
    proj.puts "comments: false"
    proj.puts "category: "
    proj.puts "teaser: "
    proj.puts "video: "
    proj.puts "web: "
    proj.puts "mendeley: "
    proj.puts "paper: "
    proj.puts "---"
  end
end
```

## Conclusion

That's it!  Now I can have as many sub blogs as I want and keep the
category field available for categorizing posts.
