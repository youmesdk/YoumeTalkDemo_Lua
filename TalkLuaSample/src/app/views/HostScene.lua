
local HostScene = class( "HostScene", function() 

return cc.Scene:create() 

end)

function HostScene.create()
    local scene = HostScene:new()
    scene:addChild( scene:createLayer() )
    return scene 
end

function HostScene:createLayer()
    local layer = cc.Layer:create()

    self:loadCommonUI( layer )

    if cc.exports.roleType == 5 then
        self:loadHostUI( layer ) 

        --进场景的时候初始化默认的麦克风和扬声器状态.
        --主播默认不开麦克风，等上麦再开
        cc.exports.youmetalk:setSpeakerMute(false); 
        cc.exports.youmetalk:setMicrophoneMute( true);
        cc.exports.youmetalk:setVolume(70);
    else
        --听众不需要麦克风 
        cc.exports.youmetalk:setSpeakerMute(false);
        cc.exports.youmetalk:setMicrophoneMute( true );
        cc.exports.youmetalk:setVolume(70);
    end
    
    self:addVoiceEventListener()

    return layer
end

function HostScene:addVoiceEventListener()
    local eventDispatcher = self:getEventDispatcher()
    local function youmeTips(event)
        local tips = event._usedata
        self:addTips( tips )
    end
    local tipsListener = cc.EventListenerCustom:create("Tips", youmeTips)
    eventDispatcher:addEventListenerWithSceneGraphPriority(tipsListener, self)
end

function HostScene:addTips( tips )
    print(tips)
    self.labelTips:setString( tips )
end

