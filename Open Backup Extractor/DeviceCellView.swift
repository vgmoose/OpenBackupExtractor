//
//  DeviceCellView.swift
//  Open Backup Extractor
//
//  Created by vgm on 8/26/17.
//  Copyright © 2017 VGMoose. All rights reserved.
//

import Cocoa

class DeviceCellView : NSTableCellView
{
	// iPhone properties
	@IBOutlet weak var nameField: NSTextField!
	@IBOutlet weak var modelField: NSTextField!
	@IBOutlet weak var dateField: NSTextField!
	@IBOutlet weak var serialField: NSTextField!
	@IBOutlet weak var icon: NSImageView!

	func loadFromDevice(_ device : Device)
	{
		super.awakeFromNib()
		// called after the text fields are initialized,
		// fill it with the property variables
		nameField.stringValue = device.name
		modelField.stringValue = device.model
		dateField.stringValue = device.date
		serialField.stringValue = device.serial //"CSU123456789"
		
		// update the ImageView based on the raw model
		let image = NSImage(named: device.rawModel)
		if image != nil
		{
			icon.image = image!
		}
	}

	override func awakeFromNib()
	{
		// find the parent view controller
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
		let parent = appDelegate.mainViewController!
		
		// find our current index
		let curIndex = parent.curentCellIndex
		
		// increment the index for the next cell
		parent.curentCellIndex += 1
		
		// load the properties for this device
		loadFromDevice(parent.devices[curIndex])
		
	}
}
