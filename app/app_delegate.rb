$defaults = NSUserDefaults.standardUserDefaults

class AppDelegate
  attr_accessor :preferenceWindow
  
  def applicationDidFinishLaunching(notification)
		@frame  = [[$window_x.to_i, $window_y.to_i], [$width_prefs.to_i, $height_prefs.to_i]]
    p @frame
    buildMenu
    buildPrefsWindow
	end

  def open_prefs_window(sender)
    @prefsWindowController.window.makeKeyAndOrderFront(self)
  end

  def buildPrefsWindow
    @prefsWindowController = PreferenceController.alloc.init
  end
  
  def buildMaskWindow
    @maskWindowcontroller = MaskWindowController.alloc.init
    @maskWindowcontroller.show_window
  end
	
end

