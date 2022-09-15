require 'def'
UT = require 'util'
MAP = require 'map'

compare = (a, b) -> a.f < b.f
findForceNeighbor_straight = (dot, pdir, dirs) ->
  local rst
  for v in *dirs
    vdot = dot\add(v)
    continue unless MAP\isDotObstacle(vdot)
    ndot = vdot\add(pdir)
    continue unless MAP\isDotAvailable(ndot)
    rst = rst or {}
    table.insert(rst, ndot)
  rst
findForceNeighbor_diagonal = (dot, pdir) ->
  local rst
  pdot = dot\sub(pdir)
  for v in DIAGONAL_SPLIT[pdir]
    vdot = pdot\add(v)
    continue unless map\isDotObstacle(vdot)
    ndot = vdot\add(v)
    continue unless MAP\isDotAvailable(ndot)
    rst = rst or {}
    table.insert(rst, ndot)
  rst
findJumpPoint_Straight = (dot, dir, e) ->
  x, y = dot.x, dot.y
  dirs = if UT.isHorizenDir(dir)
    VERTICAL_DIRS
  else
    HORIZEN_DIRS
  while true
    currx, curry = x+dir.x, y+dir.y
    d = Dot(currx, curry)
    return true, d if e\equal(d)
    return false unless MAP\isAvailable(currx, curry)
    if checkForceNeighbor_straight(currx, curry, dir, dirs)
      return true, d
    else
      x, y = currx, curry
findJumpPoint = (dot, pdir, e) ->
  jps = {}
  for dir in *STRAIGHT_DIRS
    ok, jp = findJumpPoint_Straight(dot, dir, e)
    table.insert(jps, jp) if ok
  for dir in *DIAGONAL_DIRS
    while true 
      d = dot\add(dir)
      break unless MAP\isDotAvailable(d)
      if d\equal(e)
        table.insert(jps, jp)
        break
      else
        if checkForceNeighbor_diagonal(d.x, d.y, dir)
          table.insert(jps, d)
        else
          for v in *DIAGONAL_SPLIT[dir]
            ok, jp = findJumpPoint_Straight(d, v, e)
            table.insert(jps, jp) if ok
  return jps
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
  snode = Node(s)
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