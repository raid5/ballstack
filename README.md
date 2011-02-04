BallStack
=========

This code is a bit outdated nowadays but I thought I'd toss it up on Github anyways. It is a simple iPhone game written back in 2008, based on the iPhone 2.0 SDK. I have recently compiled the app against the 4.2 SDK and everything seems to be working.

**Note:** This game normally connects to a remote server for managing all the ongoing games, players within the games, and the status of the games but...the server is no longer running. Therefore the code currently is only for reference purposes. If you would like to run the server code yourself, and have the game client connect to it for fun, message me and I'll hook you up with the server code and more details about the proejcts.

Introduction
------------

This game is the product of a project in a game design course I took while in college, in collaboration with Jason Dinsmore and Peter Beck. It was largely based off the popular OMGPOP [dinglepop](http://www.omgpop.com/) game.

The game was written from the ground up based on our learnings in the course. We rolled our own game engine (collision detection, game objects, network manager, etc) because at the time the iPhone game engine market was fairly limited.

The Code
--------

This project was one of my first experiences with the iPhone SDK and therefore I'm sure the code quality and practices are not my best. I have progressed a lot in this space of the past 4+ years of iPhone development.

That said, here are some details:

* ~34 classes
* 5 view controllers
* ~3,500 lines of code (according to [cloc](http://cloc.sourceforge.net/))

The Interface
-------------

Since the main focus of this project was the game engine and multiplayer networking support, the user interface is a bit lacking.

![Game Menu](https://github.com/raid5/ballstack/raw/master/screenshots/ballstack-intro.jpg)
![Gameplay 1](https://github.com/raid5/ballstack/raw/master/screenshots/ballstack-gameplay.jpg)
![Gameplay 2](https://github.com/raid5/ballstack/raw/master/screenshots/ballstack-gameplay-2.jpg)
