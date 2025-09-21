-- note: i like spacing out code because it makes it easier for me to read

-- This function triggers when a new player joins the game
game.Players.PlayerAdded:Connect(function(plr)
	-- Small pause to ensure everything is loaded properly
	task.wait(0.5)

	-- Reference to a part in workspace that will serve as a quest giver trigger
	local funniblock = game.Workspace.Part

	-- Get the player's GUI container where quest UI will be displayed
	local plrgui = plr:FindFirstChild("PlayerGui")

	-- Cooldown flag to prevent spamming quest assignments
	local questcd = false

	-- Create a folder to store quest-related data for this player
	local questfolder = Instance.new("Folder")
	questfolder.Name = "questcomponents"
	questfolder.Parent = plr

	-- Table containing all available quest names
	local questtable = {
		"die",
		"interactpursuer",
		"completeobby",
		"sayhi",
		"findme",
		"emote",
		"wait6s",
		"nineplusten"
	}

	-- Main quest functionality table - maps quest names to their implementation functions
	local table = {
		-- Quest: Die once
		die = function()
			-- Create UI element for this quest
			local textframe = plrgui.quest.questholder.template:Clone() 
			textframe.Visible = true
			textframe.Name = "die" 
			textframe.Parent = plrgui.quest.questholder

			-- Create progress tracking value
			local int = Instance.new("IntValue")
			int.Name = "questprogress"
			int.Parent = questfolder 

			-- Set initial quest text
			textframe.Text = "perish. | "..int.Value.."/1"

			-- Listen for when the player dies
			plr.Character.Humanoid.Died:Connect(function()
				print("COUNT!!!")
				int.Value += 1
				textframe.Text = "perish. | "..int.Value.."/1"
				print(tostring(int.Value))

				-- Check if quest is complete
				if int.Value >= 1 then
					textframe.Text = "YAYY!! COMPLETE WOOHOO CONGRATULATIONES"
					task.wait(2.5)
					textframe:Remove()
				end
			end)
		end,

		-- Quest: Touch the pursuer part
		interactpursuer = function()
			local touchycd = false  -- Cooldown for touch events

			-- Create UI element for this quest
			local textframe = plrgui.quest.questholder.template:Clone()
			textframe.Visible = true
			textframe.Name = "interactpursuer"
			textframe.Parent = plrgui.quest.questholder

			-- Create progress tracking value
			local int = Instance.new("IntValue")
			int.Name = "questprogress"
			int.Parent = questfolder

			-- Set initial quest text
			textframe.Text = "touch pursuer part.rbmx. | "..int.Value.."/1"

			-- Listen for when player touches the pursuer part
			game.Workspace.Handle.Touched:Connect(function(touchy)
				-- Prevent multiple triggers
				if touchycd == true then
					return
				end

				-- Check if it's the player touching
				if touchy.Parent.Name == plr.Character.Name then
					touchycd = true
					game.Workspace.Handle.fresh:Play()  -- Play sound effect
					print("COUNT!!!")
					int.Value += 1
					textframe.Text = "touch pursuer part.rbmx. | "..int.Value.."/1"
					print(tostring(int.Value))

					-- Check if quest is complete
					if int.Value >= 1 then
						textframe.Text = "YAYY!! COMPLETE WOOHOO CONGRATULATIONES"
						task.wait(2.5)
						textframe:Remove()
					end
				end
			end)
		end,

		-- Quest: Complete the obby
		completeobby = function()
			local touchycd = false  -- Cooldown for touch events

			-- Create UI element for this quest
			local textframe = plrgui.quest.questholder.template:Clone()
			textframe.Visible = true
			textframe.Name = "completeobby"
			textframe.Parent = plrgui.quest.questholder

			-- Create progress tracking value
			local int = Instance.new("IntValue")
			int.Name = "questprogress"
			int.Parent = questfolder

			-- Set initial quest text
			textframe.Text = "complete the obby. | "..int.Value.."/1"

			-- Listen for when player touches the victory part
			game.Workspace.victori.Touched:Connect(function(touchy)
				-- Prevent multiple triggers
				if touchycd == true then
					return
				end

				-- Check if it's the player touching
				if touchy.Parent.Name == plr.Character.Name then
					touchycd = true
					print("COUNT!!!")
					int.Value += 1
					textframe.Text = "complete the obby i put together in 30s. | "..int.Value.."/1"
					print(tostring(int.Value))

					-- Check if quest is complete
					if int.Value >= 1 then
						textframe.Text = "YAYY!! COMPLETE WOOHOO CONGRATULATIONES"
						task.wait(2.5)
						textframe:Remove()
					end
				end
			end)
		end,

		-- Quest: Say hi in chat
		sayhi = function()
			-- Create UI element for this quest
			local textframe = plrgui.quest.questholder.template:Clone()
			textframe.Visible = true
			textframe.Name = "sayhi"
			textframe.Parent = plrgui.quest.questholder

			-- Create progress tracking value
			local int = Instance.new("IntValue")
			int.Name = "questprogress"
			int.Parent = questfolder

			-- Set initial quest text
			textframe.Text = "say hi in chat!! | "..int.Value.."/1"

			-- Listen for player chat messages
			plr.Chatted:Connect(function(msg)
				-- Check if player said "hi" or "hello"
				if msg == "hi" or msg == "Hi" or msg == "Hello" or msg == "hello" then
					print("COUNT!!!")
					int.Value += 1
					textframe.Text = "say hi in chat!! | "..int.Value.."/1"
					print(tostring(int.Value))

					-- Check if quest is complete
					if int.Value >= 1 then
						textframe.Text = "YAYY!! COMPLETE WOOHOO CONGRATULATIONES"
						task.wait(2.5)
						textframe:Remove()
					end
				end
			end)
		end,

		-- Quest: Find a specific character in the game
		findme = function()
			local touchycd = false  -- Cooldown for touch events

			-- Create UI element for this quest
			local textframe = plrgui.quest.questholder.template:Clone()
			textframe.Visible = true
			textframe.Name = "findme"
			textframe.Parent = plrgui.quest.questholder

			-- Create progress tracking value
			local int = Instance.new("IntValue")
			int.Name = "questprogress"
			int.Parent = questfolder

			-- Set initial quest text
			textframe.Text = "find me........ | "..int.Value.."/1"

			-- Listen for when player touches the target character
			game.Workspace.Genio221.Torso.Touched:Connect(function(touchy)
				-- Prevent multiple triggers
				if touchycd == true then
					return
				end

				-- Check if it's the player touching
				if touchy.Parent.Name == plr.Character.Name then
					touchycd = true
					print("COUNT!!!")
					int.Value += 1
					textframe.Text = "find me......... | "..int.Value.."/1"
					print(tostring(int.Value))

					-- Check if quest is complete
					if int.Value >= 1 then
						textframe.Text = "YAYY!! COMPLETE WOOHOO CONGRATULATIONES"
						task.wait(2.5)
						textframe:Remove()
					end
				end
			end)
		end,

		-- Quest: Perform a dance emote
		emote = function()
			-- Create UI element for this quest
			local textframe = plrgui.quest.questholder.template:Clone()
			textframe.Visible = true
			textframe.Name = "emote"
			textframe.Parent = plrgui.quest.questholder

			-- Create progress tracking value
			local int = Instance.new("IntValue")
			int.Name = "questprogress"
			int.Parent = questfolder

			-- Set initial quest text
			textframe.Text = "emote!! (/e dance) | "..int.Value.."/1"

			-- Listen for player chat messages
			plr.Chatted:Connect(function(msg)
				-- Check if player used dance emote
				if msg == "/e dance" then
					print("COUNT!!!")
					int.Value += 1
					textframe.Text = "emote!! (/e) | "..int.Value.."/1"
					print(tostring(int.Value))

					-- Check if quest is complete
					if int.Value >= 1 then
						textframe.Text = "YAYY!! COMPLETE WOOHOO CONGRATULATIONES"
						task.wait(2.5)
						textframe:Remove()
					end
				end
			end)
		end,

		-- Quest: Wait for 6 seconds (play for 6 seconds)
		wait6s = function()
			-- Create UI element for this quest
			local textframe = plrgui.quest.questholder.template:Clone()
			textframe.Visible = true
			textframe.Name = "wait6s"
			textframe.Parent = plrgui.quest.questholder

			-- Create progress tracking value
			local int = Instance.new("IntValue")
			int.Name = "questprogress"
			int.Parent = questfolder

			-- Set initial quest text
			textframe.Text = "play for 6 seconds | "..int.Value.."/6"

			-- Increment progress every second for 6 seconds
			for i = 1,6 do
				task.wait(1)  -- Wait 1 second between increments
				print("COUNT!!!")
				int.Value += 1
				textframe.Text = "play for 6 seconds | "..int.Value.."/6"
				print(tostring(int.Value))

				-- Check if quest is complete
				if int.Value >= 6 then
					textframe.Text = "YAYY!! COMPLETE WOOHOO CONGRATULATIONES"
					task.wait(2.5)
					textframe:Remove()
				end
			end
		end,

		-- Quest: Answer the math question "what's 9+10?"
		nineplusten = function()
			-- Create UI element for this quest
			local textframe = plrgui.quest.questholder.template:Clone()
			textframe.Visible = true
			textframe.Name = "nineplusten"
			textframe.Parent = plrgui.quest.questholder

			-- Create progress tracking value
			local int = Instance.new("IntValue")
			int.Name = "questprogress"
			int.Parent = questfolder

			-- Set initial quest text with hint
			textframe.Text = "whats 9+10? (spoiler its 21) | "..int.Value.."/1"

			-- Listen for player chat messages
			plr.Chatted:Connect(function(msg)
				-- Check if player answered correctly
				if msg == "21" then
					print("COUNT!!!")
					int.Value += 1
					textframe.Text = "whats 9+10? | "..int.Value.."/1"
					print(tostring(int.Value))

					-- Check if quest is complete
					if int.Value >= 1 then
						textframe.Text = "YAYY!! COMPLETE WOOHOO CONGRATULATIONES"
						task.wait(2.5)
						textframe:Remove()
					end
				end
			end)
		end,

		-- Additional quest: Decode binary message (commented out)
		binary = function()
			-- This quest is defined but not included in the active quest table
			local textframe = plrgui.quest.questholder.template:Clone()
			textframe.Visible = true
			textframe.Name = "sayhi"
			textframe.Parent = plrgui.quest.questholder

			local int = Instance.new("IntValue")
			int.Name = "questprogress"
			int.Parent = questfolder

			textframe.Text = "what does this say? : 01101000 01101001 (spoiler its 2 letters (UTF-8 btw)) | "..int.Value.."/1"

			-- Listens for player to decode binary message "hi"
			plr.Chatted:Connect(function(msg)
				if msg == "hi" or msg == "Hi" then
					print("COUNT!!!")
					int.Value += 1
					textframe.Text = "what does this say? : 01101000 01101001 (spoiler its 2 letters (UTF-8 btw)) (check desc if youre lazy to look it up) | "..int.Value.."/1"
					print(tostring(int.Value))

					if int.Value >= 1 then
						textframe.Text = "YAYY!! COMPLETE WOOHOO CONGRATULATIONES"
						task.wait(2.5)
						textframe:Remove()
					end
				end
			end)
		end,
	}

	-- Function to assign a quest to the player
	local function givequest(questname)
		-- Prevent duplicate quests
		if plrgui.quest.questholder:FindFirstChild(questname) then
			return
		end

		-- Execute the quest function
		table[questname]()
	end

	-- Set up the quest giver block interaction
	funniblock.Touched:Connect(function(touched)
		-- Check if player touched the block and no cooldown is active
		if touched.Parent.Name == plr.Character.Name and questcd == false then
			questcd = true  -- Activate cooldown

			-- Select a random quest from the quest table
			local quest = questtable[math.random(1,#questtable)]
			givequest(quest)  -- Assign the quest

			-- Wait before allowing another quest assignment
			task.wait(1)
			questcd = false  -- Reset cooldown
		end
	end)
end)