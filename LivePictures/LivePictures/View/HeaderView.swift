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
        button.setImage(UIImage(named: Spec.Image.undo)?.withTintColor(Spec.Colors.iconsColor), for: .normal)
        button.addTarget(self, action: #selector(undoButtonPressed), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    lazy var redoButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Spec.Image.redo)?.withTintColor(Spec.Colors.iconsColor), for: .normal)
        button.addTarget(self, action: #selector(redoButtonPressed), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    lazy var deleteButton = {
        let button = UIButton()
//        button.isEnabled = false
        button.setImage(UIImage(named: Spec.Image.bin)?.withTintColor(Spec.Colors.iconsColor), for: .normal)
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var addButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Spec.Image.plus)?.withTintColor(Spec.Colors.iconsColor), for: .normal)
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var playButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Spec.Image.play)?.withTintColor(Spec.Colors.iconsColor), for: .normal)
        button.setImage(UIImage(named: Spec.Image.play)?.withTintColor(Spec.Colors.tint), for: .highlighted)
        button.setImage(UIImage(named: Spec.Image.stop)?.withTintColor(Spec.Colors.tint), for: .selected)
        button.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    lazy var buttonsStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Spec.Frame.Button.spacing
        stackView.addArrangedSubview(deleteButton)
        stackView.addArrangedSubview(addButton)
        addSubview(stackView)
        return stackView
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
        backgroundColor = Spec.Colors.background
        setupConstraints()
    }
    
    func setupConstraints() {
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = 32
        let height = 32
        let topOffset = 6
        let borderOffset = 16
        let buttonOffset = 8
        
        undoButton.frame = CGRect(
            x: borderOffset,
            y: topOffset,
            width: width,
            height: height
        )
        redoButton.frame = CGRect(
            x: borderOffset + width + buttonOffset,
            y: topOffset,
            width: width,
            height: height
        )
        
//        buttonsStackView
        //        deleteButton.frame = CGRect(
//            x: (Int(bounds.width) - buttonOffset - width) / 2,
//            y: topOffset,
//            width: width,
//            height: height
//        )
//        addButton.frame = CGRect(
//            x: (Int(bounds.width) - buttonOffset) / 2,
//            y: topOffset,
//            width: width,
//            height: height
//        )
        
        playButton.frame = CGRect(
            x: Int(bounds.width) - width - borderOffset,
            y: topOffset,
            width: width,
            height: height
        )
    }
    
    @objc func undoButtonPressed() {
        undoButtonClousure?()
    }
    
    @objc func redoButtonPressed() {
        redoButtonClousure?()
    }
    
    @objc func deleteButtonPressed() {
        deleteButtonClousure?()
    }
    
    @objc func addButtonPressed() {
        addButtonClousure?()
    }
    @objc func playButtonPressed() {
        playButton.isSelected = !playButton.isSelected
        playButtonClousure?(playButton.isSelected)
    }
    
    func setInstruments(hidden: Bool) {
        redoButton.isHidden = hidden
        undoButton.isHidden = hidden
        addButton.isHidden = hidden
        deleteButton.isHidden = hidden
    }
    
    var undoButtonClousure: (()->())?
    var redoButtonClousure: (()->())?
    var deleteButtonClousure: (()->())?
    var addButtonClousure: (()->())?
    var playButtonClousure: ((Bool)->())?
    
    func setUndo(enable: Bool) {
        undoButton.isEnabled = enable
    }
    func setRedo(enable: Bool) {
        redoButton.isEnabled = enable
    }
    func setDelete(enable: Bool) {
        deleteButton.isEnabled = enable
    }
}
