#!/bin/bash
# Copyright (C) 2016 Intel Corporation
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,

# Install test runner into  /tmp
cd /tmp
if [[ -d "rcptt-test-runner" ]]; then
  rm -rf rcptt-test-runner
fi
mkdir rcptt-test-runner
cd rcptt-test-runner
unzip -q /tmp/rcptt.runner*.zip

# Install Eclipse IDE for Eclipse Committers into the workspace
# as the Application under test
cd /tmp
if [[ -d "eclipse-committers" ]]; then
  rm -rf eclipse-committers
fi
mkdir eclipse-committers
cd eclipse-committers
tar xzf /tmp/eclipse-committers*.tar.gz

# Establish the workspace and project
workspace=$1
cd $workspace

tar xvzf /tmp/eclipse-committers*.tar.gz

# Set properties below
runnerPath=/tmp/rcptt-test-runner/eclipse
autPath=/tmp/eclipse-committers/eclipse
idePath=$workspace/eclipse

rm -r $workspace/project
if [[ -d $2 ]]; then
  ln -s $2 $workspace/project
else
  exit 1
fi
project=$workspace/project

# NOTE: $3 is 'args' passed to -entry.py (argparse.REMAINDER)
args=$3

# Set the host display (you did xhost + right?)
# pass -e DISPLAY=$DISPLAY to docker run
#xeyes

# properties below configure all intermediate and result files
# to be put in "results" folder next to a project folder. If
# that's ok, you can leave them as is

testResults=$workspace/results
runnerWorkspace=$testResults/runner-workspace
autWorkspace=$testResults/aut-workspace-
autOut=$testResults/aut-out-
junitReport=$testResults/results.xml
htmlReport=$testResults/results.html

java -version
# install RCPTT IDE in the Eclipse IDE for Eclipse Committers instance
java -jar $idePath/plugins/org.eclipse.equinox.launcher_*.jar \
     -application org.eclipse.equinox.p2.director \
     -destination  $idePath \
     -repository http://download.eclipse.org/releases/neon \
     -installIU org.eclipse.rcptt.platform.feature.group

java -jar $idePath/plugins/org.eclipse.equinox.launcher_*.jar \
     $workspace/ws \
     $args
