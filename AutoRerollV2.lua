local running = false
local rerollButton = nil
local enchantText = nil  -- We'll use this to detect the enchant type

-- Debugging function to print button information
local function debugButtonSearch()
    -- Print all TextButton elements in PlayerGui to help debug
    for _, obj in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
        if obj:IsA("TextButton") then
            print("Found TextButton - Name: " .. obj.Name .. " | Text: " .. obj.Text .. " | ClassName: " .. obj.ClassName)
        end
    end
end

-- Improved Search for Reroll Button based on Price and Reroll text
for _, obj in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
    if obj:IsA("TextButton") then
        -- Log button properties to debug
        print("Checking Button - Name: " .. obj.Name .. " | Text: " .. obj.Text .. " | ClassName: " .. obj.ClassName)
        
        -- Check if button text contains "Reroll" and a price (e.g. 750)
        if obj.Text:match("Reroll") and obj.Text:match("%d+") then
            rerollButton = obj
            print("Found Reroll Button with price: " .. obj.Text)
            break
        end
    end
end

-- Debugging to confirm button is being detected
if rerollButton then
    print("Successfully found 'Reroll All' button!")
else
    debugButtonSearch()
    warn("Could not find 'Reroll All' button!")
    return
end

-- Find the enchant text (adjust this based on your game's UI)
local function checkEnchant()
    -- You should replace this with the proper method of getting the currently equipped enchant.
    enchantText = game:GetService("PlayerGui"):FindFirstChild("EnchantLabel")  -- Change the path as necessary
    if enchantText then
        print("Current enchant: " .. enchantText.Text)  -- Debugging print statement
        if enchantText.Text == "Team Up V" then
            return true  -- Team Up V found, auto-stop
        end
    end
    return false
end

-- Start rerolling automatically when detected
spawn(function()
    while true do
        if rerollButton then
            -- Start rerolling automatically if it's not already running
            if not running then
                running = true
                print("🔄 Auto Reroll Started")

                -- Continue rerolling
                while running do
                    -- Simulate button click more reliably
                    pcall(function()
                        rerollButton:Click()  -- More direct button click simulation
                    end)

                    -- Add a small delay after clicking
                    wait(2)  -- Adjust the wait time as needed to ensure the reroll is triggered

                    -- Stop rerolling when "Team Up V" is found
                    if checkEnchant() then
                        running = false
                        print("🛑 Stopped after obtaining 'Team Up V' enchant.")
                    end

                    wait(1.5)  -- Adjust the wait time as needed
                end
            end
        end

        -- Check if a different pet enchant is selected, restart rerolling if needed
        if not checkEnchant() and running then
            print("🔄 Restarting rerolling because a different pet was selected without 'Team Up V'.")
            running = false
        end

        wait(1)  -- Check every second if rerolling should continue or restart
    end
end)
