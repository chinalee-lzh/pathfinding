export ^

class Dot
  new: (x, y) =>
    @x = x or 0
    @y = y or 0
  equal: (d) => @x == d.x and @y == d.y
  add:(d) => Dot(@x+d.x, @y+d.y)
  tostring: => "[#{@x}, #{@y}]"
class Node
  new: (dot, g, e, parent) =>
    @dot = dot
    @g = g
    @parent = parent
    @h = math.abs(e.x-dot.x)+math.abs(e.y-dot.y)
    @f = @g+@h
    @idxheep = -1
  updateG: (g, f, parent) =>
    @g = g
    @f = f
    @parent = parent
  __eq: (n) => @f == n.h
  __lt: (n) => @f < n.h
  __le: (n) => @f <= n.h

LEFT = Dot(0, -1)
RIGHT = Dot(0, 1)
UP = Dot(-1, 0)
DOWN = Dot(1, 0)
LU = Dot(-1, -1)
RU = Dot(-1, 1)
LD = Dot(1, -1)
RD = Dot(1, 1)

DIRECTIONS = {
  LEFT, RIGHT, UP, DOWN, LU, RU, LD, RD
}

DIAGONAL_SPLIT = {
  LU: {LEFT, UP}
  RU: {RIGHT, UP}
  LD: {LEFT, DOWN}
  RD: {RIGHT, DOWN}
}