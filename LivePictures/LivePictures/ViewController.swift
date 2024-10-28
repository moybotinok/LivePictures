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
        
//        tabBarView.frame = CGRect(
//            x: 0,
//            y: Int(drawingView.frame.maxY) ,
//            width: Int(frame.width),
//            height: 100
//        )
    }
}

struct Spec {
    struct HeaderView {
        static var topOffset = 0
        static var borderOffset = 0
        static var height = 50
    }
    struct DrawindView {
        static var borderOffset = 20
        static var topOffset = 20
    }
}
