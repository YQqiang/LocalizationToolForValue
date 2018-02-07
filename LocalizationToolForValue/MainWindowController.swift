//
//  MainWindowController.swift
//  LocalizationToolForValue
//
//  Created by sungrow on 2018/2/6.
//  Copyright © 2018年 sungrow. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.titlebarAppearsTransparent = true
        window?.standardWindowButton(.zoomButton)?.isHidden = true
        window?.titleVisibility = .hidden
    }

}
