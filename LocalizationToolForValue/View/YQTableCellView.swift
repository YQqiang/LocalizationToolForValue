//
//  YQTableCellView.swift
//  LocalizationToolForValue
//
//  Created by sungrow on 2018/2/7.
//  Copyright © 2018年 sungrow. All rights reserved.
//

import Cocoa

class YQTableCellView: NSTableCellView {

    var fileModel: YQFileModel? {
        didSet {
            guard let model = fileModel else {
                return
            }
            fileType.image = model.isFolder ? NSImage.init(imageLiteralResourceName: "folder") : NSImage.init(imageLiteralResourceName: "file")
            fileName.stringValue = model.fileName
        }
    }
    
    @IBOutlet var fileType: NSImageView!
    @IBOutlet var fileName: NSTextField!
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}

// MARK: - private action
extension YQTableCellView {
    private func setup() {
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "YQTableCellView"), owner: self, topLevelObjects: nil)
    }
}
