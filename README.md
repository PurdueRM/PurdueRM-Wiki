# PurdueRM-Wiki (https://purduerm.github.io/PurdueRM-Wiki/)
Public Wiki / Documentation for Purdue's Robomasters Club


## How to add a page

Go under your team's folder, and make a new Markdown (`.md`) file. 
To the top of the file, add a header so Jekyll knows how to interpret the page.

### To make a new upper-level page (such as the Algorithm Team page or Control Team Page), use a header like this:

```
---
layout: default
title: <page name>
nav_order: <order to appear in sidebar (1, 2, 3...)>
has_children: true 
---
```

### To make a sub-page under a top-level page (such as the YoloV5 page under Algorithm Team), use a header similar to this:

```
---
layout: default
title: <page name>
parent: <parent page title name>
nav_order: <position to appear in sidebar (1, 2, 3...)>
---
```
