//
//  FiletypeTableView.swift
//  Open Backup Extractor
//
//  Created by vgm on 8/29/17.
//  Copyright © 2017 VGMoose. All rights reserved.
//

import Foundation
import Cocoa

class RighthandSideView : NSView, NSTableViewDelegate, NSTableViewDataSource
{
	func numberOfRows(in tableView: NSTableView) -> Int
	{
		return 10
	}
}
