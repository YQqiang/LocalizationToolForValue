//
//  SplitManager.swift
//  LocalizationToolForValue
//
//  Created by sungrow on 2018/2/9.
//  Copyright © 2018年 sungrow. All rights reserved.
//

import Foundation

enum SplitFileType {
    case strings(separateStr: String)
    case xls
    case db
}

final class SplitManager {
    static let shared = SplitManager.init()
    private init(){}
    
    func split(_ fileModel: YQFileModel) -> [KeyValueModel] {
        if ["strings", "txt"].contains(fileModel.fileExtension) {
            return split(fileModel, splitFileType: .strings(separateStr: "\" = \""))
        }
        return [KeyValueModel]()
    }
}

extension SplitManager {
    
    private func split(_ fileModel: YQFileModel, splitFileType: SplitFileType) -> [KeyValueModel] {
        switch splitFileType {
        case .strings(separateStr: let separateStr):
            return splitStrings(fileModel, separateStr: separateStr)
        default:
            break
        }
        return [KeyValueModel]()
    }
    
    private func splitStrings(_ fileModel: YQFileModel, separateStr: String) -> [KeyValueModel] {
        let content = try? String.init(contentsOfFile: fileModel.filePath, encoding: String.Encoding.utf8)
        let arr = content?.components(separatedBy: "\n")
        var sourceKeyValueModels = [KeyValueModel]()
        arr?.forEach({ (str) in
            let keyValue = str.components(separatedBy: separateStr)
            if keyValue.count == 2 {
                sourceKeyValueModels.append(KeyValueModel(key: keyValue.first!, chValue: "", enValue: keyValue.last!, geValue: "", jpValue: ""))
            }
        })
        return sourceKeyValueModels
    }
}
