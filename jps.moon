require 'def'
UT = require 'util'
MAP = require 'map'

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
  for v in DIAGONAL_SPLIT[pdir]
    vdot = pdot\add(v)
    continue unless map\isDotObstacle(vdot)
    ndot = vdot\add(v)
    continue unless MAP\isDotAvailable(ndot)
    rst = rst or {}
    table.insert(rst, ndot)
  rst ~= nil, rst
findJumpPoint_Straight = (pnode, dir, e) ->
  d = Dot(pnode.dotdot.x, pnode.dot.y)
  g = pnode.g
  availableDirs = {dir}
  jpnode = JPSNode(availableDirs, d, pnode)
  flag = false
  while true
    d\add(dir)
    break unless MAP\isDotAvailable(d)
    g += MAP.STRAIGHT_DIST
    ok, fns = if e\equal(d)
      true, nil
    else
      findForceNeighbor_straight(d, dir)
    if ok
      for v in *fns do table.insert(jpnode.availableDirs, v\sub(d)) unless fns == nil
      jpnode.dot = d
      jpnode\setCost(g, UT.calcManhattanDist(d, e))
      flag = true
      break
  return flag, jpnode
findJumpPoint_Diagonal = (pnode, dir, e) ->
  d = Dot(pnode.dot.x, pnode.dot.y)
  g = pnode.g
  availableDirs = {dir}
  jpnode = JPSNode(availableDirs, d, pnode)
  flag = false
  while true
    d = dot\add(dir)
    break unless MAP\isDotAvailable(d)
    g += MAP.DIAGONAL_DIST
    ok, fns = if d\equal(e)
      true, nil
    else
      findForceNeighbor_diagonal(d, dir)
    if ok
      for v in *fns do table.insert(jpnode.availableDirs, v\sub(d)) unless fns == nil
      jpnode.dot = d
      jpnode\setCost(g, UT.calcManhattanDist(d, e))
      flag = true
      break
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
findJumpPoint = (dot, dir, e) ->
  jps = {}
  if UT.isStraightDir(dir)
    ok, jp, fns = findJumpPoint_Straight(dot, dir, e)
    table.insert(jps, jp) if ok
  else
    while true

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
    for dir in *node.availableDirs
      ok, dots = findJumpPoint(node.dot, dir, e)
      continue unless ok
      for v in *dots
        g = UT.calcManhattanDist(v, s)
        n = Node(v, g, e, node)
        hopen\insert(n)

MAP\init!
print(MAP\dump!)
ok, dots = findJumpPoint(Dot(20, 3), LEFT)
print(ok)
for v in *dots do print(v\tostring!) if ok