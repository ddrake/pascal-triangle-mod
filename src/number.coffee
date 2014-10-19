canvWidth = null   # canvas width
canvHeight = null  # canvas widthheight
rowCount = null    # number of hexagons in the bottom row of pascal's triangle
hexPixels = null   # width of a hexagon
d1 = null          # half-width of a hexagon
d2 = null          # fourth-height of a hexagon
modBase = null     # base for modBase calculation
modColors = ['#fff','#00f','#0f0','#f00','#099','#909','#990','#39b','#3b9','#93b','#9b3','#b39','#b93']
tri = null

# The Canvas and Graphics context.
canv = document.getElementById 'canv'
ctx = canv.getContext "2d"

# call this to size the html elements if the canvas dimension changes.
setLayout = (e) ->
  hexPixels = Math.floor(canvWidth / (rowCount+1))
  d1 = hexPixels / 2
  d2 = d1 / Math.sqrt(3.0)
  canvHeight = canvWidth * Math.sqrt(3) / 2 + d2
  canv.width = canvWidth;
  canv.height = canvHeight;

# clear the canvas and set the fill color for points
clear = () ->
  ctx.fillStyle = "#000"
  ctx.fillRect 0, 0, canv.width, canv.height
  ctx.fillStyle = "#fff"

# Get the coordinates of the mouse cursor relative to the canvas
getMousePos = (canvas, evt) ->
    rect = canvas.getBoundingClientRect()
    x: evt.clientX - rect.left
    y: evt.clientY - rect.top

# If the mouse moves, update the Entry text with its value, if any
canv.addEventListener 'mousemove', (evt) ->
    mousePos = getMousePos(canv, evt)
    val = getValue(mousePos)
    $("#val").html(val)
  ,false

# Calculate N choose K somewhat efficiently
nCk = (n, k) ->
  if n is 0 or k is 0 or k is n then 1
  else
    kp = if k > n/2 then n-k else k
    num = [n-kp+1..n].reduce((x,y) -> x*y)
    den = [1..kp].reduce((x,y) -> x*y)
    num / den

# The reverse mapping from an (x,y) point to an (n,k) integer pair is tricky
# because the "region" in the (n,k)-plane isn't necessarily a hexagon.
# Get approximate values napr and kapr by supposing that (x,y) is the center of the (n,k) hexagon
# The real point could be there, but it could also be in the (n+1,k), (n,k+1) or (n+1,k+1) hexagons.
# so try all possibilities
getNK = (x, y) ->
  x0 = canvWidth / 2
  napr = (y-2*d2) / 3 / d2
  kapr = (x-x0+napr*d1)/2/d1
  nu = Math.floor(napr)
  ku = Math.floor(kapr)
  if testPoint(x,y,x0,nu,ku) then {n: nu, k: ku}
  else if testPoint(x,y,x0,nu+1,ku) then {n: nu+1, k: ku}
  else if testPoint(x,y,x0,nu+1,ku+1) then { n: nu+1, k: ku+1}
  else if testPoint(x,y,x0,nu,ku+1) then {n: nu, k: ku+1}
  else {n: 'bad', k: 'bad'}

# test the point (x,y) to see if it is in the row n, column k hexagon 
testPoint = (x,y,x0,n,k) ->
  e1 = x0+(2*k-n)*d1
  e2 = (x-x0)*(d2/d1) + 4*n*d2 - 2*k*d2
  e3 = (x0-x)*(d2/d1) + 2*n*d2 + 2*k*d2
  c1 = x >= e1-d1 and x <= e1+d1
  c2 = y >= e2 and y <= e2+4*d2
  c3 = y >= e3 and y <= e3+4*d2
  c1 and c2 and c3
  
# Compute the value of the hexagon at the mouse cursor
getValue = (mousePos) ->
  {n,k} = getNK(mousePos.x, mousePos.y)
  "Entry: " + 
  if n >= k and k >= 0 and n <= rowCount 
  then n + "C" + k + " = " + Math.round(nCk(n, k)) + "<br/>" + tri[n][k] + " (mod " + modBase + ")" 
  else "n/a"

# compute a row of the table from the row above it.  works for all rows after the zeroth
# [1, 2, 1] -> [1, 3, 3, 1] -> [1, 4, 6, 4, 1]
makeRow = (prev) ->
  a2 = ((prev[n] + prev[n+1])%modBase for n in [0..prev.length-2])
  a2.push(1)
  a2.unshift(1)
  a2

# construct a nested array containing the remainders mod the current base of the numbers in pascals triangle
buildTriangle = (max) ->
  results = [[1]]
  current = [1, 1]
  results.push(current)
  n = 1
  while n < max
    current = makeRow(current)
    results.push(current)
    n += 1
  results

# draw all the hexagons for the triaingle
draw_hexagons = (triangle) ->
  startX = canvWidth / 2
  startY = 0
  draw_row(startX-i*d1, startY+i*(3*d2), triangle[i]) for i in [0...triangle.length]

# draw a row of hexagons for the triangle
draw_row = (startX, startY, row) ->
  draw_hexagon(startX+2*d1*i, startY, modColors[row[i]]) for i in [0...row.length]

# draw a single hexagon with the specified location and fill color
draw_hexagon = (x,y,fillColor) -> 
  ctx.fillStyle = fillColor
  ctx.strokeStyle = '#999'
  ctx.beginPath()
  ctx.moveTo(x, y)
  ctx.lineTo(x+d1,y+d2)
  ctx.lineTo(x+d1,y+3*d2)
  ctx.lineTo(x,y+4*d2)
  ctx.lineTo(x-d1,y+3*d2)
  ctx.lineTo(x-d1,y+d2)
  ctx.closePath()
  ctx.fill() 
  ctx.lineWidth = 1
  ctx.stroke() 

# handle slider change events
$("#rows" ).change () ->
  rowCount = parseInt($(this).val())
  $("#lrows").html(rowCount)
  refresh()
  true

$("#modBase" ).change () ->
  modBase = parseInt($(this).val())
  $("#lmodBase").html(modBase)
  refresh()
  true

$("#canvWidth" ).change () ->
  canvWidth = parseInt($(this).val())
  $("#lcanvWidth").html(canvWidth)
  refresh()
  true

refresh = () ->
  setLayout()
  clear()
  tri = buildTriangle(rowCount)
  draw_hexagons(tri)

window.onload = () ->
  rowCount = parseInt($("#rows").val())
  modBase = parseInt($("#modBase").val())
  canvWidth = parseInt($("#canvWidth").val())
  refresh()
