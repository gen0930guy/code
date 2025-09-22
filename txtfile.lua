-- note: i like spacing out code because it makes it easier for me to read 
-- cameleatingcactus.gif

-- =============================================================================
-- main quest system
-- =============================================================================

-- so uhm... i coded a quest system thing and like i put a lot of time into this
-- this makes it so when a player touches a part in the workspace they get a random quest n stuff

-- =============================================================================
-- quest definitions table
-- =============================================================================

-- this table has all the quests in the game.
-- each quest is a function that sets up the quest for a player.
local QuestTable = {
	-- quest: player must die one time to finish
	die = function(plr, plrgui, questfolder)
		-- make the quest ui thing that shows what to do
		local textframe = createQuestUI(plrgui, "die", "perish. | 0/1")
		
		-- make a number to keep track of how much is done
		local progress = createProgressValue(questfolder)

		-- listen for when the player dies
		plr.Character.Humanoid.Died:Connect(function()
			-- add to the progress when player dies
			addToQuestProgress(textframe, progress, "perish. | {current}/1", 1, "YAYY!! COMPLETE WOOHOO CONGRATULATIONES")
		end)
	end,

	-- quest: player must touch the "pursuer" part in the workspace
	interactpursuer = function(plr, plrgui, questfolder)
		
		local textframe = createQuestUI(plrgui, "interactpursuer", "touch pursuer part.rbmx. | 0/1")
		local progress = createProgressValue(questfolder)
		-- wait time so it doesnt trigger too many times
		local touchCooldown = false

		-- listen for when something touches the handle part
		game.Workspace.Handle.Touched:Connect(function(touchedPart)
			
			-- check if the touch is from this player and not on wait time
			if not isValidPlayerTouch(touchedPart, plr) or touchCooldown then return end

			-- start wait time so it doesnt spam
			touchCooldown = true
			-- play a sound when touched
			
			game.Workspace.Handle.fresh:Play()
			
			-- add to the quest progress
			addToQuestProgress(textframe, progress, "touch pursuer part.rbmx. | {current}/1", 1, "YAYY!! COMPLETE WOOHOO CONGRATULATIONES")
		end)
	end,

	-- quest: player must finish an obstacle course by touching the end part
	completeobby = function(plr, plrgui, questfolder)
		
		local textframe = createQuestUI(plrgui, "completeobby", "complete the obby. | 0/1")
		local progress = createProgressValue(questfolder)
		local touchCooldown = false

		-- listen for touches on the end part of the obby
		game.Workspace.victori.Touched:Connect(function(touchedPart)
			if not isValidPlayerTouch(touchedPart, plr) or touchCooldown then return end

			touchCooldown = true
			addToQuestProgress(textframe, progress, "complete the obby i put together in 30s. | {current}/1", 1, "YAYY!! COMPLETE WOOHOO CONGRATULATIONES")
		end)
	end,

	-- quest: player must say a hello in the chat
	sayhi = function(plr, plrgui, questfolder)
		
		local textframe = createQuestUI(plrgui, "sayhi", "say hi in chat!! | 0/1")
		local progress = createProgressValue(questfolder)

		-- listen for player chat messages
		plr.Chatted:Connect(function(message)
			-- check if the message is a hello
			if not isGreeting(message) then return end

			addToQuestProgress(textframe, progress, "say hi in chat!! | {current}/1", 1, "YAYY!! COMPLETE WOOHOO CONGRATULATIONES")
		end)
	end,

	-- quest: player must find and touch a specific player (genio221)
	findme = function(plr, plrgui, questfolder)
		
		local textframe = createQuestUI(plrgui, "findme", "find me........ | 0/1")
		local progress = createProgressValue(questfolder)
		local touchCooldown = false

		-- listen for touches on the specific player's body
		game.Workspace.Genio221.Torso.Touched:Connect(function(touchedPart)
			if not isValidPlayerTouch(touchedPart, plr) or touchCooldown then return end

			touchCooldown = true
			addToQuestProgress(textframe, progress, "find me......... | {current}/1", 1, "YAYY!! COMPLETE WOOHOO CONGRATULATIONES")
		end)
	end,

	-- quest: player must do the dance emote
	emote = function(plr, plrgui, questfolder)
		
		local textframe = createQuestUI(plrgui, "emote", "emote!! (/e dance) | 0/1")
		local progress = createProgressValue(questfolder)

		plr.Chatted:Connect(function(message)
			-- check if player used the dance command
			if message ~= "/e dance" then return end

			addToQuestProgress(textframe, progress, "emote!! (/e) | {current}/1", 1, "YAYY!! COMPLETE WOOHOO CONGRATULATIONES")
		end)
	end,

	-- quest: player must wait/play for 6 seconds (adds progress every second)
	wait6s = function(plr, plrgui, questfolder)
		
		local textframe = createQuestUI(plrgui, "wait6s", "play for 6 seconds | 0/6")
		local progress = createProgressValue(questfolder)

		-- add to progress every second for 6 seconds
		for i = 1, 6 do
			task.wait(1)  -- wait 1 second between adds
			addToQuestProgress(textframe, progress, "play for 6 seconds | {current}/6", 6, "YAYY!! COMPLETE WOOHOO CONGRATULATIONES")
		end
	end,

	-- quest: player must answer the math question "9+10" right
	nineplusten = function(plr, plrgui, questfolder)
		
		local textframe = createQuestUI(plrgui, "nineplusten", "whats 9+10? (spoiler its 21) | 0/1")
		local progress = createProgressValue(questfolder)

		plr.Chatted:Connect(function(message)
			-- check if player said the right answer (the meme answer is 21)
			if message ~= "21" then return end

			addToQuestProgress(textframe, progress, "whats 9+10? | {current}/1", 1, "YAYY!! COMPLETE WOOHOO CONGRATULATIONES")
		end)
	end
}

