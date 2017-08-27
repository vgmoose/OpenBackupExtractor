//
//  ViewController.swift
//  Open Backup Extractor
//
//  Created by vgm on 8/26/17.
//  Copyright © 2017 VGMoose. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

	@IBOutlet weak var tableView: NSTableView!
	
	override func loadView()
	{
		super.loadView()
		
		tableView.rowHeight = 70
		tableView.addSubview(DeviceCellView())
	}
	
	func numberOfRows(in tableView: NSTableView) -> Int
	{
		return 20
	}

	@IBAction func openSourceCode(_ sender: NSButton)
	{
		// open up the source page for this project
		NSWorkspace.shared().open(URL(string: "https://github.com/vgmoose/openbackupextractor")!)
	}
}

