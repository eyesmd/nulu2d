# 2D Engine Nulu

A handcrafted 2d engine being written in Ruby for personal use. I'm worried mostly about design and readability for educational purposes.

## Geometry

Geometry group:

* Point (alias Vector)
* Segment
* Polygon (Convex)
* Particular Polygons: Circle, Rectangle, Square
* Compound Polygons: Union, Intersection, Complement
* Collision
  * collides? (between polygons only)
  * intersects? included? (between shapes interpreted as lines, segments and points)

Point and Segment are primitives to build more complex types. The main type of this pseudo-module is Polygon, from where each particular shape will be derived from (curves will be aproximated). A Polygon will have to be convex so that the Collision module gives proper results. The idea is to use Compound Polygons to create concave shapes, but that idea is very hazy right now.

The Collision module will hold all the code related to calculating intersections and collisions between different objects. The 'collides?' rutine will only deal with Polygons, since only them are considered actual 2D shapes (even though it may make sense to ask wheter a segment is colliding with a shape). In the 'intersects?' and 'included?' rutine we see polygons as outlines, so it accepts points and lines as well as shapes/polygons.

## Roadmap
* Start with the Physics module (objects bouncing off of each other)

## Leftovers
* Investigate how dependencies ought to be dealt with in Ruby (gosu in sandbox.rb) 
* Refactor sproject adn vproject to sproject_to and vproject_to
* Other colision checks: Contains over shapes and segments? Intersects between segments?
