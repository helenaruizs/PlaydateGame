import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

local gfx <const> = playdate.graphics

local playerSprite = nil

local playerSpeed = 4

local playTimer = nil
local playTime = 30 * 1000

local itemSprite = nil

local function resetTimer()
	playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

local function moveItem()
	local randX = math.random(40, 360)
	local randY = math.random(180,185)
	itemSprite:moveTo(randX, randY)
	
end

local function initialize()
	math.randomseed(playdate.getSecondsSinceEpoch())
	local playerImage = gfx.image.new("images/player")
	playerSprite = gfx.sprite.new(playerImage)
	playerSprite:moveTo(220, 160)
	playerSprite:setCollideRect(0, 0, playerSprite:getSize())
	playerSprite:add()

	local itemImage = gfx.image.new("images/item")
	itemSprite = gfx.sprite.new(itemImage)
	moveItem()
	itemSprite:setCollideRect(0, 0, itemSprite:getSize())
	itemSprite:add()

	local backgroundImage = gfx.image.new("images/background")
	gfx.sprite.setBackgroundDrawingCallback(
		function (x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			backgroundImage:draw(0, 0)
			gfx.clearClipRect()			
		end
	)

	resetTimer()

end

initialize()


function playdate.update()
	if playTimer.value == 0 then
		if playdate.buttonJustPressed(playdate.kButtonA) then
			resetTimer()
			moveItem()
		end
	else
		if playdate.buttonIsPressed(playdate.kButtonRight) then
			playerSprite:moveBy(playerSpeed, 0)
		end
		if playdate.buttonIsPressed(playdate.kButtonLeft) then
			playerSprite:moveBy(-playerSpeed, 0)
		end

		local collisions = itemSprite:overlappingSprites()
		if #collisions >= 1 then
			itemSprite:removeSprite()
		end
	end

	playdate.timer.updateTimers()
	gfx.sprite.update()

	gfx.drawText("Time: " .. math.ceil(playTimer.value/1000), 5, 5)
end