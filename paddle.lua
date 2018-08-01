local paddle = {
  speed = 300,
  x = 0,
  y = 0,
  height = 60,
  width = 10
}

local reset = {
  x = 0,
  y = 0,
  speed = 300
}

function paddle:new(x, y, speed)
  assert(type(x) == "number")
  assert(type(y) == "number")
  assert(speed == nil or type(speed) == "number")

  local this = {}

  this.x = x or self.x
  this.y = y or self.y
  this.speed = speed or self.speed

  reset.x = x or reset.x
  reset.y = y or reset.y
  reset.speed = speed or reset.speed

  setmetatable(this, self)
  self.__index = self

  return this
end

function paddle:reset()
  self.x = reset.x
  self.y = reset.y
  self.speed = reset.speed
end

function paddle:updateControlled(dt)
  if love.keyboard.isDown("w") then
    if self.y > 0 then
      self.y = self.y - (self.speed * dt)
    end
  elseif love.keyboard.isDown("s") then
    if self.y < (love.graphics.getHeight() - 60) then
      self.y = self.y + (self.speed * dt)
    end
  end
end

function paddle:update(dt, ball)
  self.y = ball.y + (self.speed * dt) - 20
end

function paddle:draw()
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return paddle
