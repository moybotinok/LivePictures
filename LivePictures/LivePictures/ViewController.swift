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
//        let drawingView = TouchDrawView() 
        self.view.addSubview(drawingView)
        return drawingView
    }()
    lazy var tabBarView = {
        let tabBarView = TabBarView()
        self.view.addSubview(tabBarView)
        return tabBarView
    }()

    var shots: [DrawingShot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.undoButtonClousure = { [weak self] in
            self?.drawingView.undoButtonPressed()
//            self?.drawingView.undo()
        }
        headerView.redoButtonClousure = { [weak self] in
            self?.drawingView.redoButtonPressed()
//            self?.drawingView.redo()
        }
        
        headerView.addButtonClousure = { [weak self] in
            guard let self = self else { return }
            self.shots.append(self.drawingView.saveShot())
        }
        
        headerView.deleteButtonClousure = { [weak self] in
            guard let self = self else { return }
            self.drawingView.replaceShot(shot: self.shots.popLast(), previousShot: self.shots.last)
        }
        
        tabBarView.penButtonClousure = { [weak self] in
            self?.drawingView.settings.color = .black
        }
        tabBarView.eraseButtonClousure = { [weak self] in
            self?.drawingView.settings.color = .clear
        }
    }


    
    let drawingViewTopOffset = 50
    let drawingViewBottomOffset = 50
    let tabBarHeight = 50
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let frame = view.frame
        headerView.frame = CGRect(
            x: Spec.HeaderView.borderOffset,
            y: Int(view.safeAreaLayoutGuide.layoutFrame.minY) + Spec.HeaderView.topOffset,
            width: Int(frame.width) - (Spec.HeaderView.borderOffset * 2),
            height: Spec.HeaderView.height
        )
        drawingView.frame = CGRect(
            x: Spec.DrawindView.borderOffset,
            y: Int(headerView.frame.maxY) + Spec.DrawindView.topOffset,
            width: Int(frame.width) - (Spec.DrawindView.borderOffset * 2),
            height: Int(frame.height)
            - Int(headerView.frame.maxY)
            - Spec.DrawindView.topOffset
            - Spec.DrawindView.topOffset
            - drawingViewBottomOffset
            - tabBarHeight
        )
        
        tabBarView.frame = CGRect(
            x: Spec.TabBarView.borderOffset,
            y: Int(drawingView.frame.maxY) ,
            width: Int(frame.width) - Spec.TabBarView.borderOffset * 2,
            height: 50
        )
    }
}

