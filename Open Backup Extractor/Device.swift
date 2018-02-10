//
//  Device.swift
//  Open Backup Extractor
//
//  Created by vgm on 8/27/17.
//  Copyright © 2017 VGMoose. All rights reserved.
//

import Foundation

class Device
{
	var name = "My iPhone"
	var model = "iPhone 6 (iOS 10.1)"
	var date = "Jul 14, 2017 6:40 PM"
	var serial = "US123456789"
	var rawModel = "iPhone7,1"
    var path = "/"
	
	func load(_ path: String) -> Bool
	{
		// the Manifest.plist path
		let manifestPath = path + "/Manifest.plist"
        
        self.path = path
		
		if !FileManager.default.fileExists(atPath: manifestPath)
		{
			// the manifest doesn't exist, return false
			return false
		}
		
		// get the contents of the file
		let contents = FileManager.default.contents(atPath: manifestPath)
		let dict = NSDictionary(contentsOfFile: manifestPath)
		
		// get and format the date from the dict
		let realDate = dict!.value(forKey: "Date")! as! NSDate
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM dd, yyyy HH:mm a"
		date = formatter.string(from: realDate as Date)
		
		let info = dict?.value(forKey: "Lockdown")! as! NSDictionary
		name = info.value(forKey: "DeviceName")! as! String
		rawModel = info.value(forKey: "ProductType")! as! String
		serial = info.value(forKey: "SerialNumber")! as! String
		model = rawModel + " (iOS " + (info.value(forKey: "ProductVersion")! as! String) + ")"
		
		return true
	}
}
