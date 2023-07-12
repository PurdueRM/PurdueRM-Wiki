---
layout: default
title: Git
parent: Alg Team Documentation
grand_parent: Algorithm
nav_order: 2
---

# Git

## Install Git
Chose the appropriate system version and follow the linked guide on installation. 
- [MacOS](https://git-scm.com/download/mac)
- [Windows](https://git-scm.com/download/win)
- [Linux](https://git-scm.com/download/linux)

### Clone
To download an repository from a remote server:   
```git clone <repo_address>```    
For example, to clone this [Wiki](https://github.com/RoboMaster-Club/PurdueRM-Wiki):   
```git clone https://github.com/RoboMaster-Club/PurdueRM-Wiki.git```

### Commit
Committing your code will record changes made to the repository.  
```
git add . # add all file to index for preparation of commit
git commit -m <commit_message> 
# or select specific changes to commit
git commit 
```

### Branch
To look at current and locally available branch:
```git branch```
To look at all available branch:
```git branch -a```
To switch to a branch:
```git checkout <branch_name>```   
To create a branch based on the current branch:
```git checkout -b <new_branch_name>```
**Before switching to a new branch, make sure you stage or stash all current changes*

### Merge
Merge branch to the current branch:
```git merge <merging_branch_name>```

### .gitignore
To keep the repository clean, we want keep the minium amount of files in remote. Generated files such as compiled programs and CMake artifacts are considered redundant, and could cause problem if compiled in a new environment. Add all redundant files to ```.gitignore``` located root directory of your repo. 

If redundant files has already been tracked by Git, use ```git rm <file_name>``` to remove redundant files from history. 

### Conflicts

If a file differs between, there will be a conflicts when attempt to merge those branch. In the conflicted file git will edit it to look like this: 
```
<<<<<< HEAD
...
=======
...
>>>>>> <merging_branch_name>
```
Everything between ```<<<<<<< HEAD``` and ```=======``` are the conflicted lines in the current branch. Lines between ```=======``` and ```>>>>>>> <merging_branch_name>``` are from the merging branch. It is your job to chose the correct version and make appropriate edits before merging. 

### Submodules 

If your code requires other git repositories within it, you should use ```git submodule``` in order to manage their versions. 

## Best Practice 
Here are some best practice regrading utilizing Git you should keep in mind while working in an collaborating environment.  
1. Always start a new functionality in a new branch. 
   - The ```master``` branch should be treated as a "latest working version" of the program, thus only merge completed and tested functionalities. 
   - This will also keep the ```master``` branch and it's work log clean, allowing us to easily revert to previous working version. 
2. Always pull, merge with ```master``` and resolve conflicts before working on your code. 
   - This will ensure your repo is current, and your working branch work with the latest version, allowing you to discover potential issues early. 
3. Make sure your commit messages are readable and useful. 
   - ~~I really which I did that durning CS251 and CS250 and CS252 and CS471. Guess who didn't learned this lesson.~~ 
4. Setup an SSH key for github and gitlab.
   - Remove the need for username and password while cloning, pushing, and pulling. 
   - TODO: Guide and link on how to set up SSH. 
5. Update ```.gitignore``` as soon as you see redundant files. 
   - Remove the need to use ```git rm``` later. 
