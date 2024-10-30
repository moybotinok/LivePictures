//
//  ViewController.swift
//  LivePictures
//
//  Created by Tany on 28.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var headerView = {
        let headerView = HeaderView()
        self.view.addSubview(headerView)
        return headerView
    }()
    lazy var drawingView = {
        let drawingView = DrawingView()
        self.view.addSubview(drawingView)
        return drawingView
    }()
    lazy var tabBarView = {
        let tabBarView = TabBarView()
        self.view.addSubview(tabBarView)
        return tabBarView
    }()

    var shots: [DrawingShot] = [] {
        didSet {
//            headerView.setDelete(enable: !shots.isEmpty)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Spec.Colors.background
        drawingView.undoDelegate = self
//        drawingView.replaceShot(shot: nil, previousShot: nil)
        headerView.undoButtonClousure = { [weak self] in
            self?.drawingView.undoButtonPressed()
        }
        headerView.redoButtonClousure = { [weak self] in
            self?.drawingView.redoButtonPressed()
        }
        
        headerView.addButtonClousure = { [weak self] in
            guard let self = self else { return }
            self.shots.append(self.drawingView.saveShot())
        }
        
        headerView.deleteButtonClousure = { [weak self] in
            guard let self = self else { return }
            self.drawingView.replaceShot(shot: self.shots.popLast(), previousShot: self.shots.last)
        }
        
        headerView.playButtonClousure = { [weak self] playing in
            guard let self = self else { return }
            headerView.setInstruments(hidden: playing)
            tabBarView.setInstruments(hidden: playing)
            if playing {
                self.shots.append(self.drawingView.saveShot())
                drawingView.play(shots: self.shots)
            } else {
                drawingView.stop()
                self.drawingView.replaceShot(shot: self.shots.popLast(), previousShot: self.shots.last)
            }
        }
        
        tabBarView.penButtonClousure = { [weak self] in
            guard let self = self else { return }
            drawingView.settings.color = drawingView.selectedColor
        }
        tabBarView.eraseButtonClousure = { [weak self] in
            self?.drawingView.settings.color = .clear
        }
        tabBarView.colorChangedClousure = { [weak self] color in
            guard let self else { return }
            drawingView.settings.color = CIColor(color: (color ?? .clear))
            drawingView.selectedColor = CIColor(color: (color ?? .clear))
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let frame = view.frame
        headerView.frame = CGRect(
            x: VCSpec.HeaderView.borderOffset,
            y: Int(view.safeAreaLayoutGuide.layoutFrame.minY) + VCSpec.HeaderView.topOffset,
            width: Int(frame.width) - (VCSpec.HeaderView.borderOffset * 2),
            height: VCSpec.HeaderView.height
        )
        drawingView.frame = CGRect(
            x: VCSpec.DrawindView.borderOffset,
            y: Int(headerView.frame.maxY) + VCSpec.DrawindView.topOffset,
            width: Int(frame.width) - (VCSpec.DrawindView.borderOffset * 2),
            height: Int(frame.height)
            - Int(headerView.frame.maxY)
            - VCSpec.DrawindView.topOffset
            - VCSpec.DrawindView.topOffset
            - VCSpec.DrawindView.bottomOffset
            - VCSpec.TabBarView.height
        )
        
        tabBarView.frame = CGRect(
            x: VCSpec.TabBarView.borderOffset,
            y: Int(drawingView.frame.maxY) ,
            width: Int(frame.width) - VCSpec.TabBarView.borderOffset * 2,
            height: VCSpec.TabBarView.height
        )
    }
    
    struct VCSpec {
        struct HeaderView {
            static let topOffset = 0
            static let borderOffset = 0
            static let height = 44
        }
        struct DrawindView {
            static let borderOffset = 16
            static let topOffset = 16
            static let bottomOffset = 50
        }
        struct TabBarView {
            static let topOffset = 20
            static let borderOffset = 0
            static let height = 44
        }
    }
}

extension ViewController: UndoDelegate {
    func setUndo(enable: Bool) {
        headerView.setUndo(enable: enable)
    }
    func setRedo(enable: Bool) {
        headerView.setRedo(enable: enable)
    }
    func setDelete(enable: Bool) {
        headerView.setDelete(enable: enable)
    }
}
