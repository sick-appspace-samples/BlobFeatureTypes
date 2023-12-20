
--Start of Global Scope---------------------------------------------------------

print('AppEngine Version: ' .. Engine.getVersion())

local DELAY = 2000 -- ms between each type for demonstration purpose

-- Viewer
local viewer = View.create()

-- Decorations
local regionDecoration = View.PixelRegionDecoration.create()
regionDecoration:setColor(0, 255, 0, 100) -- Green with transparency

local lineDecoration = View.ShapeDecoration.create()
lineDecoration:setLineColor(0, 230, 0)
lineDecoration:setLineWidth(2) -- Green

local pointDecoration = View.ShapeDecoration.create()
pointDecoration:setLineColor(0, 230, 0) -- Green
pointDecoration:setPointSize(10)
pointDecoration:setPointType('DOT')

local headerTextDecoration = View.TextDecoration.create()
headerTextDecoration:setSize(30)

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

---Help function to print feature values for each blob
---@param x float
---@param y float
---@param text string
local function addFeatureText(x, y, text)
  local textDeco = View.TextDecoration.create()
  textDeco:setColor(0, 0, 230)
  textDeco:setSize(15)
  textDeco:setPosition(x, y)
  viewer:addText(text, textDeco)
end

---Area
local function area()
  viewer:clear()
  local img = Image.load('resources/CompactnessArea.bmp')
  img = img:toGray()
  img = img:binarize(150, 255)
  viewer:addImage(img)
  headerTextDecoration:setPosition(400, 220)
  viewer:addText('Area', headerTextDecoration)

  -- Finding blobs
  local objectRegion = img:threshold(0, 150)
  local blobs = objectRegion:findConnected(100)

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local feature = blobs[i]:getArea(img)
    local box = blobs[i]:getBoundingBoxOriented(img)
    local center, _, _, _ = box:getRectangleParameters()
    -- Graphics
    viewer:addPixelRegion(blobs[i], regionDecoration)
    addFeatureText(center:getX() - 40, center:getY() + 70, 'A = ' .. math.floor(feature))
  end
  viewer:present()
end

---Centroid
local function centroid()
  viewer:clear()
  local img = Image.load('resources/ElongationCentroid.bmp')
  img = img:toGray()
  img = img:binarize(150, 255)
  viewer:addImage(img)

  headerTextDecoration:setPosition(380, 220)
  viewer:addText('Centroid', headerTextDecoration)

  -- Finding blobs
  local objectRegion = img:threshold(0, 150)
  local blobs = objectRegion:findConnected(100)

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local feature = blobs[i]:getCenterOfGravity(img)

    -- Graphics
    viewer:addShape(feature, pointDecoration)
    local str = '(' ..  math.floor(feature:getX()) .. ',' .. math.floor(feature:getY()) .. ')'
    addFeatureText(feature:getX() - 40, feature:getY() + 70, str)
  end
  viewer:present()
end

---Elongation
local function elongation()
  viewer:clear()
  local img = Image.load('resources/ElongationCentroid.bmp')
  img = img:toGray()
  img = img:binarize(150, 255)
  viewer:addImage(img)

  headerTextDecoration:setPosition(350, 220)
  viewer:addText('Elongation', headerTextDecoration)

  -- Finding blobs
  local objectRegion = img:threshold(0, 150)
  local blobs = objectRegion:findConnected(100)

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local feature = blobs[i]:getElongation(img)
    local box = blobs[i]:getBoundingBoxOriented(img)
    local center, _, _, _ = box:getRectangleParameters()
    -- Graphics
    viewer:addShape(box, lineDecoration)
    addFeatureText(center:getX() - 30, center:getY() + 70, 'E = ' .. math.floor(feature * 10) / 10)
  end
  viewer:present()
end

---Convexity
local function convexity()
  viewer:clear()
  local img = Image.load('resources/Convexity.bmp')
  img = img:toGray()
  img = img:binarize(150, 255)
  viewer:addImage(img)

  headerTextDecoration:setPosition(370, 220)
  viewer:addText('Convexity', headerTextDecoration)

  -- Finding blobs
  local objectRegion = img:threshold(0, 150)
  local blobs = objectRegion:findConnected(100)

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local feature = blobs[i]:getConvexity()
    local border = blobs[i]:getBorderRegion()
    border = border:dilate(5)
    local box = blobs[i]:getBoundingBoxOriented(img)
    local center, _, _, _ = box:getRectangleParameters()
    -- Graphics
    viewer:addPixelRegion(border, regionDecoration)
    addFeatureText(center:getX() - 30, center:getY() + 70, 'C = ' .. math.floor(feature * 10) / 10)
  end
  viewer:present()
end

---Perimeter length
local function perimeterLength()
  viewer:clear()
  local img = Image.load('resources/PerimeterLength.bmp')
  img = img:toGray()
  img = img:binarize(150, 255)
  viewer:addImage(img)

  headerTextDecoration:setPosition(280, 220)
  viewer:addText('Perimeter length', headerTextDecoration)

  -- Finding blobs
  local objectRegion = img:threshold(0, 150)
  objectRegion = objectRegion:fillHoles()
  local blobs = objectRegion:findConnected(100)

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local feature = blobs[i]:getPerimeterLength(img)
    local border = blobs[i]:getBorderRegion()
    border = border:dilate(5)
    local box = blobs[i]:getBoundingBoxOriented(img)
    local center, _, _, _ = box:getRectangleParameters()

    -- Graphics
    viewer:addPixelRegion(border, regionDecoration)
    addFeatureText(center:getX() - 40, center:getY() + 70, 'P = ' .. math.floor(feature))
  end
  viewer:present()
