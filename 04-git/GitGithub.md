# Git and GitHub Assignment

## Task 1: git commit -m vs git commit -a -m

### Difference

In git a file goes through three places. The working directory is where we edit the file, the staging area is where we put the changes we want to save, and the repository is where the commit is stored.

git commit -m only commits what is already in the staging area. So if a file is modified but not added with git add, this command will not commit it.

git commit -a -m automatically stages all the modified and deleted files which git is already tracking, and then commits them. So it does git add and git commit in one step.

The important point is that -a works only on tracked files. A new file which git has never seen is untracked, and it will not be included, we still have to use git add for it.

### Commands and output

```
--- create a file and make the first commit
[main (root-commit) 26c3d94] first commit
 1 file changed, 1 insertion(+)
 create mode 100644 file.txt

--- now modify the tracked file but do NOT stage it
 M file.txt

--- try: git commit -m (without -a)
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   file.txt

no changes added to commit (use "git add" and/or "git commit -a")

--- now: git commit -a -m
[main 44303ac] second commit using -a
 1 file changed, 1 insertion(+)

--- create an untracked file and try -a again
On branch main
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	newfile.txt

nothing added to commit but untracked files present (use "git add" to track)

--- git status after that
?? newfile.txt
```

### What I understood

I changed file.txt but did not run git add. Then git commit -m failed and gave the message "no changes added to commit", because the staging area was empty.

After that git commit -a -m worked and made the commit 44303ac, because -a staged the modified file by itself.

Then I made a new file newfile.txt and ran git commit -a -m again. This time it did not commit anything and said "untracked files present". This proves that -a only works for files which git is already tracking, not for new files.

In git status the letter M means modified and ?? means untracked.

## Task 2: Git Cherry-Pick

### What is cherry-pick

git cherry-pick takes one particular commit from another branch and applies that change on the current branch. It does not merge the whole branch, it only copies the change of that single commit.

It is useful when a bug fix is done on some other branch and we need only that fix in main, without bringing all the other work of that branch.

### Commands and output

```
--- git log of main
3ae0d3d add main2
7c28499 add main1
6996d17 add newfile
44303ac second commit using -a
26c3d94 first commit

--- create a new branch and switch to it
Switched to a new branch 'feature'

--- git log of feature branch
a5958ac add featureC
61ca706 add featureB
7407bcd add featureA
3ae0d3d add main2
7c28499 add main1
6996d17 add newfile
44303ac second commit using -a
26c3d94 first commit

--- I want to take only this commit into main: 61ca706
61ca706 add featureB
 featureB.txt | 1 +
 1 file changed, 1 insertion(+)

--- switch back to main
Switched to branch 'main'

--- files in main before cherry-pick
file.txt
main1.txt
main2.txt
newfile.txt

--- cherry-pick the selected commit
[main 12ddd42] add featureB
 Date: Thu Sep 3 22:26:27 2026 +0530
 1 file changed, 1 insertion(+)
 create mode 100644 featureB.txt

--- files in main after cherry-pick
featureB.txt
file.txt
main1.txt
main2.txt
newfile.txt

--- content of the picked file
feature B

--- git log of main after cherry-pick
12ddd42 add featureB
3ae0d3d add main2
7c28499 add main1
6996d17 add newfile
44303ac second commit using -a
26c3d94 first commit

--- both branches together
* a5958ac add featureC
* 61ca706 add featureB
* 7407bcd add featureA
| * 12ddd42 add featureB
|/  
* 3ae0d3d add main2
* 7c28499 add main1
* 6996d17 add newfile
* 44303ac second commit using -a
* 26c3d94 first commit
```

### Commands used

```bash
git log --oneline              # see the commits in short form
git switch -c feature          # create a new branch and go to it
git switch main                # go back to main
git cherry-pick 61ca706        # bring one commit into the current branch
git log --oneline --graph --all  # see all branches together
```

### What I understood

First I made commits on main and then created a branch called feature and made three commits there, featureA, featureB and featureC.

From git log I picked the commit 61ca706 which added featureB.txt. Then I came back to main and ran git cherry-pick 61ca706.

Before the cherry-pick main had only file.txt, main1.txt, main2.txt and newfile.txt. After the cherry-pick featureB.txt is also present in main and its content is "feature B", so the change came correctly.

The main thing I noticed is in the last graph. On the feature branch the commit is 61ca706 but on main the same change is 12ddd42. The hash is different because cherry-pick does not move the commit, it creates a new commit with the same change. The commit message and the content stay the same but the hash changes because the parent commit is different.

Also featureA.txt and featureC.txt did not come to main. Only the one commit I selected was applied. This is the difference between cherry-pick and merge, because merge would have brought all three commits.
