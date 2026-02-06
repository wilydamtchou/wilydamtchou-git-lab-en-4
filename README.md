UCC 131-1
Gitflows: Github, Gitlab

Lab 4: Advanced Merges & Professional CI/CD (GitHub Actions & GitLab CI)

General objective
Build a complete and professional CI/CD pipeline for a Spring Boot project, while mastering advanced merges, professional PR/MR, quality, security, advanced testing and multi-environment deployment.

Educational objectives
At the end of this practical exercise, the student will be able to:
Resolving complex Git conflicts (textual, structural, semantic)
Create professional and comprehensive PR/MR
Integrate CI/CD into PR/MR
Building a complete GitHub Actions pipeline
Build a complete GitLab CI pipeline
Integrate quality, security, advanced testing, deployment, releases, and scheduled jobs.
Understanding the strategic role of PR/MR in DevOps
Automatically deploy a Spring Boot project across multiple environments

General context of the practical work
You are working in a DevOps team on an internal project called UCC-DemoPipeline, a simple Spring Boot application.
Your mission: to set up a complete Git workflow + a complete CI/CD pipeline, inspired by an enterprise pipeline.


Exercise 1: Creating the Spring Boot Project

1.1 Objective
Create a minimal Spring Boot project to serve as the basis for the pipeline.

1.2 Actions

Create the project:

spring init --dependencies=web,actuator demo-pipeline


Add a Controller:


@RestController​
audience class HelloController {
@GetMapping ( "/hello " )
audience String hello () {
return "Hello CI/CD" ;
}
}

Initialize Git:


git init
git add .
git commit -m "Initial commit Spring Boot"


1.3 Deliverables
Capture of the generated project
Capture of the first commit

Exercise 2: Advanced Branches and Conflicts

2.1 Objective
Provoking and resolving real Git conflicts.

2.2 Actions
Create two branches:


git checkout -b feature/add-logging



Modify HelloController.java and pom.xml and commit:


git checkout develop
git checkout -b feature/add-endpoint



Edit the same lines in the same files, commit, and merge into develop.


git checkout develop
git merge feature/add-logging
git merge feature/add-endpoint   # conflicts



Resolving conflicts:
Edit files
git add
git commit

2.3 Deliverables
Conflict capture
Capture of resolution
Capture of the final merge

Exercise 3: Professional PR/MR

3.1 Objective
Create complete and professional PR/MR.

3.2 Practical actions on Github
Create a PR from feature/add-logging to develop. The PR must contain:
Context
Description
Technical justification
Checklist
Tests
Impacts
Screenshots (if applicable)

3.3 Practical actions on GitLab
Create a MR from feature/add-logging to develop. The MR must contain:
Context
Description
Technical justification
Checklist
Tests
Impacts
Screenshots (if applicable)

3.4 Deliverables
Link to the PR
Description screenshot
Link to the MR
Description screenshot

Exercise 4: Professional Code Review

4.1 Objective
Learn how to conduct a constructive code review.

4.2 Practical actions on Github
Regarding a colleague's PR:
3 constructive comments
1 code suggestion
Resolving a conversation
Approval

4.3 Practical actions on GitLab
Regarding a colleague's MR:
3 constructive comments
1 code suggestion
Resolving a conversation
Approval

4.4 Deliverables
Comment capture
GitHub approval capture
GitLab approval capture

Exercise 5: GitHub Actions Pipeline – Basic CI (Build)

5.1 Objective
Create a minimal CI pipeline on Github.

5.2 Actions
Create the file .github/workflows/ci.yml:


name: CI


on:
push:
branches: [ hand, develop ]
pull_request:
branches: [ hand, develop ]


jobs :
build:
runs-on: ubuntu-latest
steps:
- uses: actions/checkout@v4
- uses: actions/setup-java@v4
with:
distribution: temurin
java-version: 17
- name: Build & Test
run: mvn -B verify



5.3 Deliverables
Capture of the green pipeline
Capture of the PR with “All checks passed”

Exercise 6: GitLab Pipeline – Basic CI (Build)

