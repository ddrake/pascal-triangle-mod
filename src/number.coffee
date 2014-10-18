canvWidth = 600   # canvas dimension width=height
canvHeight = canvWidth * Math.sqrt(3) / 2
rowCount = 32    # number of hexagons in the bottom row of pascal's triangle
hexPixels = Math.floor(canvWidth / rowCount)
d1 = hexPixels / 2
d2 = d1 / Math.sqrt(3.0)
mod = 2

# The Canvas and Graphics context.
canv = document.getElementById 'canv'
ctx = canv.getContext "2d"

# call this to size the html elements if the canvas dimension changes.
setLayout = (e) ->
  canvHeight = canvWidth * Math.sqrt(3) / 2
  hexPixels = Math.floor(canvWidth / rowCount)
  d1 = hexPixels / 2
  d2 = d1 / Math.sqrt(3.0)
  canv.width = canvWidth;
  canv.height = canvHeight;

# clear the canvas and set the fill color for points
clear = () ->
  ctx.fillStyle = "#000"
  ctx.fillRect 0, 0, canv.width, canv.height
  ctx.fillStyle = "#fff"


# compute a row of the table from the row above it.  works for all rows after the zeroth
# [1, 2, 1] -> [1, 3, 3, 1] -> [1, 4, 6, 4, 1]
makeRow = (prev) ->
  a2 = ((prev[n] + prev[n+1])%mod for n in [0..prev.length-2])
  a2.push(1)
  a2.unshift(1)
  a2

buildTriangle = (max) ->
  results = [[1]]
  current = [1, 1]
  results.push(current)
  n = 1
  while n <= max
    current = makeRow(current)
    results.push(current)
    n += 1
  results

draw_hexagons = (triangle, func) ->
  startX = canvWidth / 2
  startY = 0
  draw_row(startX-i*d1, startY+i*(d1+d2), triangle[i], func) for i in [0...triangle.length]

draw_row = (startX, startY, row, func) ->
  draw_hexagon(startX+2*d1*i, startY, func(row[i]), '#fff') for i in [0...row.length]


draw_hexagon = (x,y,fillColor,strokeColor) -> 
  ctx.fillStyle = fillColor
  ctx.strokeStyle = strokeColor
  ctx.beginPath()
  ctx.moveTo(x, y)
  ctx.lineTo(x+d1,y+d2)
  ctx.lineTo(x+d1,y+d2+d1)
  ctx.lineTo(x,y+2*d2+d1)
  ctx.lineTo(x-d1,y+d2+d1)
  ctx.lineTo(x-d1,y+d2)
  ctx.closePath()
  ctx.fill() 
  ctx.lineWidth = 1
  ctx.stroke() 

colorMod2 = (x) ->
  if x is 0 then '#f00' else '#0f0'

colorMod3 = (x) ->
  if x is 0 then '#f00' else if x is 1 then'#0f0' else '#00f'

colorMod4 = (x) ->
  if x is 0 then '#f00' else if x is 1 then'#0f0' else if x is 2 then '#990' else '#909'

colorMod5 = (x) ->
  if x is 0 then '#f00' else if x is 1 then'#0f0' else if x is 2 then '#990' else if x is 3 then '#909' else '#099'

colorFunc = colorMod2

$("#rows" ).change () ->
  rowCount = parseInt($(this).val())
  refresh()
  true

$("#mod" ).change () ->
  mod = parseInt($(this).val())
  if mod is 2 then colorFunc = colorMod2 else if mod is 3 then colorFunc = colorMod3 else colorFunc = colorMod4;
  refresh()
  true

$("#size" ).change () ->
  canvWidth = parseInt($(this).val())
  refresh()
  true

refresh = () ->
  setLayout()
  clear()
  tri = buildTriangle(rowCount)
  draw_hexagons(tri, colorFunc)

window.onload = () ->
  refresh()

