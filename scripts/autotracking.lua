-- Configuration --------------------------------------
AUTOTRACKER_ENABLE_DEBUG_LOGGING = false
-------------------------------------------------------

print("")
print("Active Auto-Tracker Configuration")
print("---------------------------------------------------------------------")
print("Enable Item Tracking:        ", AUTOTRACKER_ENABLE_ITEM_TRACKING)
if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
    print("Enable Debug Logging:        ", "true")
end
print("---------------------------------------------------------------------")
print("")

function autotracker_started()
    -- Invoked when the auto-tracker is activated/connected
end

U8_READ_CACHE = 0
U8_READ_CACHE_ADDRESS = 0

U16_READ_CACHE = 0
U16_READ_CACHE_ADDRESS = 0

function InvalidateReadCaches()
    U8_READ_CACHE_ADDRESS = 0
    U16_READ_CACHE_ADDRESS = 0
end

function ReadU8(segment, address)
    if U8_READ_CACHE_ADDRESS ~= address then
        U8_READ_CACHE = segment:ReadUInt8(address)
        U8_READ_CACHE_ADDRESS = address        
    end

    return U8_READ_CACHE
end

function ReadU16(segment, address)
    if U16_READ_CACHE_ADDRESS ~= address then
        U16_READ_CACHE = segment:ReadUInt16(address)
        U16_READ_CACHE_ADDRESS = address        
    end

    return U16_READ_CACHE
end

function updateUsableItemFromBothBytesAndFlag(segment, code, address, address2, flag)
    local item = Tracker:FindObjectForCode(code)
    if item then
        local value = ReadU8(segment, address)
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
            print(item.Name, code, flag)
        end

        local flagTest = value & flag

        if flagTest ~= 0 then
            local used = ReadU8(segment, address2)
            local usedTest = used & flag
            if usedTest ~= 0 then
              item.CurrentStage = 2
            else
              item.CurrentStage = 1
            end
        else
            item.CurrentStage = 0
        end
    end
end

function updateToggleItemFromByteAndFlag(segment, code, address, flag)
    local item = Tracker:FindObjectForCode(code)
    if item then
        local value = ReadU8(segment, address)
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
            print(item.Name, code, flag)
        end

        local flagTest = value & flag

        if flagTest ~= 0 then
            item.Active = true
        else
            item.Active = false
        end
    end
end

function updateKeyItems(segment)

    InvalidateReadCaches()

    if AUTOTRACKER_ENABLE_ITEM_TRACKING then
 
        updateUsableItemFromBothBytesAndFlag(segment, "package",  0x7e1500, 0x7e1503, 0x01)
        updateUsableItemFromBothBytesAndFlag(segment, "sandruby", 0x7e1500, 0x7e1503, 0x02)
        updateUsableItemFromBothBytesAndFlag(segment, "legend",   0x7e1500, 0x7e1503, 0x04)
        updateUsableItemFromBothBytesAndFlag(segment, "baron",    0x7e1500, 0x7e1503, 0x08)
        updateUsableItemFromBothBytesAndFlag(segment, "harp",     0x7e1500, 0x7e1503, 0x10)
        updateUsableItemFromBothBytesAndFlag(segment, "earth",    0x7e1500, 0x7e1503, 0x20)
        updateUsableItemFromBothBytesAndFlag(segment, "magma",    0x7e1500, 0x7e1503, 0x40)
        updateUsableItemFromBothBytesAndFlag(segment, "tower",    0x7e1500, 0x7e1503, 0x80)
		updateToggleItemFromByteAndFlag(segment, "hook",     0x7e1501, 0x01)
		updateUsableItemFromBothBytesAndFlag(segment, "luca",     0x7e1501, 0x7e1504, 0x02)
        updateUsableItemFromBothBytesAndFlag(segment, "darkness", 0x7e1501, 0x7e1504, 0x04)
        updateUsableItemFromBothBytesAndFlag(segment, "rat",      0x7e1501, 0x7e1504, 0x08)
		updateUsableItemFromBothBytesAndFlag(segment, "adamant",  0x7e1501, 0x7e1504, 0x10)	
		updateUsableItemFromBothBytesAndFlag(segment, "pan",      0x7e1501, 0x7e1504, 0x20)
		updateToggleItemFromByteAndFlag(segment, "spoon",    0x7e1501, 0x40)
		updateUsableItemFromBothBytesAndFlag(segment, "pink",     0x7e1501, 0x7e1504, 0x80)
		updateToggleItemFromByteAndFlag(segment, "crystal",  0x7e1502, 0x01)

    end

end

ScriptHost:AddMemoryWatch("FF4FE Key Items", 0x7e1500, 6, updateKeyItems)