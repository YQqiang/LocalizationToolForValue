//
//  YQTableViewDelegate.swift
//  LocalizationToolForValue
//
//  Created by sungrow on 2018/2/8.
//  Copyright © 2018年 sungrow. All rights reserved.
//

import Cocoa

class YQTableViewDelegate: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    var fileModels: [YQFileModel]? {
        didSet {
            reloadTableView()
        }
    }
    
    var tableview: NSTableView?
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return fileModels?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as? YQTableCellView
        cell?.fileModel = fileModels?[row]
        return nil
    }
    
}

// MARK: - public action
extension YQTableViewDelegate {
    func reloadTableView() {
        tableview?.reloadData()
    }
}

// MARK: - NSTableViewDataSource
//extension YQTableViewDelegate: NSTableViewDataSource {
//
//
//}

// MARK: - NSTableViewDelegate
//extension YQTableViewDelegate: NSTableViewDelegate {
//
//}

