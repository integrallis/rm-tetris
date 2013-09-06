class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    application.applicationSupportsShakeToEdit = true  
    
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    
    @tetris_controller = TetrisController.alloc.initWithNibName(nil, bundle:nil)

    @window.rootViewController = @tetris_controller
    #UINavigationController.alloc.initWithRootViewController(@tetris_controller)

    @window.makeKeyAndVisible
    true
  end
end
