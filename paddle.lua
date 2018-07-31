local paddle = {
  speed = 300,
  x = 0,
  y = 0,
  height = 60,
  width = 10
}

math.randomseed(os.time())

function paddle:new(x, y, speed)
  assert(type(x) == "number")
  assert(type(y) == "number")
  assert(speed == nil or type(speed) == "number")

  local this = {}

  this.x = x or self.x
  this.y = y or self.y
  this.speed = speed or self.speed

  setmetatable(this, self)
  self.__index = self

  return this
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
  self.y = ball.y + (self.speed * dt)
end

function paddle:draw()
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return paddle
