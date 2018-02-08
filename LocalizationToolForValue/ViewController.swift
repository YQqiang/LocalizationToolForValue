//
//  ViewController.swift
//  LocalizationToolForValue
//
//  Created by sungrow on 2018/2/6.
//  Copyright © 2018年 sungrow. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    /// 局部常量
    private let settingViewHeight: CGFloat = 100
    
    /// 控件属性
    @IBOutlet weak var settingView: NSView!
    @IBOutlet weak var sourceDragDropView: YQDragDropView!
    @IBOutlet weak var targetDragDropView: YQDragDropView!
    @IBOutlet weak var bgGradientView: YQGradientView!
    
    @IBOutlet weak var sourceTableView: NSTableView!
    @IBOutlet weak var targetTableView: NSTableView!
    
    fileprivate lazy var sourceDelegate: YQTableViewDelegate = {
        let delegate = YQTableViewDelegate()
        delegate.tableview = sourceTableView
        delegate.fileModels = sourceDataList
        return delegate
    }()
    
    private lazy var targetDelegate: YQTableViewDelegate = {
        let delegate = YQTableViewDelegate()
        delegate.tableview = targetTableView
        delegate.fileModels = targetDataList
        return delegate
    }()
    
    
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private lazy var sourceDataList: [YQFileModel] = [YQFileModel]()
    private lazy var targetDataList: [YQFileModel] = [YQFileModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomConstraint.constant = 0
        
        sourceDragDropView.delegate = self
        targetDragDropView.delegate = self
        
        sourceTableView.delegate = sourceDelegate
        sourceTableView.dataSource = sourceDelegate
        
        targetTableView.delegate = targetDelegate
        targetTableView.dataSource = targetDelegate
        
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func startAction(_ sender: NSButton) {
    }
    
    @IBAction func settingAction(_ sender: NSButton) {
        if bottomConstraint.constant > 0 {
            bottomConstraint.constant = 0
        } else {
            bottomConstraint.constant = settingViewHeight
        }
        NSAnimationContext.runAnimationGroup({ (context) in
            context.allowsImplicitAnimation = true
            context.duration = 0.25
        }, completionHandler: nil)
    }
}

// MARK: - private Action
extension ViewController {
    private func reloadSourceTableVC() {
        sourceDragDropView.isHidden = sourceDataList.count > 0
        sourceTableView.isHidden = !sourceDragDropView.isHidden
        sourceDelegate.fileModels = sourceDataList
    }
    
    private func reloadTargetTableVC() {
        targetDragDropView.isHidden = targetDataList.count > 0
        targetTableView.isHidden = !targetDragDropView.isHidden
        targetDelegate.fileModels = targetDataList
    }
}

// MARK: - YQDragDropViewDelegate
extension ViewController: YQDragDropViewDelegate {
    func draggingFileAccept(_ dragDropView: YQDragDropView, files: [String]) {
        if dragDropView == sourceDragDropView {
            sourceDataList.removeAll()
            files.forEach { (pathStr) in
                let fileModel = YQFileModel()
                fileModel.filePath = pathStr
                sourceDataList.append(fileModel)
                
                print("------------ 分割线 ---------")
                print("------ isFolder = \(fileModel.isFolder)")
                print("------ fileName = \(fileModel.fileName)")
                print("------ fileNameWithoutExtension = \(fileModel.fileNameWithoutExtension)")
                print("------ fileExtension = \(fileModel.fileExtension)")
                print("------------ 结束 ---------\n")
            }
            reloadSourceTableVC()
        } else {
            targetDataList.removeAll()
            files.forEach { (pathStr) in
                let fileModel = YQFileModel()
                fileModel.filePath = pathStr
                targetDataList.append(fileModel)
            }
            reloadTargetTableVC()
        }
    }
}
