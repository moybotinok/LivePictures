//
//  TabBarView.swift
//  LivePictures
//
//  Created by Tany on 28.10.2024.
//
import UIKit

class TabBarView: UIView {
    
    lazy var penButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Spec.Image.pen), for: .normal)
        button.setImage(UIImage(named: Spec.Image.pen)?.withTintColor(Spec.Colors.tint), for: .selected)
        button.addTarget(self, action: #selector(penButtonPressed), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    lazy var eraseButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Spec.Image.erase), for: .normal)
        button.setImage(UIImage(named: Spec.Image.erase)?.withTintColor(Spec.Colors.tint), for: .selected)
        button.addTarget(self, action: #selector(eraseButtonPressed), for: .touchUpInside)
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
        penButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        eraseButton.frame = CGRect(x: 30, y: 0, width: 20, height: 20)
    }
    
    @objc func penButtonPressed() {
        penButton.isSelected = !penButton.isSelected
        eraseButton.isSelected = false
        penButtonClousure?()
    }
    
    @objc func eraseButtonPressed() {
        eraseButton.isSelected = !eraseButton.isSelected
        penButton.isSelected = false
        eraseButtonClousure?()
    }
    
    var penButtonClousure: (()->())?
    var eraseButtonClousure: (()->())?
}
