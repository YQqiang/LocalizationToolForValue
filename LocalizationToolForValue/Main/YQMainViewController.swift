//
//  YQMainViewController
//  LocalizationToolForValue
//
//  Created by sungrow on 2018/2/8.
//  Copyright © 2018年 sungrow. All rights reserved.
//

import Cocoa

class YQMainViewController: NSViewController {

    @IBOutlet weak var sourceTableView: NSTableView!
    @IBOutlet weak var targetTableView: NSTableView!
    
    /// 局部常量
    private let settingViewHeight: CGFloat = 100
    
    /// 控件属性
    @IBOutlet weak var settingView: NSView!
    @IBOutlet weak var sourceDragDropView: YQDragDropView!
    @IBOutlet weak var targetDragDropView: YQDragDropView!
    @IBOutlet weak var bgGradientView: YQGradientView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var outFolderNameTF: NSTextField!
    @IBOutlet weak var outPathTF: NSTextField!
    @IBOutlet weak var selectPathBTN: NSButton!
    
    private lazy var sourceDataList: [YQFileModel] = [YQFileModel]()
    private lazy var targetDataList: [YQFileModel] = [YQFileModel]()
    
    fileprivate lazy var sourceDelegate: YQTableViewDelegate = {
        let delegate = YQTableViewDelegate()
        delegate.tableview = sourceTableView
        delegate.fileModels = sourceDataList
        return delegate
    }()
    
    fileprivate lazy var popOver: NSPopover = {
        let popView = NSPopover()
        popView.contentViewController = YQQuestionViewController()
        popView.behavior = .transient
        popView.appearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
        return popView
    }()
    
    private lazy var targetDelegate: YQTableViewDelegate = {
        let delegate = YQTableViewDelegate()
        delegate.tableview = targetTableView
        delegate.fileModels = targetDataList
        return delegate
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomConstraint.constant = 0
        
        sourceDragDropView.delegate = self
        targetDragDropView.delegate = self
        
        sourceTableView.delegate = sourceDelegate
        sourceTableView.dataSource = sourceDelegate
        
        targetTableView.delegate = targetDelegate
        targetTableView.dataSource = targetDelegate
        
        configOutpath()
        outFolderNameTF.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func startAction(_ sender: NSButton) {
        let sourceKeyValueModels = allKeyValueModels(sourceDataList)
        let targetKeyValueModels = allKeyValueModels(targetDataList)
        
        sourceKeyValueModels.forEach { (sourceKeyValueModel) in
            targetKeyValueModels.forEach({ (targetKeyValueModel) in
                if sourceKeyValueModel.key == targetKeyValueModel.key {
                    sourceKeyValueModel.chValue = targetKeyValueModel.chValue
                    sourceKeyValueModel.enValue = targetKeyValueModel.enValue
                    sourceKeyValueModel.geValue = targetKeyValueModel.geValue
                    sourceKeyValueModel.jpValue = targetKeyValueModel.jpValue
                }
            })
        }
        
        JointManager.shared.Joint(sourceKeyValueModels)
    }
    
    @IBAction func selectPathAction(_ sender: NSButton) {
        let path = openPanel(canChooseFile: false)
        JointManager.shared.homePath = path
        configOutpath()
    }
    
    @IBAction func questionAction(_ sender: NSButton) {
        popOver.show(relativeTo: sender.bounds, of: sender, preferredEdge: NSRectEdge.maxY)
    }
    
    @IBAction func openOutFolderAction(_ sender: NSButton) {
        NSWorkspace.shared.openFile(JointManager.shared.outPath)
    }
    
    @IBAction func restoreDefaultAction(_ sender: NSButton) {
        JointManager.shared.restoreDefaultPath()
        configOutpath()
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
    
    @IBAction func clearSourceDataList(_ sender: NSButton) {
        sourceDataList.removeAll()
        reloadSourceTableVC()
    }
    
    @IBAction func clearTargetDataList(_ sender: NSButton) {
        targetDataList.removeAll()
        reloadTargetTableVC()
    }
    
}

// MARK: - private Action
extension YQMainViewController {
    
    private func allKeyValueModels(_ fileModels: [YQFileModel]) -> [KeyValueModel] {
        var keyValueModels = [KeyValueModel]()
        fileModels.forEach { (fileModel) in
            fileModel.enumeratorFile({ (filePath) in
                let models = SplitManager.shared.split(YQFileModel(filePath: filePath))
                keyValueModels = keyValueModels + models
            })
        }
        return keyValueModels
    }
    
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
    
    private func configOutpath() {
        outFolderNameTF.stringValue = JointManager.shared.outFolderName
        outPathTF.placeholderString = JointManager.shared.outPath
    }
    
    /// 从Finder中选择文件/文件夹
    ///
    /// - Parameter canChooseFile: 是否是文件
    /// - Returns: 文件/文件夹路径
    fileprivate func openPanel(canChooseFile: Bool) -> String {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = !canChooseFile
        openPanel.canChooseFiles = canChooseFile
        openPanel.canCreateDirectories = true
        openPanel.title = "选择输出路径"
        openPanel.message = "转换后的资源文件将会保存到该目录下"
        if openPanel.runModal() == .OK {
            let path = openPanel.urls.first?.absoluteString.components(separatedBy: ":").last?.removingPercentEncoding as NSString?
            return path?.expandingTildeInPath ?? ""
        }
        return ""
    }
}

// MARK: - YQDragDropViewDelegate
extension YQMainViewController: YQDragDropViewDelegate {
    func draggingFileAccept(_ dragDropView: YQDragDropView, files: [String]) {
        if dragDropView == sourceDragDropView {
            sourceDataList.removeAll()
            files.forEach { (pathStr) in
                let fileModel = YQFileModel(filePath: pathStr)
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
                let fileModel = YQFileModel(filePath: pathStr)
                targetDataList.append(fileModel)
            }
            reloadTargetTableVC()
        }
    }
}

extension YQMainViewController: NSTextFieldDelegate {
    override func controlTextDidChange(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            JointManager.shared.outFolderName = textField.stringValue
            configOutpath()
        }
    }
}
