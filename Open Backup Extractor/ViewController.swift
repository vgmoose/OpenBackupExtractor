//
//  ViewController.swift
//  Open Backup Extractor
//
//  Created by vgm on 8/26/17.
//  Copyright © 2017 VGMoose. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


	@IBAction func openSourceCode(_ sender: NSButton)
	{
		NSWorkspace.shared().open(URL(string: "https://github.com/vgmoose/openbackupextractor")!)
	}
}

