---
layout: default
title: Version Control
parent: Control
nav_order: 6
---
# How to
### Clone a remote repository to local
```
git clone <url-to-repository>
```
this command copies the repository from remote and creates all the commit history of the project from all branches.

### Branch Operation
```
git checkout <branch-name>
```
this command checks out to the specified branch
```
git checkout -b <branch-name>
```
this command creates the new branch and checks out to this branch

### Commit Operation
before staging all your changes, please check you are currently on the right branch associated with the feature you are working on. The following command displays the current git status, including current branch.
```
git status
```
If you are on the wrong branch, you have to stash all your changes before checking out to other branches, or you will lost ALL the changes you made. The following command stash the changes for you to pop it into other branches.
```
git stash .
git checkout <the-correct-branch>
git stash pop
```
When you are ready to commit, stage and commit your changes. \
Note: commit description should be concise, less than 10 words. If you cannot describe the change in 10 words, it typically means you are squishing too much changes into one single commit.
```
git add .
git commit -m "commit description"
```

### Push to remote
All the operations will only affect the git repository on local machine. You can have push the changes to the remote in order to sync your commitment to the team github.\
Use push command to do this.
```
git push
```
You might get an warning if you create a local branch, while the remote doesn't have this branch. Set upstream branch to solve this issue.
```
git push --set-upstream origin <branch-name>
```

# Hardware Library

### Why hardware library?
The control teams is currently looking at more than 5 robots. While the control logic is totally different among different robots, they share the same low-level drivers and algorithm.


```
git submodule add <url-to-library>
```