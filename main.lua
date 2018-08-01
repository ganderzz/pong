local paddle = require "paddle"
local ball = require "ball"

local font = love.graphics.newFont("Hack-Regular.ttf", 20)
local fontLarge = love.graphics.newFont("Hack-Regular.ttf", 50)
love.graphics.setFont(font)

local isPlaying = false
local midY = math.floor(love.graphics.getHeight() / 2)
local midX = math.floor(love.graphics.getWidth() / 2)

local score = {
  player = 0,
  opponent = 0
}

function love.load()
  player = paddle:new(70, midY)
  opponent = paddle:new(love.graphics.getWidth() - 70, midY, 100)
  ball = ball:new(midX, midY)

  -- Setup window
  love.window.setTitle("Pong")
end

function love.update(dt)
  if isPlaying then
    player:updateControlled(dt)
    opponent:update(dt, ball)
    ball:update(dt, player, opponent)

    local scored = isPointScored(ball)

    if scored == "player" then
      score.player = score.player + 1
      isPlaying = false
      ball:reset()
    elseif scored == "opponent" then
      score.opponent = score.opponent + 1
      isPlaying = false
      ball:reset()
    end
  elseif not isPlaying and love.keyboard.isDown("space") then
    isPlaying = true
  end
end

function isPointScored(ball)
  if ball.x <= 0 then
    return "player"
  elseif ball.x >= love.graphics.getWidth() then
    return "opponent"
  end

  return ""
end

function love.draw()
  player:draw()
  opponent:draw()
  ball:draw()

  if not isPlaying then
    love.graphics.setFont(font)
    love.graphics.print("Press [space] to start", midX - 120, midY + 50)
  end

  love.graphics.setFont(fontLarge)
  love.graphics.print(score.player, 140, 20)
  love.graphics.print(score.opponent, love.graphics.getWidth() - 140, 20)
end
