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
    static var types = [ "Voicemails (.amr)", "Images (.png, .jpg, .gif, .tif)", "Text (.txt, .doc)", "Music (.mp3, .m4a)", "Videos (.mp4)", "PDF (.pdf)", "Databases (.sqlite3)", "Archives (.zip, .tar)", "Other (.html, .plist, .xml)"]
    
    // voicemail files
    static var voicemailFile = "Multi-Rate"
    static var voicemailExt = "amr"
    
    // image files
    static var pngFile = "PNG", jpgFile = "JPEG", gifFile = "GIF", tifFile = "TIF"
    static var pngExt = "png", jpgExt = "jpg", gifExt = "gif", tifExt = "tif"
    
    // text files
    static var asciiFile = "ASCII", wordFile = "Word", utfFile = "UTF"
    static var asciiExt = "txt", wordExt = "docx", utfExt = "txt"
    
    // music files
    static var mp3File = "MPEG", m4aFile = "M4A"
    static var mp3Ext = "mp3", m4aExt = "m4a"
    
    // video files
    static var mp4File = "MP4", movFile = "MOV"
    static var mp4Ext = "mp4", movExt = "mov"
    
    // pdf files
    static var pdfFile = "PDF"
    static var pdfExt = "pdf"
    
    // database files
    static var sqlFile = "SQL"
    static var sqlExt = "sqlite"
    
    // archive files
    static var zipFile = "Zip", tarFile = "tar"
    static var zipExt = "zip", tarExt = "tar"
    
    // other files
    static var htmlFile = "HTML", plistFile = "property", xmlFile = "XML"
    static var htmlExt = "html", plistExt = "plist", xmlExt = "xml"
    
    @objc private func onItemClicked()
    {

    }
    
    static func parse(_ type: String) -> String?
    {
        // voicemail check
        if type.contains(voicemailFile) { return voicemailExt }
        
        // music
        if type.contains(m4aFile) { return m4aExt }
        if type.contains(mp3File) { return mp3Ext }
        
        // images
        if type.contains(pngFile) { return pngExt }
        if type.contains(gifFile) { return gifExt }
        if type.contains(jpgFile) { return jpgExt }
        if type.contains(tifFile) { return tifExt }
        
        // video
        if type.contains(mp4File) { return mp4Ext }
        if type.contains(movFile) { return movExt }
        
        // other
        if type.contains(htmlFile) { return htmlExt }
        if type.contains(plistFile) { return plistExt }
        if type.contains(xmlFile) { return xmlExt }
        
        // archive
        if type.contains(zipFile) { return zipExt }
        if type.contains(tarFile) { return tarExt }
        
        // db
        if type.contains(sqlFile) { return sqlExt }
        
        // pdf
        if type.contains(pdfFile) { return pdfExt }
        
        // text
        if type.contains(asciiFile) { return asciiExt }
        if type.contains(wordFile) { return wordExt }
        if type.contains(utfFile) { return utfExt }

        // not a known filetype
        return nil
    }
}
