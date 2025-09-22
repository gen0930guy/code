-- note: i like spacing out code because it makes it easier for me to read

-- Main quest functionality table
local QuestTable = {
    die = function(plr, plrgui, questfolder)
        local textframe = createQuestUI(plrgui, "die", "perish. | 0/1")
        local progress = createProgressValue(questfolder)
        
        plr.Character.Humanoid.Died:Connect(function()
            incrementQuestProgress(textframe, progress, "perish. | {current}/1", 1, "YAYY!! COMPLETE WOOHOO CONGRATULATIONES")
        end)
    end,

    interactpursuer = function(plr, plrgui, questfolder)
        local textframe = createQuestUI(plrgui, "interactpursuer", "touch pursuer part.rbmx. | 0/1")
        local progress = createProgressValue(questfolder)
        local touchCooldown = false
        
        game.Workspace.Handle.Touched:Connect(function(touchedPart)
            if not isValidPlayerTouch(touchedPart, plr) or touchCooldown then return end
            
            touchCooldown = true
            game.Workspace.Handle.fresh:Play()
            incrementQuestProgress(textframe, progress, "touch pursuer part.rbmx. | {current}/1", 1, "YAYY!! COMPLETE WOOHOO CONGRATULATIONES")
        end)
    end,

    completeobby = function(plr, plrgui, questfolder)
        local textframe = createQuestUI(plrgui, "completeobby", "complete the obby. | 0/1")
        local progress = createProgressValue(questfolder)
        local touchCooldown = false
        
        game.Workspace.victori.Touched:Connect(function(touchedPart)
            if not isValidPlayerTouch(touchedPart, plr) or touchCooldown then return end
            
            touchCooldown = true
            incrementQuestProgress(textframe, progress, "complete the obby | {current}/1", 1, "YAYY!! COMPLETE WOOHOO CONGRATULATIONES")
        end)
    end,

    sayhi = function(plr, plrgui, questfolder)
        local textframe = createQuestUI(plrgui, "sayhi", "say hi in chat!! | 0/1")
        local progress = createProgressValue(questfolder)
        
        plr.Chatted:Connect(function(message)
            if not isGreeting(message) then return end
            
            incrementQuestProgress(textframe, progress, "say hi in chat!! | {current}/1", 1, "YAYY!! COMPLETE WOOHOO CONGRATULATIONES")
        end)
    end,

    findme = function(plr, plrgui, questfolder)
        local textframe = createQuestUI(plrgui, "findme", "find me........ | 0/1")
        local progress = createProgressValue(questfolder)
        local touchCooldown = false
        
        game.Workspace.Genio221.Torso.Touched:Connect(function(touchedPart)
            if not isValidPlayerTouch(touchedPart, plr) or touchCooldown then return end
            
            touchCooldown = true
            incrementQuestProgress(textframe, progress, "find me......... | {current}/1", 1, "YAYY!! COMPLETE WOOHOO CONGRATULATIONES")
        end)
    end,

    emote = function(plr, plrgui, questfolder)
        local textframe = createQuestUI(plrgui, "emote", "emote!! (/e dance) | 0/1")
        local progress = createProgressValue(questfolder)
        
        plr.Chatted:Connect(function(message)
            if message ~= "/e dance" then return end
            
            incrementQuestProgress(textframe, progress, "emote!! (/e) | {current}/1", 1, "YAYY!! COMPLETE WOOHOO CONGRATULATIONES")
        end)
    end,

    wait6s = function(plr, plrgui, questfolder)
        local textframe = createQuestUI(plrgui, "wait6s", "play for 6 seconds | 0/6")
        local progress = createProgressValue(questfolder)
        
        for i = 1, 6 do
            task.wait(1)
            incrementQuestProgress(textframe, progress, "play for 6 seconds | {current}/6", 6, "YAYY!! COMPLETE WOOHOO CONGRATULATIONES")
        end
    end,

    nineplusten = function(plr, plrgui, questfolder)
        local textframe = createQuestUI(plrgui, "nineplusten", "whats 9+10? (spoiler its 21) | 0/1")
        local progress = createProgressValue(questfolder)
        
        plr.Chatted:Connect(function(message)
            if message ~= "21" then return end
            
            incrementQuestProgress(textframe, progress, "whats 9+10? | {current}/1", 1, "YAYY!! COMPLETE WOOHOO CONGRATULATIONES")
        end)
    end
}

-- Helper functions
function createQuestUI(plrgui, questName, initialText)
    local textframe = plrgui.quest.questholder.template:Clone()
    textframe.Visible = true
    textframe.Name = questName
    textframe.Text = initialText
    textframe.Parent = plrgui.quest.questholder
    return textframe
end

function createProgressValue(questfolder)
    local progress = Instance.new("IntValue")
    progress.Name = "questprogress"
    progress.Value = 0
    progress.Parent = questfolder
    return progress
end

function isValidPlayerTouch(touchedPart, plr)
    return touchedPart.Parent and touchedPart.Parent.Name == plr.Character.Name
end

function isGreeting(message)
    local greetings = {"hi", "Hi", "Hello", "hello"}
    for _, greeting in ipairs(greetings) do
        if message == greeting then
            return true
        end
    end
    return false
end

function incrementQuestProgress(textframe, progress, formatText, targetValue, completionMessage)
    progress.Value += 1
    local currentText = formatText:gsub("{current}", tostring(progress.Value))
    textframe.Text = currentText
    
    print("COUNT!!! " .. tostring(progress.Value))
    
    if progress.Value >= targetValue then
        completeQuest(textframe, completionMessage)
    end
end

function completeQuest(textframe, completionMessage)
    textframe.Text = completionMessage
    task.wait(2.5)
    textframe:Remove()
end

function giveQuest(plr, plrgui, questfolder, questName)
    if plrgui.quest.questholder:FindFirstChild(questName) then return end
    
    local questFunction = QuestTable[questName]
    if questFunction then
        questFunction(plr, plrgui, questfolder)
    end
end

function getRandomQuest(questTable)
    return questTable[math.random(1, #questTable)]
end

function setupQuestGiver(plr, plrgui, questfolder)
    local questBlock = game.Workspace.Part
    local questCooldown = false
    local availableQuests = {
        "die", "interactpursuer", "completeobby", "sayhi", 
        "findme", "emote", "wait6s", "nineplusten"
    }
    
    questBlock.Touched:Connect(function(touchedPart)
        if not isValidPlayerTouch(touchedPart, plr) or questCooldown then return end
        
        questCooldown = true
        local randomQuest = getRandomQuest(availableQuests)
        giveQuest(plr, plrgui, questfolder, randomQuest)
        
        task.wait(1)
        questCooldown = false
    end)
end

-- Main player connection
game.Players.PlayerAdded:Connect(function(plr)
    task.wait(0.5)
    
    local plrgui = plr:FindFirstChild("PlayerGui")
    if not plrgui then return end
    
    local questfolder = Instance.new("Folder")
    questfolder.Name = "questcomponents"
    questfolder.Parent = plr
    
    setupQuestGiver(plr, plrgui, questfolder)
end)
