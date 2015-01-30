require("util/helper")

Segment = class("Segment")

function Segment:__init(a, b, c)
  self.a = a
  self.b = b
  self.color = c
end

function Segment:draw(scale)
  love.graphics.line({self.a.x*scale, self.a.y*scale, self.b.x*scale, self.b.y*scale})
end

function Segment:getSqLenght()
  return (self.a.x-self.b.x)*(self.a.x-self.b.x) + (self.a.y-self.b.y)*(self.a.y-self.b.y)
end

function Segment:getLenght()
  return math.sqrt(self:getSqLenght())
end