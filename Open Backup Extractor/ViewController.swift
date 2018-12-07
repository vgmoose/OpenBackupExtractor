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
	
	// the dim text before a device is selected
	@IBOutlet weak var placeholderText: NSTextField!
    
    // the view containing the exportable types
    @IBOutlet weak var listContainer: NSView!
    
    // the progress of files being copied
    @IBOutlet weak var progressBar: NSProgressIndicator!
    
    var selectableView: SelectableTypesView?
    
    // the list of all devices
	var devices: [Device] = []
	
	// the path to the itunes library
	var ITUNES_BACKUP_PATH = NSHomeDirectory() + "/Library/Application Support/MobileSync/Backup/"
	
	// the number of cell that is being loaded
	var curentCellIndex = 0
	
	// the textbox that displays the selected export path
	@IBOutlet weak var exportFolderPathField: NSTextField!
	
	// the button to select the export path
	@IBOutlet weak var chooseFolderButton: NSButton!
	
	// exportable file types
	@IBOutlet weak var exportables: NSScrollView!
	
	// second placeholder text
	@IBOutlet weak var placeholder2: NSTextField!
	
	// the export folder button
	@IBOutlet weak var exportButton: NSButton!
	
	// the toggles
	@IBOutlet weak var container: NSView!
	
	// the variables for the state the UI should be in
	let NONE_SELECTED = 0, DEVICE_SELECTED = 1, PATH_SELECTED = 2, EXPORT_SELECTED = 3
    
    //the last selected row (corresponds to device)
    var lastSelectedRow = 0
	
	override func loadView()
	{
		super.loadView()
		
		// change directory to this app bundle (so that libmagic can find our magic.mgc file in resources)
		chdir(Bundle.main.bundlePath)
		
		// set this view controller to the app delegate
		let appDelegate = NSApplication.shared().delegate as! AppDelegate
		appDelegate.mainViewController = self

		// set the height of every cell in the table
		tableView.rowHeight = 70
		
		// refresh the device list on the first launch
		refreshDevices()
		
		self.tableView.action = #selector(onItemClicked)
	}
	
	@objc private func onItemClicked()
	{
        // if the progress bar is visible, don't change device state
        if !self.progressBar.isHidden { return }
        
        // if the selected item isn't in range, don't change device state
        if tableView.selectedRow < 0 || tableView.selectedRow >= self.devices.count { return }
        
        // update the last selected row
        self.lastSelectedRow = tableView.selectedRow
        
		// hide the placeholder text
		changeState(DEVICE_SELECTED)
	}

	@IBAction func getHelp(_ sender: Any) {
			dialog("Open Backup Extractor", "I made this tool out of frustration with existing solutions that all wanted to charge money to export files, specifically voicemails.\n\nThe idea is you perform a backup of the iOS device in iTunes, and then run this application or hit refresh. It should appear alongside the left hand side.\n\nWhen you choose it, you can then select the types of files that you want to extract from the backup. These are located in \"~/Library/Application Support/MobileSync/Backup/\".\n\nThis tool only copies the files of certain types from that folder into a destination folder that you specify.\n\nIt is limited in functionality, but it should get the job done! If you encounter any issue, please contact me or file an issue on Github (see the source code).")
	}
	
	@IBAction func refeshButton(_ sender: NSButton) {
		
        // if the progress bar is visible, don't refresh
        if !self.progressBar.isHidden { return }
        
		// clear the device list
		self.devices = []
		refreshDevices();
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
		
		// enter state 1 for view
		changeState(NONE_SELECTED)
	}
	
	func changeState(_ state: Int)
	{
		if state == NONE_SELECTED
		{
			self.placeholderText.isHidden = false
			self.exportFolderPathField.isHidden = true
			self.chooseFolderButton.isHidden = true
			self.container.isHidden = true
			self.exportButton.isHidden = true
			self.placeholder2.isHidden = true
            self.progressBar.isHidden = true
            
            self.exportFolderPathField.isEnabled = true
            self.chooseFolderButton.isEnabled = true
            self.progressBar.isHidden = true

		}
		else if state == DEVICE_SELECTED
		{
			self.placeholderText.isHidden = true
			self.exportFolderPathField.isHidden = false
			self.chooseFolderButton.isHidden = false
			self.container.isHidden = true
			self.exportButton.isHidden = true
			self.placeholder2.isHidden = false
            self.progressBar.isHidden = true
		}
		else if state == PATH_SELECTED
		{
			self.placeholderText.isHidden = true
			self.exportFolderPathField.isHidden = false
			self.chooseFolderButton.isHidden = false
			self.container.isHidden = false
			self.exportButton.isHidden = false
			self.placeholder2.isHidden = true
			
			self.exportFolderPathField.isEnabled = true
			self.chooseFolderButton.isEnabled = true
            self.progressBar.isHidden = true
//			self.exportables.isEnabled = true
		}
		else if state == EXPORT_SELECTED
		{
			self.placeholderText.isHidden = true
			self.exportFolderPathField.isHidden = false
			self.chooseFolderButton.isHidden = false
			self.container.isHidden = false
			self.exportButton.isHidden = true
			self.placeholder2.isHidden = true
			
			self.exportFolderPathField.isEnabled = false
			self.chooseFolderButton.isEnabled = false
            self.progressBar.isHidden = false
//			self.container.isEnabled = false

		}
	}
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?)
    {
        // the container view should call prepare for segue, and be a selectable types view
        self.selectableView = ((segue.destinationController as! NSViewController).view as! SelectableTypesView)
    }

	@IBAction func exportClicked(_ sender: Any)
	{
        // enter export state
        self.changeState(EXPORT_SELECTED)
        
        let exportPath = self.exportFolderPathField.stringValue
        
		// grab the currently selected device, and request it to export all its files
		let selectedDevice = self.devices[self.lastSelectedRow]
        
        if self.selectableView == nil { return }    // container hasn't initialized yet
        
        // update internal checkboxes for selected types before continuing
        self.selectableView!.update()
		
        DispatchQueue.global(qos: .utility).async
        {
            // disable all the checkboxes
            self.selectableView!.setAllState(false)
            
            do
            {
                // get an enumerator for the itunes backup path
                let files = try FileManager.default.contentsOfDirectory(atPath: selectedDevice.path)
                
                let totalFiles = files.count
                var curCount = 0
                
                // MAGIC_MIME tells magic to return a mime of the file
                let magic_cookie: magic_t = magic_open(MAGIC_NONE)
                
                print("Loading default magic database");
                if (magic_load(magic_cookie, nil) != 0) {
                    print("cannot load magic database - %s", magic_error(magic_cookie));
                    magic_close(magic_cookie);
                    return
                }
                
                // go through every folder in that folder (each is two characters)
                for folder in files
                {
                    // update the progress bar
                    DispatchQueue.main.async {
                        self.progressBar.doubleValue = Double(100) * (Double(curCount) / Double(totalFiles))
                    }
                    curCount += 1

                    // check if the current path is a folder
                    var isDir : ObjCBool = false
                    let subFolderPath = selectedDevice.path + "/" + folder
                    FileManager.default.fileExists(atPath: subFolderPath, isDirectory:&isDir)

                    if isDir.boolValue
                    {
                        let folderFiles = try FileManager.default.contentsOfDirectory(atPath: subFolderPath)
                        for file in folderFiles
                        {
                            let unsortedFilePath = subFolderPath + "/" + file

                            // lookup mime_type using magic.h library
                            if let magic_full = magic_file(magic_cookie, unsortedFilePath)
                            {
                                let type = String.init(cString: magic_full)

                                let ext = self.selectableView!.parse(type)
                                //lif the extension exists, copy the file into the destination folder
                                if ext != nil
                                {
                                    let targetPath = exportPath + "/" + file + "." + ext!

                                    if FileManager.default.fileExists(atPath: unsortedFilePath) {
                                        do {
                                            try FileManager.default.copyItem(atPath: unsortedFilePath, toPath: targetPath)

                                        } catch {
                                        }
                                    }
                                }
                            }

                        }
                    }
                }
                
                magic_close(magic_cookie)
                
                DispatchQueue.main.async
                {
                    // hide the progress bar (not part of state change, since progress bar's presence prevents state changing)
                    self.progressBar.isHidden = true
                    
                    self.selectableView!.setAllState(true)
                }
                
                // enter state 1 for view
                self.changeState(self.NONE_SELECTED)
                
                // reload the table view
                self.reloadData()
            }
            catch
            {
                // do nothing, the file list will be empty
                print("oh no")
            }
            
        }
	}
	
	@IBAction func chooseExportFolder(_ sender: NSButton)
	{
		let openPanel = NSOpenPanel()
		openPanel.allowsMultipleSelection = false
		openPanel.canChooseDirectories = true
		openPanel.canCreateDirectories = true
		openPanel.canChooseFiles = false
		openPanel.begin { (result) -> Void in
			if result == NSFileHandlingPanelOKButton {
				self.exportFolderPathField.stringValue = (openPanel.url?.path)!
				self.changeState(self.PATH_SELECTED)
			}
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

