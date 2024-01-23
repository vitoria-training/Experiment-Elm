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
├─docker-compose.yml
│
├─Dockerfile
│
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
      dockerfile: ./Dockerfile
    volumes:
      - ./:/work/[elm project]
      - /work/node_modules
    ports:
      - "8000:8000"
    command: sleep infinity

```
※If you do not add "command: sleep infinity", an error will occur at startup
※"app:" is a temporary name and can be changed.

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

ENV PATH $PATH:/usr/local/bin

```

### Insert Dev Container into VSCode
Search for "Dev Container" in VSCode extensions and install it.

### Open with docker
1.Start "Docker Desktop".

※Work with VSCode from here.

2.Press "><" at the bottom left of VSCode.
![image](https://github.com/vitoria-training/Experiment-Elm/assets/129945608/ddd9f05c-436c-4141-8866-f3a25196d7bf)
(Can enter the development container.
 If not Search for "Remote Development" in VSCode extensions and install it.)

3.Select "Reopen in Container".
![image](https://github.com/vitoria-training/Experiment-Elm/assets/129945608/356b4f2c-4c6a-4f4d-a5b1-64a54d5a2303)

4.Select “Open with docker-compose.yml”.
![image](https://github.com/vitoria-training/Experiment-Elm/assets/129945608/92724578-ad83-49e3-9f63-446867b7154b)

5.Don't select anything and press OK.
![image](https://github.com/vitoria-training/Experiment-Elm/assets/129945608/d3f91fde-3557-4f0d-a1e1-71ab38951678)

6.After confirming that the container is running on "Docker Desktop",
![image](https://github.com/vitoria-training/Experiment-Elm/assets/129945608/30875621-250e-4e84-9627-cb87ddb97456)
confirm that you are in the development container with VSCode and start the terminal.
![image](https://github.com/vitoria-training/Experiment-Elm/assets/129945608/9e22bcaa-7630-4a19-8f15-1eb39a963e14)

7.Run the following command in the terminal.

Build the Elm project.
```
elm reactor
```
![image](https://github.com/vitoria-training/Experiment-Elm/assets/129945608/e2a40400-49b5-4d12-b49c-1acd0e569d80)

8.Check that the project is displayed at http://localhost:8000/.
![image](https://github.com/vitoria-training/Experiment-Elm/assets/129945608/9b25e915-a6a1-4e0e-820e-69ecdd366dd0)

![image](https://github.com/vitoria-training/Experiment-Elm/assets/129945608/c3ae3783-1029-45b6-80ff-6cf2f4d98d85)


Display "/src/Page/Top/Top.elm" as a trial.
![image](https://github.com/vitoria-training/Experiment-Elm/assets/129945608/1626105a-1a47-4c2c-a451-480bc8828e28)
