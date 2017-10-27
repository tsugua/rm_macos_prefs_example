
class PreferenceController < NSWindowController   
  extend IB
   
   
   def init
      p 'init in preference controller'

	    initWithWindowNibName('Preferences')
      
      self.setupDefaults

      defaults = NSUserDefaults.standardUserDefaults
      
      p "preferences init"
      p $width_prefs = defaults.stringForKey('Width_Prefs').to_i
      p $height_prefs = defaults.stringForKey('Height_Prefs').to_i
      p $window_x = defaults.stringForKey('Window_X').to_i
      p $window_y = defaults.stringForKey('Window_Y').to_i
      self
   end

   def self.sharedPreferenceController
     # @instance ||= alloc.init
   end
   
   def setupDefaults
      defaultsPlist = NSBundle.mainBundle.pathForResource "Defaults", ofType:"plist"
      defaultsDict = NSDictionary.dictionaryWithContentsOfFile defaultsPlist
      $defaults.registerDefaults defaultsDict
      NSUserDefaultsController.sharedUserDefaultsController.setInitialValues defaultsDict
   end
   
   def savePrefs(sender)
      NSUserDefaultsController.sharedUserDefaultsController.save(nil)
      NSUserDefaults.standardUserDefaults.synchronize()
      # window.orderOut self
      update_preferences()
   end
   
   def savePrefsAndCloseWindow(sender)
      NSUserDefaultsController.sharedUserDefaultsController.save(nil)
      NSUserDefaults.standardUserDefaults.synchronize()
      window.orderOut self
      update_preferences()
   end
   
   def showWindow(sender)
     if window == true
      p 'there is a window already'
     end
     window.setLevel(NSScreenSaverWindowLevel+2)
     window.orderFront self
   end

   def closeWindow(sender)
      window.orderOut(self)
   end

  def open_folder(sender)
  	p 'open folder'
  	panel = NSOpenPanel.openPanel 
  	panel.canChooseDirectories = true
  	panel.canChooseFiles = false 
  	panel.canCreateDirectories = false 
  	panel.allowsMultipleSelection = false
  	panel.beginSheetModalForWindow window, completionHandler: Proc.new{|result| 
  		return if (result == NSCancelButton)
  		p path = panel.filename
  		# use a GUID to avoid conflicts
  		# guid = NSProcessInfo.processInfo.globallyUniqueString
  		# set the destination path in the support folder
  		# dest_path = applicationFilesDirectory.URLByAppendingPathComponent(guid) dest_path = dest_path.relativePath
  		# error = Pointer.new(:id)
  		# NSFileManager.defaultManager.copyItemAtPath(path, toPath:dest_path, error:error) NSApplication.sharedApplication.presentError(error[0]) if error[0] 
  		# movie.setValue(dest_path, forKey:"imagePath")
  		$folder_prefs = path
  		$folder_path = $folder_prefs
		  NSUserDefaults.standardUserDefaults.setObject $folder_prefs, forKey:"Folder_Prefs"
  	} 
  end


#    This updates the preferences so the AppDelegate uses the most up to date information
   def update_preferences()
     p 'updating preferences'
     p $width_prefs = $defaults.stringForKey('Width_Prefs').to_i
     p $height_prefs = $defaults.stringForKey('Height_Prefs').to_i
     p $window_x = $defaults.stringForKey('Window_Y').to_i
     p $window_y = $defaults.stringForKey('Window_X').to_i
     App.notification_center.post("preference_update_notification")
     

   end
end


$prefs = PreferenceController.sharedPreferenceController