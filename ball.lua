local ball = {
  x = 0,
  y = 0,
  vx = 8,
  vy = -4
}

local reset = {
  x = 0,
  y = 0
}

math.randomseed(os.time())

function ball:new(x, y)
  assert(type(x) == "number")
  assert(type(y) == "number")

  local this = {}

  this.x = x or self.x
  this.y = y or self.y

  reset.x = x or reset.x
  reset.y = y or reset.y

  setmetatable(this, self)
  self.__index = self

  return this
end

function ball:reset()
  local randX = math.random()
  local randY = math.random()

  if randX > 0.5 then
    randX = -randX
  end

  if randY > 0.5 then
    randY = -randY
  end

  self.x = reset.x
  self.y = reset.y
  self.vx = randX * 10
  self.vy = randY * 10
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

function ball:update(dt, player, opponent)
  if isColliding(self, player) then
    -- Colliding with player's paddle
    handlePaddleCollision(self, player)
  elseif isColliding(self, opponent) then
    -- Colliding with opponent's paddle
    handlePaddleCollision(self, opponent)
  end

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
