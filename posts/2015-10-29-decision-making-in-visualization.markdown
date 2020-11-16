---
title: Decision making in visualization
date: 2015-10-29 15:13 CET
tags: decision making, visualization, research
---

I gave a talk at the [Visualization for decision making under uncertainty
workshop](http://uncertainty2015.cs.univie.ac.at)
([writeup](http://figshare.com/articles/Decision_making_in_uncertainty_visualization/1585848) 
and [slides](http://www.tomtorsneyweir.com/decision_making-vdmu2015/final_talk)) 
recently on a project of
mine. We hypothesize that with better user modeling at a cognitive level we
could adapt visualization interfaces to their needs. A better model of how a
user works with a visualization would benefit visualization design in two
ways. The additional data on user-types would give us additional intervening
variables to consider when designing user study experiments. In addition,
we could design systems that could adapt to different user characteristics.
These systems could work better with the user, enhancing their strengths as
an analyst and helping to mitigate their weaknesses.

Right now, there are two major methods of evaluation for visualizations: user
studies and design studies. User studies are focused primarily on the
perceptual aspects of visualization. They evaluate very specific visual
encodings for very specific tasks with clearly defined goals. Evaluation
metrics are typically in the form of time taken for the task and how accurately
they performed the task.  In many cases this requires distilling a real-world
task and visualization into a much more focused one in order to test anything.
Design studies, on the other hand, design applications to help analysts in
real-world application scenarios.  The goal of these studies is to concentrate
on and work with only a very few domain experts and develop a task abstraction
of how domain experts accomplish their task. There is also an extensive
discussion about the design decisions made while developing a tool for the
users. These studies give a detailed description overview of how a domain
expert works. The hope is that some of the task abstractions and design
recommendations will transfer to other domains and help guide other
visualization designers.

The field of decision making such as has been described in *The adaptive
decision maker*[@Payne:1993] is a field that studies how
people combine low-level task primitives to solve complex problems with unclear
goals.  These are precisely the types of tasks that people face when doing data
exploration and analysis. While many people know they found something once they
found it, the questions are how did they go about finding information and is
this information they found useful?

Right now I see decision making fitting into an axis of user evaluation as seen
in the diagram below. On the left are perceptual studies which focus on
developing principles are generalizable to all humans. An example of this is
how many colors can we see[@Haroz:2012].  On the other side
are design studies which focus on a very specific user and task type. The Fluid
explorer paper[@Bruckner:2010] is a great example of this
type of research.  So that's the axis from basically all humans to one human
doing one task one specific way. In between these endpoints, we get more
focused on a particular user and environment as we move from the left to the
right. For example, cognitive traits like locus of control[@Rotter:1966] are 
specific to a particular person but are
relatively consistent over time. Decision making and problem solving heuristics
depend not just on the particular person but also what problem they are trying
to solve and even how that problem is presented to them[@Slovic:1983]!

![axis of user characterization](/images/vis_personalization_axis.svg)

As we move from right to left on this axis we find that the tasks get more
abstract and have better defined goals. The high-level task of, say, "find the
best flame simulation for my movie scene" as the case of Fluid explorer breaks
down into progressively more focused tasks. Medium-level tasks are things like
"compare multiple simulation outputs." A low-level task in this scenario is
through visual comparison of two frames of two different simulations side by
side. I feel that better cognitive modelling can help us to better understand
how people decompose the high-level task into the eventual low-level tasks.

So far this is shaping up to be a very interesting but difficult project :) It
would be linking together many distinct fields and I don't know how much
trouble this will be. But it's definitely fun to research, think about, and
discuss!