end

---Compactness
local function compactness()
  viewer:clear()
  local img = Image.load('resources/CompactnessArea.bmp')
  img = img:toGray()
  img = img:binarize(150, 255)
  viewer:addImage(img)

  headerTextDecoration:setPosition(320, 220)
  viewer:addText('Compactness', headerTextDecoration)

  -- Finding blobs
  local objectRegion = img:threshold(0, 150)
  local blobs = objectRegion:findConnected(100)

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local feature = blobs[i]:getCompactness(img)
    local box = blobs[i]:getBoundingBoxOriented(img)
    local center, _, _, _ = box:getRectangleParameters()

    -- Graphics
    viewer:addPixelRegion(blobs[i], regionDecoration)
    addFeatureText(center:getX() - 40, center:getY() + 70, 'C = ' .. math.floor(feature * 100) / 100)
  end
  viewer:present()
end

---Convex hull
local function convexHull()
  viewer:clear()
  local img = Image.load('resources/ConvexHull.bmp')
  img = img:toGray()
  img = img:binarize(150, 255)
  viewer:addImage(img)

  headerTextDecoration:setPosition(350, 220)
  viewer:addText('Convex hull', headerTextDecoration)

  -- Finding blobs
  local objectRegion = img:threshold(0, 150)
  local blobs = objectRegion:findConnected(100)

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local feature = blobs[i]:getConvexHull()
    -- Graphics
    viewer:addPixelRegion(feature, regionDecoration)
  end
  viewer:present()
end

---Counting holes
local function countHoles()
  viewer:clear()
  local img = Image.load('resources/Holes.bmp')
  img = img:toGray()
  img = img:binarize(150, 255)
  viewer:addImage(img)

  headerTextDecoration:setPosition(350, 220)
  viewer:addText('Count holes', headerTextDecoration)

  -- Finding blobs
  local objectRegion = img:threshold(0, 150)
  local blobs = objectRegion:findConnected(100)

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local objectNoHoles = blobs[i]:fillHoles()
    local objectHoles = objectNoHoles:getDifference(blobs[i])
    local feature = blobs[i]:countHoles()
    local center = blobs[i]:getCenterOfGravity(img)

    -- Graphics
    viewer:addPixelRegion(objectHoles, regionDecoration)
    addFeatureText(center:getX() - 20, center:getY() + 60, '# = ' .. feature)
  end
  viewer:present()
end

---Orientation (principal axes)
local function orientation()
  viewer:clear()
  local img = Image.load('resources/Convexity.bmp')
  img = img:toGray()
  img = img:binarize(150, 255)
  viewer:addImage(img)

  headerTextDecoration:setPosition(200, 220)
  viewer:addText('Orientation (principal axes)', headerTextDecoration)

  -- Finding blobs
  local objectRegion = img:threshold(0, 150)
  local blobs = objectRegion:findConnected(100)

  -- Analyzing each blob and visualizing the result
  for i = 1, #blobs do
    local angle,
      major,
      minor = blobs[i]:getPrincipalAxes(img)
    local center = blobs[i]:getCenterOfGravity(img)

    -- Plotting major axis
    local X = center:getX() + 2 * major * math.cos(angle)
    local Y = center:getY() + 2 * major * math.sin(angle)
    local endpointMajor = Point.create(X, Y)
    local majorAxis = Shape.createLineSegment(center, endpointMajor)
    viewer:addShape(majorAxis, lineDecoration)

    -- Plotting minor axis
    X = center:getX() + 2 * minor * math.cos(angle + 3.1415 / 2)
    Y = center:getY() + 2 * minor * math.sin(angle + 3.1415 / 2)
    local endpointMinor = Point.create(X, Y)
    local minorAxis = Shape.createLineSegment(center, endpointMinor)
    viewer:addShape(minorAxis, lineDecoration)

    -- Printing feature value
    addFeatureText(center:getX() - 50, center:getY() + 60, 'Deg = ' .. math.floor(math.deg(angle) * 10) / 10)
  end
  viewer:present()
end

---Looping through the functions
local function main()
  area()
  Script.sleep(DELAY) -- for demonstration purpose only
  centroid()
  Script.sleep(DELAY) -- for demonstration purpose only
  elongation()
  Script.sleep(DELAY) -- for demonstration purpose only
  convexity()
  Script.sleep(DELAY) -- for demonstration purpose only
  compactness()
  Script.sleep(DELAY) -- for demonstration purpose only
  perimeterLength()
  Script.sleep(DELAY) -- for demonstration purpose only
  convexHull()
  Script.sleep(DELAY) -- for demonstration purpose only
  countHoles()
  Script.sleep(DELAY) -- for demonstration purpose only
  orientation()
  print('App finished.')
end
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
