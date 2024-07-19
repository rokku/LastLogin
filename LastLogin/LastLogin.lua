-- LastLogin.lua
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT")

local function formatTime()
    return time(), date("%A, %B %d at %I:%M %p")
end

local function calculateTimeDifference(lastTime)
    local currentTime = time()
    local diff = currentTime - lastTime

    if diff >= 86400 then
        local days = math.floor(diff / 86400)
        return days .. " day" .. (days > 1 and "s" or "")
    elseif diff >= 3600 then
        local hours = math.floor(diff / 3600)
        return hours .. " hour" .. (hours > 1 and "s" or "")
    elseif diff >= 60 then
        local minutes = math.floor(diff / 60)
        return minutes .. " minute" .. (minutes > 1 and "s" or "")
    else
        return diff .. " second" .. (diff > 1 and "s" or "")
    end
end

local function onPlayerLogin()
    if LastLoginData then
        local lastTime, lastLoginString = unpack(LastLoginData)
        local timeDiff = calculateTimeDifference(lastTime)
        C_Timer.After(5, function()
            print("You last logged in on " .. lastLoginString .. " (" .. timeDiff .. " ago).")
        end)
    else
        print("This is your first login on this character.")
    end
    LastLoginData = {formatTime()}
end

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        onPlayerLogin()
    elseif event == "PLAYER_LOGOUT" then
        LastLoginData = {formatTime()}
    end
end)
