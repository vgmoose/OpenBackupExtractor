//
//  ViewController.swift
//  Open Backup Extractor
//
//  Created by vgm on 8/26/17.
//  Copyright © 2017 VGMoose. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

	// the table view link from story board
	@IBOutlet weak var tableView: NSTableView!
	
	// the list of all devices
	var devices: [Device] = []
	
	// the path to the itunes library
	let ITUNES_BACKUP_PATH = "/Users/Ricky/Library/Application Support/MobileSync/Backup/"
	
	// the number of cell that is being loaded
	var curentCellIndex = 0
	
	override func loadView()
	{
		super.loadView()
		
		// set this view controller to the app delegate
		let appDelegate = NSApplication.shared().delegate as! AppDelegate
		appDelegate.mainViewController = self

		// set the height of every cell in the table
		tableView.rowHeight = 70
		
		// refresh the device list on the first launch
		refreshDevices()
	}

	func refreshDevices()
	{
		do
		{
			// get an enumerator for the itunes backup path
			let files = try FileManager.default.contentsOfDirectory(atPath: ITUNES_BACKUP_PATH)
			
			// go through every file in that folder
			for file in files
			{
				// check if the current path is a folder
				var isDir : ObjCBool = false
				FileManager.default.fileExists(atPath: ITUNES_BACKUP_PATH + file, isDirectory:&isDir)
				
				if isDir.boolValue
				{
					// if it's a folder, try to load it as a device cell
					let device = Device()
					
					if device.load(ITUNES_BACKUP_PATH + file)
					{
						// if it loaded, append it to the devices list
						devices.append(device)
					}
				}
			}
			
			// reload the table view
			reloadData()
		}
		catch
		{
			// do nothing, the file list will be empty
		}
		
	}
	
	func reloadData()
	{
		// reset the cell index counter
		self.curentCellIndex = 0
		
		// reload the actual table view
		tableView.reloadData()
	}
	
	func numberOfRows(in tableView: NSTableView) -> Int
	{
		return devices.count
	}

	@IBAction func openSourceCode(_ sender: NSButton)
	{
		// open up the source page for this project
		NSWorkspace.shared().open(URL(string: "https://github.com/vgmoose/openbackupextractor")!)
	}
	
	// display alert (from https://stackoverflow.com/a/29433631/1137828 )
	func dialog(_ question: String, _ text: String) {
		let alert = NSAlert()
		alert.messageText = question
		alert.informativeText = text
		alert.alertStyle = .warning
		alert.addButton(withTitle: "OK")
		alert.beginSheetModal(for: self.view.window!)
	}
	
}

