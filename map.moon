_MAP_SIZE_ = {14, 20}
{
  STRAIGHT_DIST: 1
  DIAGONAL_DIST: math.sqrt(2)
  init: =>
    for i = 1, _MAP_SIZE_[1]
      @[i] = {}
      for j = 1, _MAP_SIZE_[2]
        @[i][j] = 0
    for i = 2, 3 do @[i][11] = 1
    for i = 9, 13 do @[6][i] = 1
    for i = 6, 11 do @[i][9] = 1
    for i = 9, 13 do @[11][i] = 1
  isAvailable: (x, y) => x > 0 and x < _MAP_SIZE_[1] and y > 0 and y < _MAP_SIZE_[2] and @[x][y] == 0
  isDotAvailable: (dot) => @isAvailable(dot.x, dot.y)
  dump: =>
    out = {}
    for i = 1, _MAP_SIZE_[1]
      line = {}
      for j = 1, _MAP_SIZE_[2] do table.insert(line, @[i][j])
      table.insert(out, table.concat(line, ' '))
    table.concat(out, '\n')
}