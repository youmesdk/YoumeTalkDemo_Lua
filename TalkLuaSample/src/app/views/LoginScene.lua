-- require( "app.views.Youme" )
local LoginScene = class( "LoginScene", function() 

return cc.Scene:create() 

end)

function LoginScene.create()
    local scene = LoginScene:new()
    scene:addChild( scene:createLayer() )
    return scene 
end

function LoginScene:createLayer()
    local layer = cc.Layer:create()
    
    self:loadui( )

    local eventDispatcher = self:getEventDispatcher()
    local function youmeTips(event)
        local tips = event._usedata
        self:addTips( tips )
    end
    local tipsListener = cc.EventListenerCustom:create("Tips", youmeTips)
    eventDispatcher:addEventListenerWithSceneGraphPriority(tipsListener, self)

    local function onEnterRoom(event)
        print("get Msg enter room ")
        eventDispatcher:removeCustomEventListeners(  "Tips" )
        eventDispatcher:removeCustomEventListeners(  "EnterRoom" )

        if cc.exports.roleType == 1 then 
            local cTeamScene = require( "app.views.TeamScene" )
            local scene = cTeamScene.create();
            cc.Director:getInstance():replaceScene( scene );
        elseif cc.exports.roleType == 3 or cc.exports.roleType == 5 then  
            --Host场景通过cc.exports.roleType来判断是主播还是听众
            local cHostScene = require( "app.views.HostScene" )
            local scene = cHostScene.create();
            cc.Director:getInstance():replaceScene( scene );
        end 
    end
    local enterListener = cc.EventListenerCustom:create("EnterRoom", onEnterRoom)
    eventDispatcher:addEventListenerWithSceneGraphPriority(enterListener, self)

    return layer
end

function LoginScene:addTips( tips )
    print(tips)
    self.lableTips:setString( tips )
end

function LoginScene:isValidID( id )
    if string.len(id)  == 0 then 
        return false 
    end

    local tempstr  = id
    tempstr = string.gsub( tempstr, "_","")
    tempstr = string.gsub( tempstr, "%a","")
    tempstr = string.gsub(tempstr, "%d","" )

    if string.len( tempstr ) == 0 then 
        return true
    else 
        return false
    end
end

function LoginScene:loginChatRoom( roleType )
    --清空tips
    self:addTips("")
	print("login chat room ")
	local userID = self.idInput:getText()
	local roomID = self.roomInput:getText()

    if not self:isValidID( userID ) then 
        self:addTips("用户ID无效")
        return 
    end

    if not self:isValidID( roomID ) then 
        self:addTips("房间ID无效")
        return 
    end

    cc.exports.userID = userID
    cc.exports.roomID = roomID
    cc.exports.roleType = roleType 


    self:addTips( "enter room: userid:"..cc.exports.userID..",roomID:"..cc.exports.roomID  )

	print("enter room: userid:"..cc.exports.userID..",roomID:"..cc.exports.roomID )
	--[[YOUME
        /*!
         *  进入房间
         *
         *  @param pUserID   用户ID
         *  @param pChannelID 频道ID
         *  @param eUserRole 用户角色（YouMeUserRole）
         *  @return 错误码
        */
    ]]
    local  ymErrorcode = cc.exports.youmetalk:joinChannelSingleMode( cc.exports.userID ,cc.exports.roomID,cc.exports.roleType ,false);

    if 0  == ymErrorcode then 
    	print("调用进入房间成功")
        self:addTips("开始进入房间,u:"..cc.exports.userID..",r:"..cc.exports.roomID  )
    else
        self:addTips("调用进入房间失败，错误码：" ..  ymErrorcode)
    	print("调用进入房间失败，错误码：".. ymErrorcode);
    end
end

function LoginScene:loadui( )
    local labelX = 50;
    print(layer)
    local visibleSize = cc.Director:getInstance():getVisibleSize()
	-- 
	local lableID = cc.Label:createWithSystemFont("输入用户ID", "Arial", 80)
	lableID:setPosition(labelX, 600);
    lableID:setAnchorPoint(0, 0);
    self:addChild(lableID, 0 );

    local labelRoom = cc.Label:createWithSystemFont("输入房间ID", "Arial", 80);
    labelRoom:setPosition(labelX, 450);
    labelRoom:setAnchorPoint(0, 0);
    self:addChild(labelRoom, 0 );

    self.lableTips = cc.Label:createWithSystemFont("", "Arial", 40)
    self.lableTips:setPosition( 0 , 0 )
    self.lableTips:setHorizontalAlignment( cc.TEXT_ALIGNMENT_LEFT )
    self.lableTips:setAnchorPoint(0, 0)
    self:addChild(self.lableTips, 0 )

    self.idInput = cc.EditBox:create(cc.size(400, 100), "res/chat_bottom_textfield.png");
    self.idInput:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT);
    self.idInput:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.idInput:setAnchorPoint(0, 0);
    self.idInput:setFontColor(cc.c3b(0,0,0));
    self.idInput:setPosition(labelX + 450, 600);
    self.idInput:setMaxLength(10);
    self:addChild( self.idInput, 0 );
    self.idInput:setText(cc.exports.userID)

    self.roomInput = cc.EditBox:create(cc.size(400, 100), "res/chat_bottom_textfield.png");
    self.roomInput:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT);
    self.roomInput:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.roomInput:setAnchorPoint(0, 0);
    self.roomInput:setFontColor(cc.c3b(0,0,0));
    self.roomInput:setPosition(labelX + 450, 450);
    self.roomInput:setMaxLength(10);
    self:addChild( self.roomInput, 0 );
    self.roomInput:setText(cc.exports.roomID)


    local btnTeam = ccui.Button:create("", "", "")
    btnTeam:setTitleFontSize(80);
    btnTeam:setPosition(visibleSize.width/2 , 280);
    btnTeam:setAnchorPoint(0.5,0);
    btnTeam:setTitleText("小队频道");
    self:addChild(btnTeam , 0 );
    btnTeam:addClickEventListener(  function (sender ) 
        self:loginChatRoom( 1 );
    end );

    local btnListener = ccui.Button:create("", "", "")
    btnListener:setTitleFontSize(80);
    btnListener:setPosition(visibleSize.width/2 , 180);
    btnListener:setAnchorPoint(0.5,0);
    btnListener:setTitleText("主播频道-听众");
    self:addChild(btnListener , 0 );
    btnListener:addClickEventListener(  function (sender ) 
        self:loginChatRoom( 3 );
    end );

    local btnHost = ccui.Button:create("", "", "")
    btnHost:setTitleFontSize(80);
    btnHost:setPosition(visibleSize.width/2 , 80);
    btnHost:setAnchorPoint(0.5,0);
    btnHost:setTitleText("主播频道-主播");
    self:addChild(btnHost , 0 );
    btnHost:addClickEventListener(  function (sender ) 
        self:loginChatRoom( 5 );
    end );
end

return LoginScene
