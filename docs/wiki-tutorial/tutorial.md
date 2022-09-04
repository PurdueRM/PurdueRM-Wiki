---
layout: default
title: Contributing to the Wiki
nav_order: 2
has_children: true
---

# How to Contribute to the Wiki

Go under your team's folder, and make a new Markdown (`.md`) file. 
To the top of the file, add a header so Jekyll knows how to interpret the page.

### To make a new upper-level page (such as the Algorithm Team page or Control Team Page), use a header like this:

```
---
layout: default
title: page name
nav_order: order to appear in sidebar (1, 2, 3...)
has_children: true 
---
```

### To make a sub-page under a top-level page (such as the YoloV5 page under Algorithm Team), use a header similar to this:

```
---
layout: default
title: page name
parent: parent page title name
nav_order: position to appear in sidebar (1, 2, 3...)
---
```

# Make sure the `parent` name is NOT the filename, but rather the title of the page in its header

For example, I could make a upper level page named "alg_team.md" with the header:

```
---
layout: default
title: Algorithm
nav_order: 2
has_children: true
---
```

then to add a child page, i would make another .MD file with the header:

```
---
layout: default
title: YoloV5 Annotation Forms
parent: Algorithm
nav_order: 7
---
```

### I highly recommend checking out the alg team folder as an example. 

# Learning markdown

Check out any online tutorial such as [this one](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
