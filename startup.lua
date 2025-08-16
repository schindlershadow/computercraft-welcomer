-- welcomer.lua
-- Requires: Advanced Peripherals (playerDetector + chatBox)
local radius = 100 -- detection range
local cooldown = 60 -- seconds between messages per player

local detector = peripheral.find("playerDetector")
local chat = peripheral.find("chatBox")

if not detector then
    detector = peripheral.wrap("left")
end

if not chat then
    chat = peripheral.wrap("right")
end

if not detector then
    error("No playerDetector connected!")
end
if not chat then
    error("No chatBox connected!")
end

local lastSent = {}

local function spawnMessageLoop()

    while true do
        local players = detector.getPlayersInRange(radius) or {}

        if next(players) ~= nil then
            for _, player in ipairs(players) do
                -- print("time " .. tostring( lastSent[player]))
                if not lastSent[player] or (lastSent[player]) > cooldown then
                    print("Sending chat to " .. player)
                    chat.sendMessageToPlayer("Use \"/warp overworld\" to go to overworld", player, "Spawn Chatbox",
                        "<>", "&b")
                    -- chat.sendMessageToPlayer("Discord: https://discord.gg/5vySCrG", player)

                    lastSent[player] = 0
                    sleep(1)
                elseif lastSent[player] then
                    lastSent[player] = lastSent[player] + 5
                end
            end
        end

        sleep(5)
    end
end

local function monitorChat()
    while true do
        local event, username, message, uuid, isHidden = os.pullEvent("chat")

        if message and message:lower():find("wiki") then
            local message = {{
                text = "InfiniX Wiki Link",
                underlined = true,
                color = "aqua",
                clickEvent = {
                    action = "open_url",
                    value = "https://schindlershadow.duckdns.org/infiniX/"
                }
            }}
            local json = textutils.serialiseJSON(message)
            -- sleep(1)
            chat.sendFormattedMessage(json, "Server Chatbox", "<>", "&b")
        elseif message and message:lower():find("discord") then
            local message = {{
                text = "InfiniX Discord Link",
                underlined = true,
                color = "aqua",
                clickEvent = {
                    action = "open_url",
                    value = "https://discord.gg/5vySCrG"
                }
            }}
            local json = textutils.serialiseJSON(message)
            -- sleep(1)
            chat.sendFormattedMessage(json, "Server Chatbox", "<>", "&b")
        end

    end

end
parallel.waitForAny(monitorChat, spawnMessageLoop)
