Eclipse CROPS RCPTT Test Authoring Container
========================
This repo is to create an image that is able to run ```Eclipse IDE for Eclipse
Committers``` and allow you to write ```RCPTT``` tests. The main
difference between it and https://github.com/crops/yocto-dockerfiles is that
it has helpers to create users and groups within the container. This is so that
the output generated in the container will be readable by the user on the
host.

TL;DR
-----
```
docker build -t crops/eclipse-crops-test-authoring:neon-1a .
```
```
docker run --rm -t -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0  -v /home/$USER/project:/project -e DISPLAY=:99.0 -v /home/$USER/workdir:/workdir crops/eclipse-crops-test-authoring:neon-1a --id $(id -u):$(id -g)
```

Brief Introduction to RCPTT
---------------------------
RCPTT (Rich Client Platform Testing Tool) was originally a commercial product called Q7, which was open sourced by Xored. While it is most commonly used for testing Eclipse, it is actually designed to test any OSGI (Open Source Gateway Initiative) compliant application, which all Eclipse applications and plugins are. It provides an IDE to develop tests, plugins that can be installed in the developer's IDE, and headless test runners for Linux, Windows and Mac OS X which can be used for continuous integration. It provides examples for calling the test runner from a shell script, Maven, Ant or the command line. Like most testing frameworks, it has test suites which consist of test cases. Unlike most testing frameworks, it uses pickled java objects to: (1) represent a starting state of the UI, known as a Context; (2) represent the expected final state of an object (such as a GUI widget), known as a Validation. These binary blobs are created graphically using the RCPTT IDE. A test case might consist of set-up (setting a Context), several UI interactions run from a script, verifying the results by comparing to a Validation, and a tear-down.

Running the container
---------------------
Here a very simple but usable scenario for using the container is described.
It is by no means the *only* way to run the container, but is a great starting
point.

* **Create a workdir**

  First we'll create a directory that will be used as the RCPTT workspace
  and as the location of the RCPTT project (the tests to be run). The test
  results will be in this same workspace.

  ```
  mkdir /home/$USER/workdir
  ```

  For the rest of the instructions we'll assume the workdir chosen was
  `/home/$USER/workdir`.

* **The docker command**

  Assuming you used the *workdir* from above, the command
  to run a container for the first time would be:

  ```
  docker run --rm -t -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -v /home/$USER/project:/project -v /home/$USER/hostworkdir:/workdir -e DISPLAY=$DISPLAY crops/eclipse-crops-test-authoring:neon-1a \
  --workdir=/workdir --project=relative/path/to/project --id $(id -u):$(id -g)\
  ```

  Let's discuss some of the options:
  * **_-v /home/$USER/workdir:/workdir_**: The default location of the
    workspace inside of the container is /workdir. So this part of the
    command says to use */home/$USER/workdir* as */workdir* inside the
    container.
  * **_--workdir=/workdir_**: This causes the container to start in the
    workspace specified. In this case it corresponds to */home/$USER/hostworkdir* due to
    the previous *-v* argument. The container will also use the uid and gid
    of the workdir as the uid and gid of the user in the container.
  * **_--project=relative/path/to/some/rcptt/project_**: This causes the
    project directory specified to be used for the RCPTT project (the source
    of the tests), rather than the default project bundled inside the container.


  This container will first create a symbolic link from the project to
  ```workdir/project```. It will then install the ```RCPTT IDE``` plugin into
  ```Eclipse IDE for Eclipse Committers``` and then launch the IDE. It will
  delete the symbolic link to **_workdir/project_** folder if it is already
  present in the **_workdir_**.

  The container provides a clean copy of ```Eclipse IDE for Eclipse Committers``` to act as the Application Under Test (AUT) at the path ```/tmp/eclipse-commiters```.
