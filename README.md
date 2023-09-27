# Elm_React_TryOut

## Get starting with Elm!

### Installation
Install Elm from here. Also the URL explains everything you need to know. Please read this first.

https://guide.elm-lang.org/install/elm.html

Run this command to confirm Elm is installed properly.
~elm --help~
That is it. you are ready to go!

### Packages
Elm provide all packages. No need third party's packages.
All dependencies are wrriten in `elm.json`
To add more packages(to import packages in codes.)
```
elm install PACKAGE_NAME
```
such as
```
elm install elm/http
elm install elm/json
```
### known issues
if `.js` extension has set as executable on your environment and prompt any `elm` command on where you see `elm.js` the terminal keep asking you to open `elm.js` file.
in order to avoid this issue, either remove `.js` extension from the list of excutable of your environment or rename `elm.js` to something else. In this repository `elm.js` has renamed as `main.js`

## git flow

### branch
Please do not commit any tasks on these branches below.

### main branch(default)
This branch is used for release versions. DO NOT DO ANYTHING ON THIS BRANCH.

### develop branch
This branch is used as a base branch for ALL WORKING BRANCHES.
Please pull this branch everytime it has been updated.

### branch naming convention
no local rules. follow general convention.
https://dev.to/varbsan/a-simplified-convention-for-naming-branches-and-commits-in-git-il4

### Before you start working!
When you are assigned on or created an issue please follow these steps below.
- create a working branch from develop in local environment.
- push the branch to remote. 
- link the branch to the issue.
- ask a reviewer for approval start working on the issue. (reviewers make sure whether the branch has created properly.)

### commit rule
no local rules. follow general convention.
https://www.linkedin.com/pulse/7-best-practices-writing-good-git-commitmessages-kirinyet-brian/

### Pull Requests
Please link the issue on the description. you can link the issue id by typing `#`
