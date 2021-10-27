--[[
    _  __  _  ____ __    __ ____ _____      ____  ____ __  __ ____  _     ____ _____  __  __  ____  __  _  _____ 
    | ||  \| |/ () \\ \/\/ /| ===|| () )    | _) \| ===|\ \/ /| ===|| |__ / () \| ()_)|  \/  || ===||  \| ||_   _|
    |_||_|\__|\____/ \_/\_/ |____||_|\_\    |____/|____| \__/ |____||____|\____/|_|   |_|\/|_||____||_|\__|  |_|  
    ==============================================================================================================
                                              inowerdevelopment@gmail.com
                                                    sally.#4722
]]

playlistController = {
    playlists = {

    };
};

function playlistController.build()
    local fileName = "_playlists.xml";
    local xmlNode = "playlist";
    local loadFile = xmlLoadFile(fileName);
    if(loadFile)then 
        lib_xml.nodeChildren(loadFile, lib_xml.var.xml_files[fileName].xmlChilds[xmlNode].lists, {index = "playlist"});
        xmlSaveFile(loadFile);
        xmlUnloadFile(loadFile);
    end
    return false;
end

function playlistController.load()
    
end

function playlistController.init()
    playlistController.build();
    return true;
end