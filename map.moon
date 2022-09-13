_MAP_SIZE_ = {20, 14}
{
  STRAIGHT_DIST: 1
  DIAGONAL_DIST: math.sqrt(2)
  init: =>
    @pts = {}
    for i = 1, _MAP_SIZE_[1]
      @pts[i] = {}
      for j = 1, _MAP_SIZE_[2]
        @pts[i][j] = 0
    for i = 12, 13 do @pts[11][i] = 1
    for i = 9, 13 do @pts[i][4] = 1
    for i = 9, 13 do @pts[i][9] = 1
    for i = 4, 9 do @pts[9][i] = 1
  isValid: (x, y) => x > 0 and x <= _MAP_SIZE_[1] and y > 0 and y <= _MAP_SIZE_[2]
  isAvailable: (x, y) => @isValid(x, y) and @pts[x][y] == 0
  isDotAvailable: (dot) => @isAvailable(dot.x, dot.y)
  isObstacle: (x, y) => @isValid(x, y) and @pts[x][y] == 1
  isDotObstacle: (dot) => @isObstacle(dot.x, dot.y)
  dump: =>
    out = {}
    for j = _MAP_SIZE_[2], 1, -1
      line = {}
      for i = 1, _MAP_SIZE_[1] do table.insert(line, @pts[i][j])
      table.insert(out, table.concat(line, ' '))
    table.concat(out, '\n')
}