---
layout: project
title: "R notebook"
category: other
summary: A notebook-style interface to R that allows annotationed data analysis using R, LaTeX formulas, and multimarkdown text
teaser: r-notebook_teaser.png
video: 
source: https://github.com/gabysbrain/r-notebook
paper: 
---

This is a fork of the [Octopress](http://octopress.org) blog engine with 
supprt for using [multimarkdown](http://fletcherpenney.net/multimarkdown/) 
along with embedded [knitr](http://yihui.name/knitr/) markup.
This allows one to create a lab notebook using
R for data analysis and multimarkdown and LaTeX formulas for explanation.

This project started as a script which took
as input a multimarkdown file annotated with R code, 
passes it through R using the knitr module, and then generates an html
file using multimarkdown.  

The current setup is described in [this post](/research-notebook) and 
my original setup is in 
[this post](/reproducable-research).