function HostScene:loadCommonUI( layer )
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    print("load ui")

    local lableID = cc.Label:createWithSystemFont("", "Arial", 40)
    lableID:setPosition(20, visibleSize.height -80);
    lableID:setAnchorPoint(0, 0);
    lableID:setString("用户:"..cc.exports.userID )
    layer:addChild(lableID, 0 );

    local lableRoom = cc.Label:createWithSystemFont("", "Arial", 40)
    lableRoom:setPosition(20, visibleSize.height - 160);
    lableRoom:setAnchorPoint(0, 0);
    lableRoom:setString("频道:"..cc.exports.roomID )
    layer:addChild(lableRoom, 0 );
    
    local btnBack = ccui.Button:create("", "", "")
    btnBack:setTitleFontSize(80);
    btnBack:setPosition(visibleSize.width - 100 ,  10);
    btnBack:setAnchorPoint(0.5, 0 );
    btnBack:setTitleText("退出");
    btnBack:setTitleColor( cc.c3b(255,255,255) );
    layer:addChild(btnBack , 0 );

    btnBack:addClickEventListener(  function (sender ) 
        local eventDispatcher = self:getEventDispatcher();
        eventDispatcher:removeCustomEventListeners(  "Tips" )

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


    self.labelTips = cc.Label:createWithSystemFont("", "Arial", 40)
    self.labelTips:setTextColor( cc.c3b(255,255,255) );
    self.labelTips:setPosition( 0,0 );
    self.labelTips:setAnchorPoint( 0,0) ;
    layer:addChild( self.labelTips );
end

function HostScene:loadHostUI( layer )
    local visibleSize = cc.Director:getInstance():getVisibleSize()

    local btnOpenMic = ccui.Button:create("", "", "")
    btnOpenMic:setTitleFontSize(80);
    btnOpenMic:setPosition(300 ,  280);
    btnOpenMic:setAnchorPoint(0.5, 0 );
    btnOpenMic:setTitleText("上麦");
    btnOpenMic:setTitleColor( cc.c3b(255,255,255) );
    layer:addChild(btnOpenMic , 0 );

    btnOpenMic:addClickEventListener(  function (sender ) 
        --[[/**
             *  功能描述:设置麦克风静音
             *
             *  @param bOn:true——静音，false——取消静音
             *  @return 无
             */]]
        cc.exports.youmetalk:setMicrophoneMute(false);
        self:addTips("上麦");
    end)

    local btnCloseMic = ccui.Button:create("", "", "")
    btnCloseMic:setTitleFontSize(80);
    btnCloseMic:setPosition(300 ,  180);
    btnCloseMic:setAnchorPoint(0.5, 0 );
    btnCloseMic:setTitleText("下麦");
    btnCloseMic:setTitleColor( cc.c3b(255,255,255) );
    layer:addChild(btnCloseMic , 0 );

    btnCloseMic:addClickEventListener(  function (sender ) 
        --[[/**
             *  功能描述:设置麦克风静音
             *
             *  @param bOn:true——静音，false——取消静音
             *  @return 无
             */]]
        cc.exports.youmetalk:setMicrophoneMute(true);
        self:addTips("下麦");
    end)

    local btnPlayMusic = ccui.Button:create("", "", "")
    btnPlayMusic:setTitleFontSize(80);
    btnPlayMusic:setPosition( 700,  280);
    btnPlayMusic:setAnchorPoint(0.5, 0 );
    btnPlayMusic:setTitleText("播放音乐");
    btnPlayMusic:setTitleColor( cc.c3b(255,255,255) );
    layer:addChild(btnPlayMusic , 0 );

    btnPlayMusic:addClickEventListener(  function (sender ) 
        local path = ""
        --android平台直接播放资源目录下的音乐有问题，这里写死个sdcard的路径
        --请大家调用的时候自己换合适的路径
        local targetPlatform = cc.Application:getInstance():getTargetPlatform()
        print("os_target:"..targetPlatform )
        if targetPlatform == cc.PLATFORM_OS_ANDROID then
            path = "/sdcard/temp/shinian.mp3"
        else
            path = cc.FileUtils:getInstance():fullPathForFilename("res/music/shinian.mp3")
        end

        
        --[[/**
             *  功能描述: 如果当前正在播放背景音乐的话，停止播放
             *  @return YOUME_SUCCESS - 成功
             *          其他 - 具体错误码
             */
        ]]
        local errorcode = cc.exports.youmetalk:playBackgroundMusic( path, false );
        if errorcode == 0 then 
            print("调用播放音乐成功"..path)
            self:addTips("播放音乐");
        else
            print("调用退出所有频道失败，错误码:"..errorcode..",path:"..path)
            self:addTips("播放音乐失败");
        end   

        
    end)

    local btnStopMusic = ccui.Button:create("", "", "")
    btnStopMusic:setTitleFontSize(80);
    btnStopMusic:setPosition(700  ,  180);
    btnStopMusic:setAnchorPoint(0.5, 0 );
    btnStopMusic:setTitleText("停止音乐");
    btnStopMusic:setTitleColor( cc.c3b(255,255,255) );
    layer:addChild(btnStopMusic , 0 );

    btnStopMusic:addClickEventListener(  function (sender ) 
        
        local errorcode = cc.exports.youmetalk:stopBackgroundMusic( );
        if errorcode == 0 then 
            print("调用停止音乐成功")
        else
            print("调用停止音乐失败，错误码："..errorcode )
        end   

        self:addTips("停止音乐");
    end)

    local pSlider = cc.ControlSlider:create("res/sliderTrack.png","res/sliderProgress.png" ,"res/sliderThumb.png")
    pSlider:setAnchorPoint(cc.p(0.5, 1.0))
    pSlider:setMinimumValue(0.0) 
    pSlider:setMaximumValue(100) 
    pSlider:setPosition(cc.p(700, 100))

    local function valueChanged( sender )
       local vol = math.ceil( sender:getValue() )

        --[[/**
             *  功能描述: 设置背景音乐播放的音量
             *  @param vol 背景音乐的音量，范围 0-100
             *  @return YOUME_SUCCESS - 成功
             *          其他 - 具体错误码
             */
        ]]
        local errorcode = cc.exports.youmetalk:setBackgroundMusicVolume( vol );
        print("设置背景音乐音量:"..vol..",错误码："..errorcode);

        self:addTips("设置音乐音量" .. vol );
    end
    pSlider:registerControlEventHandler( valueChanged, cc.CONTROL_EVENTTYPE_VALUE_CHANGED );
    layer:addChild( pSlider, 0)

    local vol = 80;
    pSlider:setValue( 80 );

  
end

return HostScene
