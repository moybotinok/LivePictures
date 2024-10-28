//
//  HeaderView.swift
//  LivePictures
//
//  Created by Tany on 28.10.2024.
//

import UIKit

class HeaderView: UIView {
    
    lazy var undoButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "undo.png"), for: .normal)
        button.addTarget(self, action: #selector(undoButtonPressed), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    lazy var redoButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "redo.png"), for: .normal)
        button.addTarget(self, action: #selector(redoButtonPressed), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        
        backgroundColor = .black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        undoButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        redoButton.frame = CGRect(x: 30, y: 0, width: 20, height: 20)
    }
    
    @objc func undoButtonPressed() {
        undoButtonClousure?()
    }
    
    @objc func redoButtonPressed() {
        redoButtonClousure?()
    }
    
    var undoButtonClousure: (()->())?
    var redoButtonClousure: (()->())?
}
