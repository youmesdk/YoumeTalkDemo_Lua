
cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"
require "app.views.YoumeTalk"

local function main()

    --初始化用户房间ID和固定房间ID
    cc.exports.userID = "u"..(os.time() % 1000)
    cc.exports.roomID = "123"
    print("initID:"..cc.exports.userID..","..cc.exports.roomID )

    local cLoginScene = require("app.views.LoginScene")

    local scene = cLoginScene.create()

    cc.Director:getInstance():runWithScene(scene)



    --YOUME
    --[[/**
     *  功能描述:初始化引擎
     *
     *  @param pEventCallback:回调类地址，需要继承IYouMeEventCallback并实现其中的回调函数
     *  @param strAPPKey:在申请SDK注册时得到的App Key，也可凭账号密码到http://gmx.dev.net/createApp.html查询
     *  @param strAPPSecret:在申请SDK注册时得到的App Secret，也可凭账号密码到http://gmx.dev.net/createApp.html查询
     *  @param serverRegionId: 服务器区域(YOUME_RTC_SERVER_REGION)
     *  @param pExtServerRegionName:
     *  @return 错误码，详见YouMeConstDefine.h定义
    */]]
    local errorcode = cc.exports.youmetalk:init("YOUMEBC2B3171A7A165DC10918A7B50A4B939F2A187D0",
    	"r1+ih9rvMEDD3jUoU+nj8C7VljQr7Tuk4TtcByIdyAqjdl5lhlESU0D+SoRZ30sopoaOBg9EsiIMdc8R16WpJPNwLYx2WDT5hI/HsLl1NJjQfa9ZPuz7c/xVb8GHJlMf/wtmuog3bHCpuninqsm3DRWiZZugBTEj2ryrhK7oZncBAAE=", 
        0, "cn")
    if errorcode ~= 0 then 
        print("初始化失败，错误码：" ..  errorcode)
    else
        print("初始化成功!\n")
    end

    local eventDispatcher=cc.Director:getInstance():getEventDispatcher()
    --进入后台
    local function onPause(event)
        print("暂停Talk")
        --YOUME
        --暂停
        cc.exports.youmetalk:pauseChannel();
    end

    local pauseListener = cc.EventListenerCustom:create("Pause", onPause)
    eventDispatcher:addEventListenerWithFixedPriority(pauseListener, 1)

    --进入前台
    local function onResume(event)
        print("恢复Talk")
        --YOUME
        --恢复
        cc.exports.youmetalk:resumeChannel();
    end

    local resumeListener = cc.EventListenerCustom:create("Resume", onResume)
    eventDispatcher:addEventListenerWithFixedPriority(resumeListener, 1)

end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
