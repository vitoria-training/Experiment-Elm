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

## Starting Docker (elm) from VSCode
reference https://zenn.dev/aoaoaoaoaoaoaoi/articles/5fdbb959616c8c#1.%E3%80%8Cdocker-compose.yml%E3%80%8D%E3%82%92%E4%BD%9C%E6%88%90

### Directory structure
```
│  docker-compose.yml
│
├─.devcontainer
│      devcontainer.json
│
├─docker
│      Dockerfile
│
└─work
　 └─[elm project]
```
※[elm project] is the name of the project being created.

### Create “docker-compose.yml”
docker-compose.yml
```
version: '3.9'
services:
  app:
    build:
      context: .
      dockerfile: ./docker/Dockerfile
    volumes:
      - ./work:/work
      - /work/node_modules
    ports:
      - "8000:8000"
    command: sleep infinity

```
※If you do not add "command: sleep infinity", an error will occur at startup

### Create docker directory
Dockerfile
```
FROM node:17.0.1-buster-slim

WORKDIR /work

RUN apt update
RUN apt-get install sudo
RUN apt install -y vim
RUN yes | sudo apt install curl

RUN curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz
RUN gunzip elm.gz
RUN chmod +x elm
RUN sudo mv elm /usr/local/bin/
RUN npm install --save elm elm-live
RUN sed -i -e "s/\(ignoreInitial: true,\)/\1\n    usePolling: true, /g" /work/node_modules/elm-live/lib/src/watch.js

ENV PATH $PATH:/usr/local/bin

```

### Create “.devcontainer” directory
devcontainer.json
```
{
	"name": "Existing Docker Compose (Extend)",
	"dockerComposeFile": [
		"../docker-compose.yml"
	],
	"service": "app",
	"workspaceFolder": "/work"
}
```

### Create "work" directory
Create a “work” directory in the root directory.
Put the Elm project in the "work" directory.

### Insert Dev Container into VSCode
Search for "Dev Container" in VSCode extensions and install it.

### Open with docker
1.Start "Docker Desktop".

※Work with VSCode from here.

2.Press "><" at the bottom left of VSCode.
(Can enter the development container.
 If not Search for "Remote Development" in VSCode extensions and install it.)

3.Select "Reopen in Container".

4.Select “Open with docker-compose.yml”.

5.After confirming that the container is running on "Docker Desktop",
confirm that you are in the development container with VSCode and start the terminal.

6.Run the following command in the terminal.

※Executes only at first startup.
```
elm init
```
Place [elm project] in the specified location.
[elm project] is the name of the project being created.
※From the second startup onward,
  if there is no difference in the source from the previous execution, there is no need to run it.
```
cp -r /work/[elm project]/ /usr/local/bin/src/
```

Build the Elm project.
```
elm reactor
```

7.Check that the project is displayed at http://localhost:8000/.