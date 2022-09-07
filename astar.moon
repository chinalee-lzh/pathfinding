require 'def'

UT = require 'util'
MAP = require 'map'
Heap = require 'heap'

compare = (a, b) -> a.f < b.f
add2dict = (d, dot, node) ->
  d[dot.x] = d[dot.x] or {}
  d[dot.x][dot.y] = node
indict = (d, dot) ->
  return false if d[dot.x] == nil
  node = d[dot.x][dot.y]
  node ~= nil, node
dump = (node, out) ->
  while node ~= nil
    table.insert(out, node.dot\tostring!)
    node = node.parent
  print(table.concat(out, ' <- '))
astar = (s, e) ->
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
    add2dict(dclosed, node.dot, node)
    for dir in *DIRECTIONS
      dot = node.dot\add(dir)
      if dot\equal(e)
        out = {dot\tostring!}
        return dump(node, out)
      continue unless MAP\isDotAvailable(dot)
      continue if indict(dclosed, dot)
      newg = if UT.isStraightDir(dir)
        node.g+MAP.STRAIGHT_DIST
      else
        node.g+MAP.DIAGONAL_DIST
      ok, n = indict(dopen, dot)
      if ok
        f = newg+n.h
        if f < n.f
          n\update(newg, f, node)
          n.idxheep = lopen\update(n.idxheep, -1)
      else
        n = Node(dot, newg, e, node)
        n.idxheep = lopen\insert(n)

MAP\init!
print(MAP\dump!)
astar(Dot(9, 3), Dot(9, 11))