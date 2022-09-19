isStraightDir = (dir) -> dir.x*dir.y == 0
isDiagonalDir = (dir) -> not isStraightDir(dir)

{
  :isStraightDir
  :isDiagonalDir
  isHorizenDir: (dir) -> dir.y == 0
  isVerticalDir: (dir) -> dir.x == 0
  calcManhattanDist: (da, db) -> math.abs(da.x-db.x)+math.abs(da.y-db.y)
  getDiagonalSplit: (dir) ->
    if dir\equal(LU)
      {LEFT, UP}
    elseif dir\equal(RU)
      {RIGHT, UP}
    elseif dir\equal(LD)
      {LEFT, DOWN}
    elseif dir\equal(RD)
      {RIGHT, DOWN}
}