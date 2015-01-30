-- Maze
require("player")
require("util/vector")
require("util/segment")
require("util/gamestate")
require("util/resources")

Maze = class("Maze", GameState)

function Maze:__init(width, height, data, tileSize)
  self.width = width or 0
  self.height = height or 0
  self.data = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
      }
  self.segments = self:buildSegments()
  self.r1 = Vector(3,4)
  self.r2 = Vector(self.r1.x-1,self.r1.y)
  self.player = Player(1.5,1.5)
end

function Maze:update(dt)
  if love.keyboard.isDown("right") then self.player.angle = self.player.angle + dt*50 end
  if love.keyboard.isDown("left") then self.player.angle = self.player.angle - dt*50 end

  --if love.keyboard.isDown("a") then self.player.x = self.player.x - dt end
  --if love.keyboard.isDown("d") then self.player.x = self.player.x + dt end
  local q = Vector(self.player.x, self.player.y - dt)
  local angle = self.player.angle * (math.pi/180)
  local rX = math.cos(angle) * (q.x - self.player.x) - math.sin(angle) * (q.y - self.player.y) + self.player.x
  local rY = math.sin(angle) * (q.x - self.player.x) + math.cos(angle) * (q.y - self.player.y) + self.player.y

  if love.keyboard.isDown("up") then 
    self.player.x = rX
    self.player.y = rY
  end

  if love.keyboard.isDown("down") then 
    self.player.x = self.player.x - (rX -self.player.x)
    self.player.y = self.player.y - (rY - self.player.y)
  end
 --[[ local angle = dt * 70 * (math.pi/180)
  local rX = math.cos(angle) * (self.r2.x - self.r1.x) - math.sin(angle) * (self.r2.y - self.r1.y) + self.r1.x
  local rY = math.sin(angle) * (self.r2.x - self.r1.x) + math.cos(angle) * (self.r2.y - self.r1.y) + self.r1.y
  self.r2 = Vector(rX,rY)
]]
end

function Maze:keypressed(k, u)

end

function Maze:draw()
  local width, height =  love.graphics.getWidth(),  love.graphics.getHeight()
  love.graphics.setBackgroundColor(35, 35, 35)
  love.graphics.clear()
  love.graphics.setColor(50,50,50)
  love.graphics.rectangle("fill", 0, height/2, width, height/2)

  love.graphics.setColor(226,234,92)
  local q = Vector(self.player.x, self.player.y - 100)
  for i = 0, width do
    local angle = self.player.angle - self.player.fov/2 + self.player.fov/width * i
    angle = angle * (math.pi/180)
    local rX = math.cos(angle) * (q.x - self.player.x) - math.sin(angle) * (q.y - self.player.y) + self.player.x
    local rY = math.sin(angle) * (q.x - self.player.x) + math.cos(angle) * (q.y - self.player.y) + self.player.y
    local ray = self:raycast(Segment(Vector(self.player.x, self.player.y),Vector(rX,rY)))
    if (ray.color == "n") then love.graphics.setColor(255,0,0)
    elseif (ray.color == "s") then love.graphics.setColor(0,255,0)
    elseif (ray.color == "w") then love.graphics.setColor(0,0,255)
    elseif (ray.color == "e") then love.graphics.setColor(255,255,0)
    end
    local lineHeight = height/ray:getLenght();
    local startY = height/2 - lineHeight/2;
    love.graphics.line(i,startY, i, startY+lineHeight)
  end
  
  --love.graphics.setColor(0, 255, 255)
  --for i = 1, #self.segments do self.segments[i]:draw(15) end
  --[[local angle
  for angle = 0, math.pi, 0.1 do
    local rX = math.cos(angle) * (self.r2.x - self.r1.x) - math.sin(angle) * (self.r2.y - self.r1.y) + self.r1.x
    local rY = math.sin(angle) * (self.r2.x - self.r1.x) + math.cos(angle) * (self.r2.y - self.r1.y) + self.r1.y
    local ray = self:raycast(Segment(self.r1,Vector(rX,rY)))
    ray:draw(15)
  end]]
end

function Maze:checkPoint(x, y)
  return (self:getTile(math.floor(x), math.floor(y)) ~= 0)
end

function Maze:raycast(ray)

  local closest = nil
  for i = 1, #self.segments do
    local intersec = getIntersection(ray, self.segments[i])
    
    if (intersec ~= nil) then
      if (closest == nil or intersec.param<closest.param) then
        closest = intersec
        closest.color = self.segments[i].color
      end
    end
  end

  if (closest == nil) then 
    return ray
  else
    return Segment(ray.a, Vector(closest.x, closest.y), closest.color)
  end
end

function Maze:buildSegments()
  local segments = {} 
  for i = 1, #self.data do
      local x, y = (i-1)%self.width, math.floor((i-1)/self.height) + 1
      if (self.data[i] ~= 0) then
        table.insert(segments, Segment(Vector(x,y), Vector(x+1, y), "s"))
        table.insert(segments, Segment(Vector(x,y), Vector(x, y-1), "w"))
        table.insert(segments, Segment(Vector(x+1,y), Vector(x+1, y-1), "e"))
        table.insert(segments, Segment(Vector(x,y-1), Vector(x+1, y-1), "n"))
      end
  end
  return segments
end
