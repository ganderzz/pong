local ball = {
  x = 0,
  y = 0,
  vx = 8,
  vy = -4
}

function ball:new(x, y)
  assert(type(x) == "number")
  assert(type(y) == "number")

  local this = {}

  this.x = x or self.x
  this.y = y or self.y

  setmetatable(this, self)
  self.__index = self

  return this
end

function isColliding(ball, p)
  if ball.y >= p.y and ball.y < (p.y + p.height) then
    if ball.x <= (p.x + p.width) and ball.x >= p.x then
      return true
    end
  end

  return false
end

function getCollisionPosition(ball, p)
  local midY = p.y + math.floor(p.height / 2)

  if ball.y >= midY then
    return "bottom"
  elseif ball.y < midY then
    return "top"
  end

  return "none"
end

function handlePaddleCollision(self, paddle)
  if isColliding(self, paddle) then
    local position = getCollisionPosition(self, paddle)

    if position == "top" then
      if self.vy < 0 then
        self.vy = -self.vy
      end
    elseif position == "bottom" then
      if self.vy > 0 then
        self.vy = -self.vy
      end
    end

    self.vx = -self.vx
  end
end

function ball:update(dt, player, opponent)
  -- Colliding with player's paddle
  handlePaddleCollision(self, player)

  -- Colliding with opponent's paddle
  handlePaddleCollision(self, opponent)

  -- colliding with window y edges
  if self.y <= 0 or self.y >= love.graphics.getHeight() then
    self.vy = -self.vy
  end

  -- Colliding with window x edges
  if self.x <= 0 or self.x >= love.graphics.getWidth() then
    self.vx = -self.vx
  end

  self.x = self.x + self.vx
  self.y = self.y + self.vy
end

function ball:draw()
  love.graphics.circle("fill", self.x, self.y, 10)
end

return ball
