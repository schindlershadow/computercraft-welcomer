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

while true do
    local players = detector.getPlayersInRange(radius) or {}

    if next(players) ~= nil then
        for _, player in ipairs(players) do
            --print("time " .. tostring( lastSent[player]))
            if not lastSent[player] or (lastSent[player]) > cooldown then
                print("Sending chat to ".. player)
                chat.sendMessageToPlayer(
                    "Use \"/warp overworld\" to go to overworld", player)
                --chat.sendMessageToPlayer("Discord: https://discord.gg/5vySCrG", player)

                lastSent[player] = 0
                sleep(1)
                elseif lastSent[player] then
                    lastSent[player] = lastSent[player] + 5
            end
        end
    end

    sleep(5)
end
