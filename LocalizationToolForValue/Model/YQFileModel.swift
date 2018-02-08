//
//  YQFileModel.swift
//  LocalizationToolForValue
//
//  Created by sungrow on 2018/2/7.
//  Copyright © 2018年 sungrow. All rights reserved.
//

import Cocoa

class YQFileModel: NSObject {
    var filePath: String = ""
    
    /// 是否是文件夹
    var isFolder: Bool {
        var folder: ObjCBool = false
        FileManager.default.fileExists(atPath: filePath, isDirectory: &folder)
        return folder.boolValue
    }
    
    /// 文件名称
    var fileName: String {
        return (filePath as NSString?)?.lastPathComponent ?? ""
    }
    
    /// 不带扩展名的文件名称
    var fileNameWithoutExtension: String {
        return (fileName as NSString?)?.deletingPathExtension ?? ""
    }
    
    /// 文件扩展名
    var fileExtension: String {
        return (filePath as NSString?)?.pathExtension ?? ""
    }
}
