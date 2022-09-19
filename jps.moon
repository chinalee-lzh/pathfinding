require 'def'
UT = require 'util'
MAP = require 'map'
Heap = require 'heap'

compare = (a, b) -> a.f < b.f
findForceNeighbor_straight = (dot, pdir) ->
  local rst
  checkdirs = if UT.isHorizenDir(pdir)
    VERTICAL_DIRS
  else
    HORIZEN_DIRS
  for v in *checkdirs
    vdot = dot\add(v)
    continue unless MAP\isDotObstacle(vdot)
    ndot = vdot\add(pdir)
    continue unless MAP\isDotAvailable(ndot)
    rst = rst or {}
    table.insert(rst, ndot)
  rst ~= nil, rst
findForceNeighbor_diagonal = (dot, pdir) ->
  local rst
  pdot = dot\sub(pdir)
  for v in *UT.getDiagonalSplit(pdir)
    vdot = pdot\add(v)
    continue unless MAP\isDotObstacle(vdot)
    ndot = vdot\add(v)
    continue unless MAP\isDotAvailable(ndot)
    rst = rst or {}
    table.insert(rst, ndot)
  rst ~= nil, rst
findJumpPoint_Straight = (dot, dir, e) ->
  d = Dot(dot.x, dot.y)
  g = 0
  jumpDirs = {dir}
  ok = false
  while true
    d = d\add(dir)
    break unless MAP\isDotAvailable(d)
    g += MAP.STRAIGHT_DIST
    ok, fns = if d\equal(e)
      true, {}
    else
      findForceNeighbor_straight(d, dir)
    if ok
      for v in *fns do table.insert(jumpDirs, v\sub(d))
      break
  return ok, d, jumpDirs, g
findJumpPoint_Diagonal = (dot, dir, e) ->
  d = Dot(dot.x, dot.y)
  g = 0
  jumpDirs = {dir}
  ok = false
  while true
    d = d\add(dir)
    break unless MAP\isDotAvailable(d)
    g += MAP.DIAGONAL_DIST
    ok, fns = if d\equal(e)
      true, {}
    else
      findForceNeighbor_diagonal(d, dir)
    if ok
      for v in *fns do table.insert(jumpDirs, v\sub(d))
      for v in *UT.getDiagonalSplit(dir) do table.insert(jumpDirs, v)
    else
      for v in *UT.getDiagonalSplit(dir)
        flag, djp, dirs = findJumpPoint_Straight(d, v, e)
        table.insert(jumpDirs, v) if flag
        ok = ok or flag
    break if ok
  return ok, d, jumpDirs, g
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
add2dict = (d, dot, node) ->
  d[dot.x] = d[dot.x] or {}
  d[dot.x][dot.y] = node
indict = (d, dot) ->
  return false if d[dot.x] == nil
  node = d[dot.x][dot.y]
  node ~= nil, node
jps = (s, e) ->
  return print('s or e invalid') unless MAP\isDotAvailable(s) and MAP\isDotAvailable(e)
  return print('s equal e') if s\equal(e)
  hopen, dopen = Heap(compare), {}
  lclosed, dclosed = {}, {}
  snode = JPSNode(DIRECTIONS, s)\setCost(0, UT.calcManhattanDist(s, e))
  snode.idxheep = hopen\insert(snode)
  add2dict(dopen, s, snode)
  while true
    return if hopen\size! == 0
    node = hopen\pop!
    return dump(node) if node.dot\equal(e)
    add2dict(dclosed, node.dot, node)
    for dir in *node.jumpDirs
      ok, d, jumpDirs, g = findJumpPoint(node.dot, dir, e)
      continue unless ok
      ok, n = indict(dopen, d)
      newg = node.g+g
      if ok
        print('----------------- find already in dopen')
        newf = newg+n.h
        if newf < node.f
          n\setCost(newg, n.h)
          n.idxheep = hopen\update(n.idxheep, -1)
      else
        jpnode = JPSNode(jumpDirs, d, node)\setCost(newg, UT.calcManhattanDist(d, e))
        jpnode.idxheep = hopen\insert(jpnode)
MAP\init!
print(MAP\dump!)
jps(Dot(3, 7), Dot(11, 7))
-- ok, d, jumpDirs, g = findJumpPoint(Dot(20, 3), LU, Dot(17, 3))
-- print(ok)
-- if ok
--   print(d\tostring!)
--   print('jump dirs')
--   for v in *jumpDirs do print("  #{v\tostring!}")
--   print('g =', g)