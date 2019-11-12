
local TeamScene = class( "TeamScene", function() 

return cc.Scene:create() 

end)

function TeamScene.create()
    local scene = TeamScene:new()
    scene:addChild( scene:createLayer() )
    return scene 
end

function TeamScene:createLayer()
    local layer = cc.Layer:create()

    self:loadui( layer )

    self:addVoiceEventListener()

    --进场景的时候初始化默认的麦克风和扬声器状态.
    --小队模式，能听能说
    cc.exports.youmetalk:setSpeakerMute(false); 
    cc.exports.youmetalk:setMicrophoneMute(  false );
    cc.exports.youmetalk:setVolume(70);

    return layer
end

function TeamScene:addTips( tips )
    print(tips)
    self.labelTips:setString( tips )
end

function TeamScene:addVoiceEventListener()
    local eventDispatcher = self:getEventDispatcher()
    local function youmeTips(event)
        local tips = event._usedata
        self:addTips( tips )
    end
    local tipsListener = cc.EventListenerCustom:create("Tips", youmeTips)
    eventDispatcher:addEventListenerWithSceneGraphPriority(tipsListener, self)
   
end

function TeamScene:loadui( layer )
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    print("load ui")

    local lableID = cc.Label:createWithSystemFont("", "Arial", 40)
    lableID:setPosition(20, visibleSize.height -80);
    lableID:setAnchorPoint(0, 0);
    lableID:setString("用户:"..cc.exports.userID )
    self:addChild(lableID, 0 );

    local lableRoom = cc.Label:createWithSystemFont("", "Arial", 40)
    lableRoom:setPosition(20, visibleSize.height - 160);
    lableRoom:setAnchorPoint(0, 0);
    lableRoom:setString("频道:"..cc.exports.roomID )
    self:addChild(lableRoom, 0 );
    
    local btnBack = ccui.Button:create("", "", "")
    btnBack:setTitleFontSize(80);
    btnBack:setPosition(visibleSize.width - 100 ,  10);
    btnBack:setAnchorPoint(0.5, 0 );
    btnBack:setTitleText("退出");
    btnBack:setTitleColor( cc.c3b(255,255,255) );
    layer:addChild(btnBack , 0 );

    btnBack:addClickEventListener(  function (sender ) 
        local eventDispatcher = self:getEventDispatcher();
        eventDispatcher:removeCustomEventListeners( "Tips" )

        local cLoginScene =  require( "app.views.LoginScene" )
        local scene = cLoginScene.create();
        cc.Director:getInstance():replaceScene( scene )

        --[[/**
             *  功能描述:退出所有语音频道
             *
             *  @return 错误码，详见YouMeConstDefine.h定义
            */
            ]]
        local errorcode = cc.exports.youmetalk:leaveChannelAll() 
        if errorcode == 0 then 
            print("调用退出所有频道成功")
        else
            print("调用退出所有频道失败，错误码:"..errorcode)
        end   

    
    end )

    local btnPause = ccui.Button:create("", "", "")
    btnPause:setTitleFontSize(80);
    btnPause:setPosition(visibleSize.width /2 ,  280);
    btnPause:setAnchorPoint(0.5, 0 );
    btnPause:setTitleText("暂停");
    btnPause:setTitleColor( cc.c3b(255,255,255) );
    layer:addChild(btnPause , 0 );

    btnPause:addClickEventListener(  function (sender ) 
        --[[/**
             *  功能描述: 暂停通话，释放麦克风等设备资源
             *  @return YOUME_SUCCESS - 成功
             *          其他 - 具体错误码
            */
        ]]
        local errorcode = cc.exports.youmetalk:pauseChannel() 
        if errorcode == 0 then 
            print("调用暂停成功")
        else
            print("调用暂停失败，错误码："..errorcode)
        end   
    end )

    local btnResume = ccui.Button:create("", "", "")
    btnResume:setTitleFontSize(80);
    btnResume:setPosition(visibleSize.width /2 ,  180);
    btnResume:setAnchorPoint(0.5, 0 );
    btnResume:setTitleText("恢复");
    btnResume:setTitleColor( cc.c3b(255,255,255) );
    layer:addChild(btnResume , 0 );

    btnResume:addClickEventListener(  function (sender ) 
           --[[/**
             *  功能描述: 恢复通话
             *  @return YOUME_SUCCESS - 成功
             *          其他 - 具体错误码
            */
        ]]
        local errorcode = cc.exports.youmetalk:resumeChannel() 
        if errorcode == 0 then 
            print("调用恢复成功")
        else
            print("调用恢复失败，错误码："..errorcode)
        end   
    end )

    self.labelTips = cc.Label:createWithSystemFont("", "Arial", 40)
    self.labelTips:setTextColor( cc.c3b(255,255,255) );
    self.labelTips:setPosition( 0,0 );
    self.labelTips:setAnchorPoint( 0,0) ;
    self:addChild( self.labelTips );
end

return TeamScene