-- =============================================================================
-- uhh idk what to name this!!!!!!!!!
-- =============================================================================

-- makes the ui thing for a quest
--  plrgui: the player's screen ui
--  questName: name for the quest
--  initialText: the text to show when quest starts

function createQuestUI(plrgui, questName, initialText)
	-- copy the quest ui thing from the template
	local textframe = plrgui.quest.questholder.template:Clone()
	textframe.Visible = true  -- make it show up (template is usually hidden)
	textframe.Name = questName  -- give it a name so we know which quest it is
	textframe.Text = initialText  -- set the quest text
	textframe.Parent = plrgui.quest.questholder  -- put it in the quest holder
	return textframe
end

-- makes a number to keep track of quest progress
-- questfolder: the place where quest data is kept for this player

function createProgressValue(questfolder)
	local progress = Instance.new("IntValue")  -- make a new number thing
	progress.Name = "questprogress"  -- call it questprogress
	progress.Value = 0  -- start at zero
	progress.Parent = questfolder  -- put it in the player's quest folder
	return progress
end

-- checks if a touch came from the right player's character
--  touchedPart: the part that got touched
--  plr: the player to check
function isValidPlayerTouch(touchedPart, plr)
	-- check if touched part is from the player's character
	return touchedPart.Parent and touchedPart.Parent.Name == plr.Character.Name
end

-- checks if a chat message is a greeting
--  message: the chat message to check
--  true if it's a greetign, false if not

function isGreeting(message)
	local greetings = {"hi", "Hi", "Hello", "hello"}  -- list of hello words
	-- check if message is one of the hello words
	for _, greeting in ipairs(greetings) do
		
		if message == greeting then
			
			return true
			
		end
	end
	return false
	
end

-- does the main progress adding for all quests
--  textframe: the ui thing that shows quest progress
--  progress: the number that tracks how much is done
--  formatText: text with {current} where the progress number goes
--  targetValue: the number needed to finish the quest
--  completionMessage: message to show when quest is done
function addToQuestProgress(textframe, progress, formatText, targetValue, completionMessage)
	-- add 1 to the progress number
	progress.Value += 1
	
	-- update the ui text, put the current number where {current} is
	local currentText = formatText:gsub("{current}", tostring(progress.Value))
	textframe.Text = currentText

	-- print to console so we can see it working
	print("COUNT!!! " .. tostring(progress.Value))

	-- check if the quest is finished
	if progress.Value >= targetValue then
		finishQuest(textframe, completionMessage)
	end
