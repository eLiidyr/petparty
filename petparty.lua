_addon.name     = "petparty"
_addon.author   = "Elidyr"
_addon.version  = "1.20200906"
_addon.command  = "pp"

local packets = require("packets")
local texts = require("texts")
local images = require("images")
require("tables")
require("texts")
require("logger")

-- ADJUST YOU BAR COLORS HERE!
local colors = {owner={r=10,g=250,b=230}, pet={r=10,g=250,b=100}, hpp={r=200,g=100,b=200}, tp={r=200,g=100,b=200}}
local timer = {clock=0, delay=5}
local pets = {}
local bar_settings = {
    ["pos"]={["x"]=200,["y"]=200},["bg"]={["alpha"]=255,["red"]=0,["green"]=0,["blue"]=0,["visible"]=false},['flags']={["right"]=false,["bottom"]=false,["bold"]=false,["draggable"]=true,["italic"]=false},["padding"]=5,
    ["text"]={["size"]=10,["font"]="lucida console",["fonts"]={},["alpha"]=255,["red"]=255,["green"]=255,["blue"]=255,["stroke"]={["width"]=1,["alpha"]=255,["red"]=0,["green"]=0,["blue"]=0}},
}

local paths = {
    ["Light Spirit"] = ("/icons/lightspirit.png"),
    ["Fire Spirit"] = ("/icons/firespirit.png"),
    ["Ice Spirit"] = ("/icons/icespirit.png"),
    ["Air Spirit"] = ("/icons/airspirit.png"),
    ["Earth Spirit"] = ("/icons/earthspirit.png"),
    ["Thunder Spirit"] = ("/icons/thunderspirit.png"),
    ["Water Spirit"] = ("/icons/waterspirit.png"),
    ["Dark Spirit"] = ("/icons/darkspirit.png"),
    ["Carbuncle"] = ("/icons/carbuncle.png"),
    ["Cait Sith"] = ("/icons/caitsith.png"),
    ["Ifrit"] = ("/icons/ifrit.png"),
    ["Shiva"] = ("/icons/shiva.png"),
    ["Garuda"] = ("/icons/garuda.png"),
    ["Titan"] = ("/icons/titan.png"),
    ["Ramuh"] = ("/icons/ramuh.png"),
    ["Leviathan"] = ("/icons/leviathan.png"),
    ["Fenrir"] = ("/icons/fenrir.png"),
    ["Diabolos"] = ("/icons/diabolos.png"),
    ["Siren"] = ("/icons/siren.png"),
    ["Other"] = ("/icons/rages.png"),
}

local bar = texts.new("", bar_settings)
local icons = {}

local isInParty = function(owner)
    local party = windower.ffxi.get_party() or false
    
    if party then
    
        for i,v in pairs(party) do
            
            if (i:sub(1,1) == "p" or i:sub(1,1) == "a") and tonumber(i:sub(2)) ~= nil and v.mob and owner == v.mob.id then
                return true
            end
            
        end
        
    end
    return false
    
end

windower.register_event("prerender", function()
    
    if (os.clock()-timer.clock) > timer.delay then
        local party = windower.ffxi.get_party() or false
        local temp = {}
        local count = 0
        local pos = 0
    
        if party then
        
            for i,v in pairs(party) do
                
                if (i:sub(1,1) == "p" or i:sub(1,1) == "a") and tonumber(i:sub(2)) ~= nil then
                    
                    if v.mob and v.mob.pet_index then
                        local owner = windower.ffxi.get_mob_by_id(v.mob.id) or false
                        local pet = windower.ffxi.get_mob_by_index(v.mob.pet_index) or false
                        local color = {
                            owner = string.format("%s,%s,%s", colors.owner.r, colors.owner.g, colors.owner.b),
                            pet = string.format("%s,%s,%s", colors.pet.r, colors.pet.g, colors.pet.b),
                            hpp = string.format("%s,%s,%s", colors.hpp.r, colors.hpp.g, colors.hpp.b),
                            tp = string.format("%s,%s,%s", colors.tp.r, colors.tp.g, colors.tp.b),
                        }
                        
                        if owner and pet and pet.hpp > 0 then
                            table.insert(temp, string.format(" \\cs(%s)%+10s\\cr\\cs(%s)[%s]\\cr - \\cs(%s)HPP: %s%%\\cr \\cs(%s)TP: %-10s\\cr", color.owner, owner.name, color.pet, pet.name, color.hpp, pet.hpp or 0, color.tp, pet.tp or 0))
                        
                            if not icons[count] then
                                icons[count] = images.new({color={alpha = 255},texture={fit = false},draggable=false})
                            end
                            
                            if paths[pet.name] then
                                local size = bar_settings.text.size+5
    
                                -- Update Icon.
                                icons[count]:path(string.format("%sicons/%s.png", windower.addon_path, pet.name))
                                icons[count]:size(size, size)
                                icons[count]:transparency(0)
                                icons[count]:pos_x(bar:pos_x())
                                icons[count]:pos_y((bar:pos_y() + (pos*size))+2)
                                icons[count]:show()
                                
                            else
                                local size = bar_settings.text.size+5
    
                                -- Update Icon.
                                icons[count]:path(string.format("%sicons/other.png", windower.addon_path))
                                icons[count]:size(size, size)
                                icons[count]:transparency(0)
                                icons[count]:pos_x(bar:pos_x())
                                icons[count]:pos_y((bar:pos_y() + (pos*size))+2)
                                icons[count]:show()
                                
                            end
                            pos = (pos + 1)
                            
                        end
                    
                    elseif v.mob and v.mob.pet_index == nil then
                        
                        if icons[count] then
                            icons[count]:hide()
                        end
                        
                    end
                    count = (count + 1)
                    
                end
                
            end
            
            -- Update text display.
            bar:text(table.concat(temp, "\n"))
            bar:show()
            bar:update()
            
        end
        timer.clock = os.clock()
        
    end
    
end)