---
layout: post
title: "Public/private git for research"
date: 2013-10-29 09:31
comments: true
tags: programming, research
---


I feel that it's very important that any code I write for my research is
available online so that anyone can access and read it. I also want people to
be able to view all the individual changesets that went into the software.
That way they can see the full thought-process that went into a project.  That
is why, for example, [Tuner](http://github.com/gabysbrain/tuner) is on GitHub.

However, when I am developing a feature for a paper, I don't want the code to
be public until after the paper is accepted.  Furthermore, I want to keep my
private changes online so that I can share them with collaborators.  So what
to do?  What I do is have 2 git repos online, a public one and a private one.
Then, I use feature branches in the style of
[git-flow](http://nvie.com/posts/a-successful-git-branching-model/) to keep
track of all my changes.  I keep them in my private repo until I'm ready to
expose them to the world and then move them to my public repo once I'm done.
I detail my specific setup below.

<!-- more -->

## Set Up

In this example I have my public repo at `github.com` and my private repo
hosted at the (fake) address `private.com`.

### Remotes

The first thing I do is remove the "origin" remote mapping. This way it's
unambiguous whether I'm pushing a branch to my public repo or my private one.

``` bash
git remote remove origin
git remote add public git@github.com:gabysbrain/tuner.git
git remote add private git@private.com:gabysbrain/tuner_dev.git
```

### Branches

The next thing is to map all the branches that I want to use.  For example if
I have branches `release_2.0` and `bugfix` in the public repo and a
`secret_feature` branch in my private repo.  Then I just map these the normal
way:

``` bash
git branch release_2.0 public/release_2.0
git branch bugfix public/bugfix
git branch secret_feature private/secret_feature
```

And that's it.  Now the master branch is linked to the public repo. This means
that I only have one "official" version of Tuner: the master branch on GitHub.
I used to maintain a "development master" branch too but that was always
confusing as to which one I should be merging into.

## Workflow

Now that all the basic structure is set up we can easily handle new branches.
Here is an example of creating a new private feature branch, doing some work
on it, and then moving it to my public repo.

First we check out a new branch and then
push it upstream to my private repo.

``` bash
git checkout -b next_idea
git push --set-upstream private next_idea
```

Then I can make all the changes I want and push them privately.  This is the
branch I will share with contributors.  Once I'm ready to There's no remote
move command so we have to do it manually by pushing it upstream to the public
repo and then deleting it on the private one.  

``` bash
git push --set-upstream public next_idea
git branch -r -d private/next_idea
```

I usually look at my branch mappings at this point to double check that
everything is up to date.

``` bash
git branch -r
```

I check that all my public branches should be mapped to the public remote and
all my private branches are mapped to my private remote.
