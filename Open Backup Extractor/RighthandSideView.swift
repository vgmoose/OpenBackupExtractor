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
	static let VOICE = 0, IMG = 1, TXT = 2, MUSIC = 3, VIDEO = 4, PDF = 5, DATA = 6, ARC = 7, OTHER = 8
	static var types = [ "Voicemails (.amr)", "Images (.png, .jpg, .gif)", "Text (.txt, .doc)", "Music (.mp3, .mpg)", "Videos (.mp4)", "PDF (.pdf)", "Databases (.sqlite3)", "Archives (.zip, .tar)", "Other (.html, .plist, .xml)"]

	@objc private func onItemClicked()
	{
		// hide the placeholder text
		Swift.print("clicked")
	}
	
	func setLabels(_ tableView: NSTableView)
	{
//		tableView.row
		
		tableView.action = #selector(onItemClicked)
	}
	
	func numberOfRows(in tableView: NSTableView) -> Int
	{
		return RighthandSideView.types.count
	}
}
