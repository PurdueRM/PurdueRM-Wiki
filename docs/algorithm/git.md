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
```git clone <repo_address>```    
For example, to clone this [Wiki](https://github.com/RoboMaster-Club/PurdueRM-Wiki):   
```git clone https://github.com/RoboMaster-Club/PurdueRM-Wiki.git```

### Branch
To look at current and locally available branch:
```git branch```
To look at all available branch:
```git branch -a```
To switch to a branch:
```git checkout <branch_name>```   
To create a branch:
```git checkout -b <new_branch_name>```
**Before switching to a new branch, make sure you stage or stash all current changes*

### Merge
Merging branch to the current branch:
```git merge <merging_branch_name>```

### .gitignore
To keep the repository clean, we want keep the minium amount of files in remote. Generated files such as compiled programs and CMake artifacts are considered redundant, and could cause problem if compiled in a new environment. Add all redundant files to ```.gitignore``` located root directory of your repo. 
If redundant files has already been tracked by Git, use ```git rm <file name>``` to remove redundant files from history
