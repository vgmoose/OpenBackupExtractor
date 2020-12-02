//
//  SelectableTypesView.swift
//  Open Backup Extractor
//
//  Created by vgm on 2/9/18.
//  Copyright © 2018 VGMoose. All rights reserved.
//

import Foundation
import Cocoa

class SelectableTypesView : NSView
{
    static let VOICE = 0, IMG = 1, TXT = 2, MUSIC = 3, VIDEO = 4, PDF = 5, DATA = 6, ARC = 7, OTHER = 8
    
    // mapping of file descriptions (from libmagic) to file extensions
    var fileMaps: [Int:([String], [String])] =
    [
        VOICE:  (["Multi-Rate"],                 ["amr"]),
        IMG:    (["PNG", "JPEG", "GIF", "TIF"],  ["png", "jpg", "gif", "tif"]),
        TXT:    (["ASCII", "Word", "UTF"],       ["txt", "docx", "txt"]),
        MUSIC:  (["MPEG", "M4A"],                ["mp3", "m4a"]),
        VIDEO:  (["MP4", "MOV"],                 ["mp4", "mov"]),
        PDF:    (["PDF"],                        ["pdf"]),
        DATA:   (["SQL"],                        ["sqlite"]),
        ARC:    (["Zip", "tar"],                 ["zip", "tar"]),
        OTHER:  (["HTML", "property", "XML"],    ["html", "plist", "xml"])
    ]
    
    // mapping of file types to enabled/disabled
    var enabledTypes:[Int: Bool] = [:]
    
    func enabled(_ type: Int) -> Bool
    {
        // return true/false whether we're supposed to check this type
        return enabledTypes[type] ?? false
    }
    
    func parse(_ type: String) -> String?
    {
        // for every key in the file maps
        for (key, value) in fileMaps
        {
            // if this checkbox is enabled
            if enabled(key)
            {
                // go through the file descriptions + extensions and check the type
                let descs = value.0
                let exts  = value.1
                for x in 0..<descs.count
                {
                    if type.contains(descs[x])
                    {
                        // found a matching file type in the description, return the respective extension
                        return exts[x]
                    }
                }
            }
        }
        
        // not a known filetype
        return nil
    }
    
    func setAllState(_ enabled: Bool)
    {
        // go through all subviews, and enable/disable them if needed
        for view in self.subviews
        {
            if view is NSButton
            {
                (view as! NSButton).isEnabled = enabled
            }
        }
    }
    
    func update()
    {
        // go through all checkboxes, and update our enabled dictionary appropriately
        for x in 0..<self.subviews.count        // subviews.count should match the number of static types (9)
        {
            if self.subviews[x] is NSButton
            {
                enabledTypes[x] = (self.subviews[x] as! NSButton).state.rawValue == 1
            }
        }
    }
}
