power = math.power
_MAP_SIZE_M = 10
_MAP_SIZE_N = 7
getMatrix = ->
  m = {}
  for i = 0, _MAP_SIZE_M-1
    m[i] = {}
    for j = 0, _MAP_SIZE_N-1
      m[i][j] = 1
  m
dump = (m) ->
  for i = 0, _MAP_SIZE_N-1
    out = {}
    for j = 0, _MAP_SIZE_M-1
      s = tostring(m[j][i])
      s ..= ' ' if m[j][i] < 10
      table.insert(out, s)
    print(table.concat(out, '  '))
initMap = ->
  map = getMatrix!
  for i = 2, 3 do map[3][i] = 0
  for i = 1, 5 do map[4][i] = 0
  for i = 2, 3 do map[5][i] = 0
  map
calcDT = (x, i, y, g) -> math.floor((x-i)^2+g[i][y]^2)
calcSep = (i, u, y, g) -> (u^2-i^2+g[u][y]^2-g[i][y]^2)/(2*(u-i))
meijster = (map) ->
  print('map')
  dump(map)
  rst = getMatrix!
  g = getMatrix!
  for i = 0, _MAP_SIZE_M-1
    g[i][0] = if map[i][0] == 0
      0
    else
      _MAP_SIZE_M+_MAP_SIZE_N
    for j = 1, _MAP_SIZE_N-1
      g[i][j] = if map[i][j] == 0
        0
      else
        g[i][j-1]+1
    for j = _MAP_SIZE_N-2, 0, -1
      if g[i][j+1] < g[i][j]
        g[i][j] = g[i][j+1]+1
  print('g')
  dump(g)
  for y = 0, _MAP_SIZE_N-1
    q, s, t = 0, {}, {}
    s[q], t[q] = 0, 0
    for u = 1, _MAP_SIZE_M-1
      while q >= 0 and calcDT(t[q], s[q], y, g) > calcDT(t[q], u, y, g)
        q -= 1
      if q < 0
        q = 0
        s[0] = u
      else
        w = math.floor(1+calcSep(s[q], u, y, g))
        if w < _MAP_SIZE_M
          q += 1
          s[q] = u
          t[q] = w
    for u = _MAP_SIZE_M-1, 0, -1
      rst[u][y] = calcDT(u, s[q], y, g)
      q -= 1 if u == t[q]
  print('rst')
  dump(rst)

map = initMap!
meijster(map)