require("util/helper")

Player = class("Player")

function Player:__init(x, y)
  self.x = x
  self.y = y
  self.fov = 80
  self.angle = 0
end

