_MAP_SIZE_ = {5, 5}
_STRAIGHT_DIST = 1
_DIAGONAL_DIST = math.sqrt(2)
map = {}
initMap = ->
  for i = 1, _MAP_SIZE_[1]
    map[i] = {}
    for j = 1, _MAP_SIZE_[2]
      map[i][j] = 0
  for i = 1, 3
    for j = 3, 4
      map[i][j] = 1
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
    @h = math.abs(e.x-dot.x)+math.abs(e.y-dot.y)
    @f = @g+@h
    @parent = parent

_LEFT = Dot(0, -1)
_RIGHT = Dot(0, 1)
_UP = Dot(-1, 0)
_DOWN = Dot(1, 0)
_LU = Dot(-1, -1)
_RU = Dot(-1, 1)
_LD = Dot(1, -1)
_RD = Dot(1, 1)
_DIRECTIONS = {
  _LEFT, _RIGHT, _UP, _DOWN, _LU, _RU, _LD, _RD
}

isStraightDir = (dir) -> dir.x*dir.y == 0
isDotValid = (d) -> (d.x > 0 and d.x <= _MAP_SIZE_[1]) and (d.y > 0 and d.y <= _MAP_SIZE_[2])
isDotAvailable = (d) -> isDotValid(d) and map[d.x][d.y] == 0
popLowestCost = (l) ->
  x, idx = math.huge, 0
  for i, n in ipairs(l)
    if n.f < x
      x = n.f
      idx = i
  table.remove(l, idx)
isDotInList = (l, dot) ->
  for v in *l
    return true, v if v.dot\equal(dot)
  false
dump = (node, out) ->
  while node ~= nil
    table.insert(out, node.dot\tostring!)
    node = node.parent
  print(table.concat(out, ' <- '))
astar = (s, e) ->
  return if s\equal(e)
  lopen = {}
  lclosed = {}
  table.insert(lopen, Node(s, 0, e))
  while true
    return if #lopen == 0
    node = popLowestCost(lopen)
    table.insert(lclosed, node)
    for dir in *_DIRECTIONS
      dot = node.dot\add(dir)
      if dot\equal(e)
        out = {dot\tostring!}
        return dump(node, out)
      continue unless isDotAvailable(dot)
      continue if isDotInList(lclosed, dot)
      newg = if isStraightDir(dir)
        node.g+_STRAIGHT_DIST
      else
        node.g+_DIAGONAL_DIST
      ok, n = isDotInList(lopen, dot)
      if ok
        f = newg+n.h
        if f < n.f
          n.g = newg
          n.f = f
          n.parent = node
      else
        table.insert(lopen, Node(dot, newg, e, node))

initMap!
astar(Dot(1, 1), Dot(1, 5))