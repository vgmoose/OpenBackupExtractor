//
//  AppDelegate.swift
//  Open Backup Extractor
//
//  Created by vgm on 8/26/17.
//  Copyright © 2017 VGMoose. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var mainViewController: ViewController?

	func applicationDidFinishLaunching(_ aNotification: Notification)
	{
	}
	
	@IBAction func openHelp(_ sender: NSMenuItem)
	{
        self.mainViewController!.getHelp(sender)
	}
	
	func dialogOKCancel(question: String, text: String) -> Bool {
		let alert = NSAlert()
		alert.messageText = question
		alert.informativeText = text
        alert.alertStyle = NSAlert.Style.warning
		alert.addButton(withTitle: "OK")
		alert.addButton(withTitle: "Cancel")
        return alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
	}
	
	@IBAction func promptDirectory(_ sender: Any)
	{
		let vc = mainViewController!
		
		let openPanel = NSOpenPanel()
		openPanel.allowsMultipleSelection = false
		openPanel.canChooseDirectories = true
		openPanel.canCreateDirectories = true
		openPanel.canChooseFiles = false
		openPanel.begin { (result) -> Void in
            if result.rawValue == NSFileHandlingPanelOKButton {
				vc.ITUNES_BACKUP_PATH = "\((openPanel.url?.path)!)/"
				vc.refreshDevices()
			}
		}
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

