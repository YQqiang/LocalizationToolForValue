//
//  JointManager.swift
//  LocalizationToolForValue
//
//  Created by sungrow on 2018/2/9.
//  Copyright © 2018年 sungrow. All rights reserved.
//

import Foundation

final class JointManager {
    static let shared = JointManager.init()
    private init(){}
    
    func Joint(_ keyValueModels: [KeyValueModel]) {
        var content = ""
        keyValueModels.forEach { (keyValueModel) in
            content = content + "\"" + keyValueModel.key + "\" = \"" + keyValueModel.geValue + "\";" + "\n"
        }
        try? content.write(toFile: "/Users/dongl/Desktop/en.txt", atomically: true, encoding: String.Encoding.utf8)
    }
}
