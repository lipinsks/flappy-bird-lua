-- Game constants
local pipe_x, top_pipe_height, gap_height, pipe_width
local birdY, gravity, birdX, bird_width, bird_height
local levels_passed = 1.0
local difficulty = 0.5
local game_over = false

function love.load()
    -- Background color
    love.graphics.setBackgroundColor(1, 1, 1) -- White background

    -- Bird properties
    birdX = 62
    birdY = 200
    bird_width = 30
    bird_height = 25
    gravity = 100

    -- Pipe properties
    pipe_x = love.graphics.getWidth() -- Start off-screen
    pipe_width = 50
    top_pipe_height = math.random(100, 400) -- Random height for the top pipe
    gap_height = 200 -- Gap between top and bottom pipes
end

function love.update(dt)
    if game_over then
        return -- Stop updating when game over
    end

    -- Bird falling logic
    birdY = birdY + (gravity * dt)

    -- Move pipes to the left
    pipe_x = pipe_x - (120 * levels_passed * dt)

    -- Reset pipes when they move off-screen
    if pipe_x < -pipe_width then
        pipe_x = love.graphics.getWidth() -- Reset to the right
        top_pipe_height = math.random(100, 400) -- Randomize new top pipe height
        levels_passed = levels_passed + difficulty
    end

    -- Collision detection
    checkCollision()
end

function love.keypressed(key)
    -- Bird jump logic
    if key == "space" and not game_over then
        birdY = birdY - 70
    end

    if key == "d" and not game_over then 
	    birdY = birdY + 70
    end


    -- Restart the game after game over
    if key == "r" and game_over then
        resetGame()
    end

    -- Exit the game
    if key == "escape" then
        love.event.quit()
    end
end

function love.draw()
    -- Draw the bird
    love.graphics.setColor(0.87, 0.84, 0.27) -- Yellowish color
    love.graphics.rectangle('fill', birdX, birdY, bird_width, bird_height)

    -- Draw the pipes
    love.graphics.setColor(120 / 255, 33 / 255, 123 / 255) -- Purple color

    -- Top pipe
    love.graphics.rectangle('fill', pipe_x, 0, pipe_width, top_pipe_height)

    -- Bottom pipe
    local bottom_pipe_y = top_pipe_height + gap_height
    love.graphics.rectangle('fill', pipe_x, bottom_pipe_y, pipe_width, love.graphics.getHeight() - bottom_pipe_y)

    -- Game over message
    if game_over then
        love.graphics.setColor(1, 0, 0) -- Red color
        love.graphics.printf("Game Over! Press R to restart. You're score was: " .. levels_passed * 10, 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    end
end

-- Check for collisions
function checkCollision()
    -- Top pipe
    if birdX + bird_width > pipe_x and birdX < pipe_x + pipe_width and birdY < top_pipe_height then
        game_over = true
    end

    -- Bottom pipe
    local bottom_pipe_y = top_pipe_height + gap_height
    if birdX + bird_width > pipe_x and birdX < pipe_x + pipe_width and birdY + bird_height > bottom_pipe_y then
        game_over = true
    end

    -- Screen boundaries
    if birdY < 0 or birdY + bird_height > love.graphics.getHeight() then
        game_over = true
    end
end

-- Reset the game state
function resetGame()
    birdY = 200
    pipe_x = love.graphics.getWidth()
    top_pipe_height = math.random(100, 400)
    levels_passed = 1.0
    game_over = false
end

