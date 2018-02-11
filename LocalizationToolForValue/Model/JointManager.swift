//
//  JointManager.swift
//  LocalizationToolForValue
//
//  Created by sungrow on 2018/2/9.
//  Copyright © 2018年 sungrow. All rights reserved.
//

import Foundation

enum LanguageType: String {
    case ch = "chValue"
    case en = "enValue"
    case ge = "geValue"
    case jp = "jpValue"
}

final class JointManager {
    static let shared = JointManager.init()
    private init(){}
    
    lazy var homePath: String = NSHomeDirectory() + "/Desktop"
    
    lazy var outFolderName: String = "LocalizationToolForValue"
    
    private lazy var outPath: String = {
        let path = homePath + "/" + outFolderName
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: path) {
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }()
    
    func Joint(_ keyValueModels: [KeyValueModel]) {
        var chContent = ""
        var enContent = ""
        var geContent = ""
        var jpContent = ""
        keyValueModels.forEach { (keyValueModel) in
            chContent = chContent + "\"" + keyValueModel.key + "\" = \"" + keyValueModel.chValue + "\";" + "\n"
            enContent = enContent + "\"" + keyValueModel.key + "\" = \"" + keyValueModel.enValue + "\";" + "\n"
            geContent = geContent + "\"" + keyValueModel.key + "\" = \"" + keyValueModel.geValue + "\";" + "\n"
            jpContent = jpContent + "\"" + keyValueModel.key + "\" = \"" + keyValueModel.jpValue + "\";" + "\n"
        }
        
        try? chContent.write(toFile: "\(outPath)/ch.Strings", atomically: true, encoding: String.Encoding.utf8)
        try? enContent.write(toFile: "\(outPath)/en.Strings", atomically: true, encoding: String.Encoding.utf8)
        try? geContent.write(toFile: "\(outPath)/ge.Strings", atomically: true, encoding: String.Encoding.utf8)
        try? jpContent.write(toFile: "\(outPath)/jp.Strings", atomically: true, encoding: String.Encoding.utf8)
    }
}
