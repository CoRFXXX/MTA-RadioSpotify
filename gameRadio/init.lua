--[[
    _  __  _  ____ __    __ ____ _____      ____  ____ __  __ ____  _     ____ _____  __  __  ____  __  _  _____ 
    | ||  \| |/ () \\ \/\/ /| ===|| () )    | _) \| ===|\ \/ /| ===|| |__ / () \| ()_)|  \/  || ===||  \| ||_   _|
    |_||_|\__|\____/ \_/\_/ |____||_|\_\    |____/|____| \__/ |____||____|\____/|_|   |_|\/|_||____||_|\__|  |_|  
    ==============================================================================================================
                                              inowerdevelopment@gmail.com
                                                    sally.#4722
]]

init = {

};

function init.build()
    if(lib_xml)then lib_xml.init() end;
    if(lib_audio)then lib_audio.init() end;
    if(playlistController)then playlistController.init() end;
end
addEventHandler("onClientResourceStart", resourceRoot, init.build);