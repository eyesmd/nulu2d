# Nulu2D

<img src="https://raw.githubusercontent.com/eyesmd/nulu2d/master/readme/wip.jpg" width="250" height="250" align="right">

## Introduction

Nulu2D is a soon to be physics engine for game design. The idea is not to have a full-blown physics simulator, but rather a helper library with a flexible interface that allows to easily break laws when needed, as games tends to do. The current scope is to handle basic rigid body dynamics (without getting into joints).

I'm coding in Ruby for quick development, but I eventually want to migrate to C for performance.

## References

* Olivier Renault's [*2D polygon-based collision detection and response*](https://htmlpreview.github.io/?https://github.com/eyesmd/nulu2d/blob/master/refs/2D%20polygon-based%20collision%20detection%20and%20response.htm) ([original url](http://elancev.name/oliver/2D%20polygon.htm))
* Chris Hecker's [rigid body dynamics' articles](http://chrishecker.com/Rigid_Body_Dynamics) on Game Developer Magazine
* Ron Levin's [mails](http://realtimecollisiondetection.net/files/levine_swept_sat.txt) on convex polyhedra sweep tests
