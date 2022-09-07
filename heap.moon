class Heap
  isIdxValid = (idx) => idx >= 0 and idx < @pt
  compare = (a, b) => if @fcompare == nil then a < b else (@fcompare)(a, b)
  swap = (i, j) => @cache[i], @cache[j] = @cache[j], @cache[i]
  adjustUp = (idx) =>
    value = @at(idx)
    while true
      break unless idx > 0
      pidx = (idx-1)//2
      break unless compare(@, value, @at(pidx))
      swap(@, idx, pidx)
      idx = pidx
    idx
  adjustDown = (idx) =>
    value = @at(idx)
    while true
      lidx = idx*2+1
      ridx = idx*2+2
      lvalue = @at(lidx)
      rvalue = @at(ridx)
      break if lvalue == nil or (not compare(@, lvalue, value) and (rvalue == nil or not compare(@, rvalue, value)))
      newidx = if rvalue == nil
        lidx
      else
        compare(@, lvalue, rvalue) and lidx or ridx
      swap(@, idx, newidx)
      idx = newidx
    idx

  new: (fcompare) =>
    @cache = {}
    @pt = 0
    @fcompare = fcompare
  at: (idx) => return @cache[idx] if isIdxValid(@, idx)
  size: => @pt
  insert: (value) =>
    idx = @pt
    @pt += 1
    @cache[idx] = value
    adjustUp(@, idx)
  pop: =>
    return if @size! == 0
    popvalue = @cache[0]
    @pt -= 1
    if @size! > 0
      @cache[0] = @cache[@pt]
      adjustDown(@, 0)
    popvalue
  update: (idx, dir) =>
    return unless idx >= 0 and idx < @pt
    return if dir == 0
    if dir < 0
      adjustUp(@, idx)
    else
      adjustDown(@, idx)
  dump: =>
    out = {}
    for i = 0, @pt-1 do table.insert(out, @at(i))
    table.concat(out, '-')