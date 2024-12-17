-- Game constants
local pipe_x, top_pipe_height, gap_height, pipe_width
local birdY, gravity, birdX, bird_width, bird_height, scale
local bird_image
local levels_passed = 1.0
local difficulty = 0.5
local game_over = false

function love.load()
    -- Background color
    love.graphics.setBackgroundColor(1, 1, 1) -- White background

    background_image = love.graphics.newImage("background.png") -- Path to your PNG file

    love.graphics.setBackgroundColor(1, 1, 1) -- White fallback

    -- Bird properties
    birdX = 62
    birdY = 200
    gravity = 100

    -- Load the bird image
    bird_image = love.graphics.newImage("frame-1.png") -- Path to your PNG file
    
    -- Scale factor for the large image
    scale = 0.1 -- Shrink the image to 10% of its original size

    -- Adjust collision box based on scaled image dimensions
    bird_width = bird_image:getWidth() * scale
    bird_height = bird_image:getHeight() * scale

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
    if key == "up" and not game_over then
        birdY = birdY - 70
    end

    if key == "down" and not game_over then 
	    birdY = birdY + 70
    end

    if key == "right" and not game_over then
	    pipe_x = pipe_x - 20
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
    -- Draw the background image at the top-left corner (0, 0)
    love.graphics.setColor(1, 1, 1) -- Reset color to white
    love.graphics.draw(background_image, 0, 0, 0, 
                       love.graphics.getWidth() / background_image:getWidth(),
                       love.graphics.getHeight() / background_image:getHeight())

    -- Draw the bird (scaled)
    love.graphics.setColor(1, 1, 1) -- Ensure no color tint
    love.graphics.draw(bird_image, birdX, birdY, 0, scale, scale)

    -- Draw the pipes
    love.graphics.setColor(0, 0, 0)

    -- Top pipe
    love.graphics.rectangle('fill', pipe_x, 0, pipe_width, top_pipe_height)

    -- Bottom pipe
    local bottom_pipe_y = top_pipe_height + gap_height
    love.graphics.rectangle('fill', pipe_x, bottom_pipe_y, pipe_width, love.graphics.getHeight() - bottom_pipe_y)

    -- Reset color back to white after drawing pipes
    love.graphics.setColor(1, 1, 1)

    -- Game over message
    if game_over then
        love.graphics.setColor(1, 0, 0) -- Red color
        love.graphics.printf("Game Over! Press R to restart", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
        
        -- Reset color after game over text
        love.graphics.setColor(1, 1, 1)
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

