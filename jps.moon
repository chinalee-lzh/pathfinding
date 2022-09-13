require 'def'
UT = require 'util'
MAP = require 'map'

compare = (a, b) -> a.f < b.f
checkForceNeighbor = (currx, curry, currdir, dirs) ->
  for v in *dirs
    vx, vy = currx+v.x, curry+v.y
    if MAP\isObstacle(vx, vy)
      nx, ny = vx+currdir.x, vy
      return true if MAP\isAvailable(nx, ny)
  false
findJumpPoint_Straight = (dot, dir, e) ->
  x, y = dot.x, dot.y
  dirs = if UT.isHorizenDir(dir)
    VERTICAL_DIRS
  else
    HORIZEN_DIRS
  while true
    currx, curry = x+dir.x, y+dir.y
    d = Dot(currx, curry)
    return true, {d} if e\equal(d)
    return false unless MAP\isAvailable(currx, curry)
    if checkForceNeighbor(currx, curry, dir, dirs)
      return true, {d}
    else
      x, y = currx, curry
findJumpPoint_Diagonal = (dot, dir, e) ->
  while true
    d = dot\add(dir)
    return true, {d} if d\equal(e)
    jps = {}
    for v in *DIAGONAL_SPLIT[dir]
      ok, jp = findJumpPoint_Straight(d, v)
      table.insert(jps, jp) if ok
    return #jps > 0, jps
findJumpPoint = (dot, dir, e) ->
  if UT.isStraightDir(dir)
    findJumpPoint_Straight(dot, dir, e)
  else
    findJumpPoint_Diagonal(dot, dir, e)
dump = (node, out) ->
  out = out or {}
  while node ~= nil
    table.insert(out, node.dot\tostring!)
    node = node.parent
  print(table.concat(out, ' <- '))
jps = (s, e) ->
  return print('s or e invalid') unless MAP\isDotAvailable(s) and MAP\isDotAvailable(e)
  return print('s equal e') if s\equal(e)
  lopen, dopen = Heap(compare), {}
  lclosed, dclosed = {}, {}
  snode = Node(s, 0, e)
  snode.idxheep = lopen\insert(snode)
  add2dict(dopen, s, snode)
  while true
    return if lopen\size! == 0
    node = lopen\pop!
    return dump(node) if node.dot\equal(e)
    add2dict(dclosed, node.dot, node)
    for dir in *STRAIGHT_DIR
      ok, dots = findJumpPoint(node.dot, dir, e)
      continue unless ok
      for v in *dots
        g = UT.calcManhattanDist(v, s)
        n = Node(v, g, e, node)
        lopen\insert(n)

MAP\init!
print(MAP\dump!)
ok, dots = findJumpPoint(Dot(20, 3), LEFT)
print(ok)
for v in *dots do print(v\tostring!) if ok