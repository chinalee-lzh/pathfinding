isStraightDir = (dir) -> dir.x*dir.y == 0
isDiagonalDir = (dir) -> not isStraightDir(dir)

{
  :isStraightDir
  :isDiagonalDir
  isHorizenDir: (dir) -> dir.y == 0
  isVerticalDir: (dir) -> dir.x == 0
  calcManhattanDist: (da, db) -> math.abs(da.x-db.x)+math.abs(da.y-db.y)
}