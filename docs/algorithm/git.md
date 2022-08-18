---
layout: default
title: Git
parent: Getting Started
nav_order: 1
has_children: true
---

# Git

## Install Git
Chose the appropate system version and follow the linked guide on installation. 
- [MacOS](https://git-scm.com/download/mac)
- [Windows](https://git-scm.com/download/win)
- [Linux](https://git-scm.com/download/linux)

### Clone
To download an repository from a remote server:   
```git clone <repo address>```    
For example, to clone this [Wiki](https://github.com/RoboMaster-Club/PurdueRM-Wiki):   
```git clone https://github.com/RoboMaster-Club/PurdueRM-Wiki.git```

### Branch
To look at current and locally available branch:
```git branch```
To look at all available branch:
```git branch -a```
To switch to a branch:
```git checkout <branch name>```   
**Before switching to a new branch, make sure you stage or stash all current changes*
