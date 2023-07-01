GLOBAL.setmetatable(env, {
    __index = function(t, k)
        return GLOBAL.rawget(GLOBAL, k)
    end,
})
if TheNet:GetIsClient() then
    return
end
if GetModConfigData('StackMode') then
    modimport 'stack_mode1.lua'
else
    modimport 'stack_mode2.lua'
end
