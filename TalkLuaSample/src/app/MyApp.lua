require( "app.views.Youme" )
local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
    math.randomseed(os.time())
end

local function  getTempDir(  )
	-- body
end

function MyApp:run(initSceneName)
    MyApp.super.run( self,initSceneName)

end

return MyApp