6.1 Objective
Create a minimal CI pipeline on GitLab.

6.2 Actions
.gitlab-ci.yml file :


internships:
- build
- test


build:
internship: build
script:
- mvn -B package


test :
internship: test
script:
- mvn -B test



6.3 Deliverables
Pipeline capture succeeded
Capture of the MR with green pipeline
Exercise 7: Quality and Safety

7.1 Objective
Add static analysis, mutation testing, and security.

7.2 Practical Actions on GitHub Actions
Add


quality:
runs-on: ubuntu-latest
needs: build
steps:
- uses: actions/checkout@v4
- uses: actions/setup-java@v4
  with:
  distribution: temurin
  java-version: 17
- run: mvn spotbugs:check


security:
runs-on: ubuntu-latest
needs: build
steps:
- uses: actions/checkout@v4
- name: Dependency Check
  uses: dependency-check/Dependency-Check_Action@v3



7.3 Practical Actions on GitLab CI
Add


quality:
internship: quality
script:
- mvn spotbugs:check


include:
- template: Security/SAST.gitlab-ci.yml




7.4 Deliverables
Job quality capture
Security job capture

Exercise 8: Advanced Tests (Cucumber / Newman)

8.1 Objective
Add advanced testing to CI/CD.

8.2 Practical Actions on GitHub Actions
Add


cucumber:
runs-on: ubuntu-latest
needs: build
steps:
- uses: actions/checkout@v4
- run: mvn test


newman:
runs-on: ubuntu-latest
needs: build
steps:
- run: newman run tests.postman_collection.json



8.3 Practical Actions on GitLab CI
Add


cucumber:
internship: test
script:
- mvn test


newman:
internship: test
script:
- newman run tests.postman_collection.json



8.4 Deliverables
Capture of test reports

Exercise 9: Deployment (Dev / QA)

9.1 Objective
Simulate a multi-environment deployment.

9.2 Actions
Create :
scripts/ deploy-dev.sh
scripts/deploy-qa.sh

9.3 Practical Actions on GitHub Actions
Add


deploy_dev:
needs: [build, quality, security]
if: github.ref == 'refs/heads/develop'
runs-on: ubuntu-latest
steps:
- run: ./scripts/deploy-dev.sh


deploy_qa:
needs: [build, quality, security]
if: github.ref == 'refs/heads/main'
runs-on: ubuntu-latest
steps:
- run: ./scripts/deploy-qa.sh



9.4 Practical Actions on GitLab CI
Add


deploy_dev:
internship: deploy
only:
- develop
  script:
- ./scripts/deploy-dev.sh


deploy_qa:
internship: deploy
only:
- hand
  script:
- ./scripts/deploy-qa.sh



9.5 Deliverables
Capture of the deploy_dev job
Capture of the deploy_qa job

Exercise 10: Release and Scheduled Jobs

10.1 Objective
Automate versioning and scheduled tasks.

10.2 Practical Actions on GitHub Actions
Release GitHub Actions


release:
needs: build
if: github.ref == 'refs/heads/main'
runs-on: ubuntu-latest
steps:
- uses: actions/checkout@v4
- run: mvn versions:set -DnewVersion=$( date +%Y.%m.%d )
- run: |
  git tag v $( date +%Y.%m.%d )
  git push origin --tags



Cron GitHub Actions


on:
schedule:
- cron: "15 11 * * 1-5"



10.3 Practical Actions on GitLab CI
Release GitLab CI


release:
internship: release
needs: [ "build" ]
picture: ubuntu:latest


rules:
- if: '$CI_COMMIT_BRANCH == "main"'


script:
- apt-get update
- apt-get install -y git maven
- mvn versions:set -DnewVersion=$( date +%Y.%m.%d )
- git tag v $( date +%Y.%m.%d )
- git push origin --tags



Cron GitLab CI


maintenance:
internship: maintenance
only:
- schedules
  script:
- ./scripts/cleanup.sh



10.4 Deliverables
Capture of the created tag
Capture of the scheduled job
