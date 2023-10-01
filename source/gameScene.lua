import "gameOverScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics


class('GameScene').extends(gfx.sprite)

function GameScene:init()
    local backgroundImage = gfx.image.new("images/background")
	gfx.sprite.setBackgroundDrawingCallback(
		function (x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			backgroundImage:draw(0, 0)
			gfx.clearClipRect()			
		end
	)

    local playerSprite = gfx.image.new("images/player")
    self.player = gfx.sprite.new(playerSprite)
    self.player:moveTo(220, 160)
	self.player:setCollideRect(0, 0, playerSprite:getSize())
	self.player:add()

    self.playerSpeed = 4

    self:add()

    local itemImage = gfx.image.new("images/item")
	itemSprite = gfx.sprite.new(itemImage)
    itemSprite:moveTo(320, 180)
	itemSprite:setCollideRect(0, 0, itemSprite:getSize())
	itemSprite:add()

end

function GameScene:update()
    if pd.buttonJustPressed(pd.kButtonB) then
        SCENE_MANAGER:switchScene(GameOverScene, "Score: Over 9000!")
    end
		if pd.buttonIsPressed(pd.kButtonRight) then
			self.player:moveBy(self.playerSpeed, 0)
		end
		if pd.buttonIsPressed(pd.kButtonLeft) then
			self.player:moveBy(-self.playerSpeed, 0)
		end

		local collisions = itemSprite:overlappingSprites()
		if #collisions >= 1 then
			itemSprite:removeSprite()
		end
end