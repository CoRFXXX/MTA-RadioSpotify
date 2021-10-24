--[[
    _  __  _  ____ __    __ ____ _____      ____  ____ __  __ ____  _     ____ _____  __  __  ____  __  _  _____ 
    | ||  \| |/ () \\ \/\/ /| ===|| () )    | _) \| ===|\ \/ /| ===|| |__ / () \| ()_)|  \/  || ===||  \| ||_   _|
    |_||_|\__|\____/ \_/\_/ |____||_|\_\    |____/|____| \__/ |____||____|\____/|_|   |_|\/|_||____||_|\__|  |_|  
    ==============================================================================================================
                                              inowerdevelopment@gmail.com
                                                    sally.#4722
]]

lib_audio = {
    objects = {
        --[[
            [int trackID] = {
                sound = object Sound;
            };
        ]]
    };
};

function lib_audio.searchSound(trackID) 
    if(trackID and tonumber(trackID))then 
        return lib_audio.objects[trackID];
    end
    return false; 
end

function lib_audio.setSoudVolume(trackID, newVolume)
    if(trackID and tonumber(trackID))then 
        if(lib_audio.searchSound(trackID) and isElement(lib_audio.objects[trackID]))then 
            if(newVolume >= 0 and newVolume <= 100)then 
                return setSoundVolume(lib_audio.objects[trackID], newVolume);
            end
        end
    end
    return false; 
end

function lib_audio.pauseSound(trackID, boolean) 
    if(trackID and tonumber(trackID))then 
        if(lib_audio.searchSound(trackID) and isElement(lib_audio.objects[trackID]))then 
            return setSoundPaused(lib_audio.objects[trackID], boolean);
        end
    end
end

function lib_audio.destroySound(trackID) 
    if(trackID and tonumber(trackID))then 
        if(lib_audio.searchSound(trackID) and isElement(lib_audio.objects[trackID]))then 
            destroyElement(lib_audio.objects[trackID]);
        end
        lib_audio.objects[trackID] = nil;
        return true;
    end
    return false; 
end

function lib_audio.playSound(trackID, trackLink)
    if(trackID and tonumber(trackID) and trackLink)then 
        if(not lib_audio.searchSound(trackID))then 
            lib_audio.objects[trackID] = playSound(trackLink);
            if(lib_audio.searchSound(trackID) and isElement(lib_audio.objects[trackID]))then 
                return true;
            end
        end
    end
    return false;
end

function lib_audio.init()
    return true;
end