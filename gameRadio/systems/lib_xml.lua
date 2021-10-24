--[[
    _  __  _  ____ __    __ ____ _____      ____  ____ __  __ ____  _     ____ _____  __  __  ____  __  _  _____ 
    | ||  \| |/ () \\ \/\/ /| ===|| () )    | _) \| ===|\ \/ /| ===|| |__ / () \| ()_)|  \/  || ===||  \| ||_   _|
    |_||_|\__|\____/ \_/\_/ |____||_|\_\    |____/|____| \__/ |____||____|\____/|_|   |_|\/|_||____||_|\__|  |_|  
    ==============================================================================================================
                                              inowerdevelopment@gmail.com
                                                    sally.#4722
]]

lib_xml       ={

    var             ={
        xml_files   = {
            ["_playlists.xml"] = {
                xmlRoot     = "playlists";
                xmlChilds   = {
                    -- childName = {values...}
                    --[[
                        for this particular child, config for tracks looks like:
                        ["playlist"] = {
                            configValues = {
                                {"id", "String playlistName"};
                            };
                            subChild = {
                                ["track"..id] = {configValues={
                                    {"trackTitle", "string trackTitle"};
                                    {"trackArtist", "string trackArtist"};
                                    {"trackLink", "string trackDownloadLink"};
                                }};
                            };
                        };
                    ]]


                    --[[
                        Musisz zrobic podpiecie pod jeden child "playlist" i tam dac tablice nowych playlist wraz z id i trackami na nim
                    ]]
                    ["playlist"] = {
                        attributes = {
                            {"id", "Playlista1"};
                        };
                        configValues = {
                            xmlSubChild = { 
                                ["track1"] = {configValues={
                                    {"trackTitle", "string trackTitle"};
                                    {"trackArtist", "string trackArtist"};
                                    {"trackLink", "string trackDownloadLink"};
                                }};
                            };
                        };
                    };
                    ["playlist"] = {
                        attributes = {
                            {"id", "Bedoes"};
                        };
                        configValues = {
                            xmlSubChild = { 
                                ["track1"] = {configValues={
                                    {"trackTitle", "string trackTitle"};
                                    {"trackArtist", "string trackArtist"};
                                    {"trackLink", "string trackDownloadLink"};
                                }};
                            };
                        };
                    };
                };
            };
            ["_radioSettings.xml"] = {
                xmlRoot     = "settings";
                xmlChilds   = {
                    ["audio"] = {configValues={
                        {"volume", 50};
                    }};
                };
            }
        };
    };
};

function lib_xml.checkXMLFile(fileName)
    if(lib_xml.var.xml_files and lib_xml.var.xml_files[fileName])then 
        if(fileExists(fileName))then return true end;
    end
    return false;
end
function checkXMLFile(fileName)
    return lib_xml.checkXMLFile(fileName);
end

function lib_xml.deleteOldFile(fileName)
    if(lib_xml.checkXMLFile() and fileName)then 
        fileDelete(fileName);
        return true;
    end
    return false;
end