end

-- does the quest finished stuff (message, clean up)
--  textframe: the ui thing to update with finished message
-- completionMessage: the done message to show
function finishQuest(textframe, completionMessage)
	-- show the done message
	textframe.Text = completionMessage
	
	-- wait a bit so player can read the message
	task.wait(2.5)
	
	-- remove the quest ui thing
	textframe:Remove()
end

-- gives a specific quest to a player if they dont have it already
--  plr: the player to give the quest to
--  plrgui: the player's screen ui
--  questfolder: the player's quest data folder
--  questName: the name of the quest to give
function giveQuest(plr, plrgui, questfolder, questName)
	-- dont give the quest if player already has it
	if plrgui.quest.questholder:FindFirstChild(questName) then return end

	-- get the quest function from the quest table
	local questFunction = QuestTable[questName]
	-- make sure the quest exists before trying to run it
	
	if questFunction then
		questFunction(plr, plrgui, questfolder)
	end
	
end

-- picks a random quest from the list of quests
--  questTable: table with all the quest names
-- the randomly picked quest name
function getRandomQuest(questTable)
	-- math.random(1, #questTable) picks a random number between 1 and how many quests there are
	return questTable[math.random(1, #questTable)]
end

-- =============================================================================
-- quest giver setup
-- =============================================================================

--  plr: the player to set up the quest giver for
-- plrgui: the player's screen ui
-- questfolder: the player quest data folder
function setupQuestGiver(plr, plrgui, questfolder)
	
	-- the part in workspace that gives quests when touched
	local questBlock = game.Workspace.Part
	
	-- wait time so player doesnt get too many quests at once
	local questCooldown = false
	
	-- list of all quest names that can be given randomly
	local availableQuests = {
		"die", "interactpursuer", "completeobby", "sayhi", 
		"findme", "emote", "wait6s", "nineplusten"
		
	}

	-- listen for when something touches the quest giver block
	questBlock.Touched:Connect(function(touchedPart)
		
		-- check if touch is from this player and not on wait time
		if not isValidPlayerTouch(touchedPart, plr) or questCooldown then return end

		-- start wait time so it doesnt spam quests
		questCooldown = true
		
		-- pick a random quest from the list
		local randomQuest = getRandomQuest(availableQuests)
		-- give the quest to the player
		
		giveQuest(plr, plrgui, questfolder, randomQuest)

		-- wait before allowing another quest
		task.wait(1)
		
		-- reset wait time so player can get another quest later
		questCooldown = false
		
	end)
end

-- =============================================================================
-- main player setup
-- =============================================================================

-- this runs when a player joins the game
game.Players.PlayerAdded:Connect(function(plr)
	-- wait a bit so player's character and ui are loaded
	task.wait(0.5)

	-- find the player's screen ui where quests will show up
	local plrgui = plr:FindFirstChild("PlayerGui")
	-- if player has no ui, we cant show quests
	if not plrgui then return end

	-- make a folder to keep quest data for this player
	-- this keeps quest stuff separate from other player data
	local questfolder = Instance.new("Folder")
	questfolder.Name = "questcomponents"  -- name it so we know what it is
	questfolder.Parent = plr  -- put it under the player

	-- set up the quest giver for this player
	setupQuestGiver(plr, plrgui, questfolder)
end)

-- =============================================================================
-- how it workz:
-- 1. player joins game > makes quest data folder
-- 2. player touches quest block > gets random quest
-- 3. quest ui shows up > player does the thing
-- 4. progress goes up > quest finishes > ui goes away
-- 5. can do it again > repeat
-- =============================================================================

-- im sleep deprived ❤️❤️ please hiddendevs i need this my balance is at 0 and i live with 2 avatar accessories...


