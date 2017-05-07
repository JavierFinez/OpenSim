//
//  CopyToPasteboard.swift
//  OpenSim
//
//  Created by Luo Sheng on 07/05/2017.
//  Copyright © 2017 Luo Sheng. All rights reserved.
//

import Cocoa

final class CopyToPasteboardAction: ApplicationActionable {
    
    let title: String = NSLocalizedString("Copy Sandbox Path to Pasteboard", comment: "")
    
    let icon: NSImage = templatize(#imageLiteral(resourceName: "share"))
    
    let isAvailable: Bool = true
    
    func perform(with application: Application) {
        if let url = application.sandboxUrl {
            NSPasteboard.general().setString(url.path, forType: NSPasteboardTypeString)
        }
    }
    
}