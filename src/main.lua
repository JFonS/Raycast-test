require("states/intro")
require("states/maze")
require("util/resources")
require("util/gamestack")

resources = Resources("data/")

function reset()
    -- start game
    intro = Intro()
    stack = GameStack()
    maze = Maze(20,20,{})
    stack:push(maze)
end

function love.load()
    math.randomseed(os.time())

    -- load images
    -- resources:addImage("logo", "logo.png")

    -- load fonts
    resources:addFont("normal", "DejaVuSans.ttf", 30)
    resources:addFont("tiny", "DejaVuSans.ttf", 8)

    -- load music
    -- resources:addMusic("background", "background.mp3")

    resources:load()

    reset()
end

function love.update(dt)
    stack:update(dt)
end

function love.draw()
    stack:draw()

    love.graphics.setFont(resources.fonts.tiny)
    love.graphics.setColor(0,225,0)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 500, 500)
end

function love.keypressed(k, u)
    stack:keypressed(k, u)
end

function love.mousepressed( x, y, button )
    stack:mousepressed(x, y, button)
end

function love.quit()
end
