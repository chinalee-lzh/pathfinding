export ^

class Dot
  new: (x, y) =>
    @x = x or 0
    @y = y or 0
  equal: (d) => @x == d.x and @y == d.y
  add:(d) => Dot(@x+d.x, @y+d.y)
  sub:(d) => Dot(@x-d.x, @y-d.y)
  tostring: => "[#{@x}, #{@y}]"
class Node
  new: (dot, parent) =>
    @dot = dot
    @parent = parent
    @g = 0
    @h = 0
    @f = 0
    @idxheep = -1
  setCost: (g, h) =>
    @g = g
    @h = h
    @f = @g+@h
    @
class JPSNode extends Node
  new: (jumpDirs, ...) =>
    super(...)
    @jumpDirs = jumpDirs

LEFT = Dot(-1, 0)
RIGHT = Dot(1, 0)
UP = Dot(0, 1)
DOWN = Dot(0, -1)
LU = Dot(-1, 1)
RU = Dot(1, 1)
LD = Dot(-1, -1)
RD = Dot(1, -1)

DIRECTIONS = {
  LEFT, RIGHT, UP, DOWN, LU, RU, LD, RD
}
HORIZEN_DIRS = {LEFT, RIGHT}
VERTICAL_DIRS = {UP, DOWN}
STRAIGHT_DIRS = {
  LEFT, RIGHT, UP, DOWN
}
DIAGONAL_DIRS = {
  LU, RU, LD, RD
}