function lib_xml.setAttributes(xmlNode, _xmlAttributes)
    if(xmlNode)then 
        --[[
            _xmlAttributes = {
                {"attName", "value"};
                ...
            };
        ]]
        if(_xmlAttributes and #_xmlAttributes > 0)then 
            for index, value in ipairs(_xmlAttributes) do 
                if(value and (value[1] and value[2]))then 
                    xmlNodeSetAttribute(xmlNode, value[1], value[2]);
                end
            end
        end
        return true;
    end
end

function lib_xml.nodeValue(xmlChild, _xmlNodes)
    if(xmlChild)then 
        --[[
            _xmlNodes = {
                {"nodeName", "value", [index = 0, 
                    attributes = {
                        {"attName", "value"};
                        ...
                    }
                ]}; -- [ (optional) ]
                ...
            };
        ]]

        if(_xmlNodes and #_xmlNodes > 0)then 
            for index, value in pairs(_xmlNodes) do 
                -- if(not xmlFindChild(child, attributevalue[1], (value.index or 0)))then 
                    local createChild = xmlCreateChild(xmlChild, value[1]);
                    if(createChild)then 
                        if(value[2])then xmlNodeSetValue(createChild, value[2]) end;
                        if(value.attributes)then 
                            lib_xml.setAttributes(createChild, value.attributes);
                        end
                    end
                -- end
            end
        end
    end
    return true;
end

function lib_xml.nodeChildren(xmlChild, _xmlNodes)
    if(xmlChild)then 
        --[[
            _xmlNodes = {
                [childName] = {configValues={
                    xmlSubChild = { -- for another child with configValues
                        -- for loop
                    };
                    {"childData", "childData"}
                }, attributes = {
                    {"attName", "value"};
                    ...
                }};
                ...
            };
        ]]
        local playlistNextID = 0;
        for index, value in pairs(_xmlNodes) do 
            if(index and value)then 
                outputDebugString("index = "..index..", created | #Att: ");
                local findId = 0;
                if(index == "playlist")then 
                    findId = playlistNextID;
                end
                local findThatChild = xmlFindChild(xmlChild, index, findId);
                local id = lib_xml.getXMLSavedAttributes({xmlChild = findThatChild, attribute = "id"});
                if(not findThatChild or (findThatChild and id))then 
                    lib_xml.nodeValue(xmlChild, {{index, false, attributes = value.attributes}});
                    findThatChild = xmlFindChild(xmlChild, index, findId);
                    if(findThatChild)then
                        if(value.configValues)then 
                            if(value.configValues.xmlSubChild)then 
                                lib_xml.nodeChildren(findThatChild, value.configValues.xmlSubChild);
                            end
                            lib_xml.nodeValue(findThatChild, value.configValues);
                        end
                    end
                    playlistNextID = playlistNextID + 1;
                end
            end
        end
    end
end 

function lib_xml.isXMLUpdated()
    for fileIndex, fileValue in pairs(lib_xml.var.xml_files) do 
        if(lib_xml.checkXMLFile(fileIndex))then 
            local loadFile = xmlLoadFile(fileIndex);
            if(loadFile)then 
                lib_xml.nodeChildren(loadFile, fileValue.xmlChilds);
                xmlSaveFile(loadFile);
                xmlUnloadFile(loadFile);
            end
        end
    end
    return true;
end

function lib_xml.build()
    for fileIndex, fileValue in pairs(lib_xml.var.xml_files) do 
        local creationState = xmlCreateFile(fileIndex, fileValue.xmlRoot);
        if(creationState)then 
            xmlSaveFile(creationState)
            xmlUnloadFile(creationState)
            outputDebugString(fileIndex.." | "..(creationState and "true" or "false").." | Root: "..fileValue.xmlRoot.." | Exists: "..(fileExists(fileIndex) and "true" or "false"))
        end
        assert(creationState, "XMLFile "..fileIndex.." failed to build");
    end
    return lib_xml.isXMLUpdated();
end

function lib_xml.setXMLFileNewData(player, argTab) -- this function has a submissive export called setXMLFileNewData
    if(player) and (isElement(player)) and (player) == (getLocalPlayer()) and (argTab) and (type(argTab)) == ("table")then 
        --[[
            argTab = {
                {
                    xmlFile = "fileName.xml";
                    xmlChild = "config";
                    xmlChildValue = "interfaceStyle";
                    nodeValue = "value";
                }
            }
        ]]
        if(#argTab) > (0)then
            for argTabIndex, argTabValue in pairs(argTab) do
                if(argTabValue and argTabValue.xmlFile and lib_xml.var.xml_files[argTabValue.xmlFile])then
                    local loadFile = xmlLoadFile(lib_xml.var.expectFile);
                    if(not loadFile)then 
                        if(lib_xml.build())then 
                            lib_xml.setXMLFileNewData(player, argTab);
                            return false;
                        end
                    end
                    if(argTabValue.xmlChild and lib_xml.var.xmlChilds[argTabValue.xmlChild])then 
                        local mainChild = xmlFindChild(loadFile, argTabValue.xmlChild, 0);
                        if(mainChild)then
                            local subChildValue = xmlFindChild(mainChild, argTabValue.xmlChildValue, 0);
                            if(subChildValue)then
                                xmlNodeSetValue(subChildValue, argTabValue.nodeValue);
                                xmlSaveFile(loadFile);
                            else
                                outputDebugString("findChild "..argTabValue.xmlChildValue.." failed")
                                for attributeIndex, attributevalue in pairs(lib_xml.var.xmlChilds[argTabValue.xmlChild].configValues) do 
                                    if(attributevalue and attributevalue[1])then 
                                        attributevalue.child = xmlCreateChild(mainChild, attributevalue[1])
                                        xmlNodeSetValue(attributevalue.child, attributevalue[2]);
                                        if(attributevalue.elementAttributes and #attributevalue.elementAttributes > 0)then 
                                            for elementIndex, elementValue in pairs(attributevalue.elementAttributes) do 
                                                if(elementValue)then 
                                                    xmlNodeSetAttribute(attributevalue.child, elementValue[1], elementValue[2]);
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            xmlUnloadFile(loadFile);
                            if(lib_xml.deleteOldFile())then
                                lib_xml.initialize();
                            end
                        end
                        xmlUnloadFile(loadFile);
                    end
                end
            end
        end
    end
    return false;
end

function setXMLFileNewData(player, argTab)
    return lib_xml.setXMLFileNewData(player, argTab);
end

function lib_xml.getXMLSavedValues(player, getValue) -- this function has a submissive export called getXMLSavedValues();
    --[[
        getValue = {
            xmlFile = "fileName.xml";
            xmlChild = "config";
            xmlChildValue = "interfaceStyle";
        }
    ]]
    if(player) and (isElement(player)) and (player) == (getLocalPlayer()) and (getValue) and (lib_xml.checkXMLFile(getValue.xmlFile))then 
        -- outputDebugString("getXMLSavedValues 1", 0, 255, 255, 255);
        local loadFile = xmlLoadFile(getValue.xmlFile, true);
        if(loadFile)then
            if(getValue.xmlChild and lib_xml.var.xml_files[getValue.xmlFile].xmlChilds[getValue.xmlChild])then 
                local mainChild = xmlFindChild(loadFile, getValue.xmlChild, 0);
                if(mainChild)then
                    local subChildValue = xmlFindChild(mainChild, getValue.xmlChildValue, 0);
                    if(subChildValue)then
                        return xmlNodeGetValue(subChildValue);
                    end
                end
            end
        end
        xmlUnloadFile(loadFile);
    end
    return false;
end

function getXMLSavedValues(player, getValue) 
    return lib_xml.getXMLSavedValues(player, getValue);
end


function lib_xml.getXMLSavedAttributes(xmlAttribute) -- this function has a submissive export called getXMLSavedAttributes
    --[[
        xmlAttribute = {
            xmlChild = xmlChild;
            attribute = attributeName;
        };
    ]]
    if(xmlAttribute and xmlAttribute.xmlChild and xmlAttribute.attribute)then
        return xmlNodeGetAttribute(xmlAttribute.xmlChild, xmlAttribute.attribute);
    end
    return false;
end

function getXMLSavedAttributes(xmlAttribute) 
    return lib_xml.getXMLSavedAttributes(xmlAttribute);
end

-- function command()
--     outputChatBox("InterfaceColor: "..(lib_xml.getXMLSavedValues(getLocalPlayer(), {xmlChild = "config", xmlChildValue = "interfaceColor"}) or "false"))
-- end;addCommandHandler("xmlGet", command);

function lib_xml.init()
    for index, value in pairs(lib_xml.var.xml_files) do 
        if(not lib_xml.checkXMLFile(index))then
            if(lib_xml.build())then 
                return true;
            end
        end
    end
    lib_xml.isXMLUpdated();
    return false;
end