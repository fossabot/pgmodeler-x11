# pgModeler-in-Docker (using X11)

## What's this?
Primarily it is a way to build and run [pgModeler](https://pgmodeler.io/) inside Docker.

However, it is also a build environment that does cross-platform UI compilation from inside Docker, compiling using GTK and Rust.
i.e. it is a mechanism to build Linux and macOS binaries in Docker.

## Why?
* Because building pgModeler is harder than it should be.
* Because most distros are behind in their pgModeler version and/or don't have an easy way of getting the latest release - this gives another docker-based option to easily get a modern up-to-date pgModeler version. 
* This allows you to easily switch between different pgModeler versions without clobbering your config directory. 
  
  Change the `PGMODELER_VERSION` in the container to build another version to be run, add `PGMODELER_VERSION` as an environment variable when running the launcher image to start a different run image.
* Because having a base Docker pgModeler image to be shared between users on all platforms helps address the security concerns raised by running binaries other have built. A company (in this case a bank) can compile its own image and can audit how it was built and how it was stored - banking databases are sensitive!

* Because having a reproducible way of building GTK applications for the three major desktop platforms using Docker and the Rust rocks!

## About pgModeler and commercial support
pgModeler [provides pre-compiled binaries at a small price](https://pgmodeler.io/download?purchase=true).
While we are providing an easy way to build and run pgModeler, we will not be changing the scripts and images provided to build *stable* versions (only *development* versions) - this is so as not to erode their (paying) customer base.

We will also not be providing support. 

Further, as you're essentially running pgModeler on Linux, it will look and feel like Linux. Which is nice if you're a Linux user, not so great if you're a Mac or Windows user - kindly buy the prebuilt binaries from the pgModeler project if this is a problem.

## macOS Packaging
[ Please ensure you have read and understood the Xcode license terms before continuing.](https://www.apple.com/legal/sla/docs/xcode.pdf)

**Building for macOS should be done on Apple hardware!**

The launcher compiles and links inside a container that has [Macports](https://www.macports.org/) installed. 
The binary is `target/macos-x86_64/x86_64-apple-darwin/release/launcher`. 
In order to be able to run this, you need to install gtk3 using either Brew or Macports. This will change in the future as we aim to make an application launcher to be put in your `/Applications` directory. 

[TODO implement https://wiki.gnome.org/Projects/GTK/OSX/Bundling] 


## Prerequisites
### Linux
* Docker

### macOS
* Docker
* XQuartz

## Building the container

In the `container` directory, run `./build.sh`.

This will create two images: `pgmodeler-docker-x11/build` and `pgmodeler-docker-x11/run`.

This will take ~15 minutes.

## Build and install the launcher
**\*\* Currently Linux Only \*\***
In the `launcher` directory, run `./build.sh <platform>` where platform is linux, mac.
Only Linux actually installs it now (for now). For macOs the binary is built but then needs to be run from the command line and have gtk3 installed (see "macOS Packaging").

When the Linux build finished, it will create a .desktop entry in your /usr/share/applications/ directory, which means you can run pgModeler from your application launcher.

## Run without the launcher
The launcher looks at your environment and then runs the command below and lets you know if something goes wrong. 

But nothing is keeping you from doing it yourself.
**NOTE:**  this can/will clobber your config if you're not using 0.9.2-alpha1.
### Linux
`docker run --rm -it --user $(id -u) -e DISPLAY=unix$DISPLAY --workdir=$(pwd) --volume="/home/$USER:/home/$USER" --volume="/etc/group:/etc/group:ro" --volume="/etc/passwd:/etc/passwd:ro" --volume="/etc/shadow:/etc/shadow:ro" --volume="/etc/sudoers.d:/etc/sudoers.d:ro" -v /tmp/.X11-unix:/tmp/.X11-unix pgmodeler-docker-x11/run:v0.9.2-alpha1`

### macOS
You need XQuartz running and you need your ip: `ipconfig en0` or `ipconfig en1`.
One of these commands need to give you your IP. Export it ```export MY_IP=`ipconfig en0` ```

To run it:

`docker run --rm -it --user $(id -u) -e DISPLAY=$MY_IP --workdir=$(pwd) --volume="/User/$USER:/home/$USER" --volume="/etc/group:/etc/group:ro" --volume="/etc/passwd:/etc/passwd:ro" --volume="/etc/shadow:/etc/shadow:ro" --volume="/etc/sudoers.d:/etc/sudoers.d:ro" -v /tmp/.X11-unix:/tmp/.X11-unix pgmodeler-docker-x11/run:v0.9.2-alpha1`

