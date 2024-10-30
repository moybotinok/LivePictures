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
        button.setImage(UIImage(named: Spec.Image.pen)?.withTintColor(Spec.Colors.iconsColor), for: .normal)
        button.setImage(UIImage(named: Spec.Image.pen)?.withTintColor(Spec.Colors.tint), for: .selected)
        button.addTarget(self, action: #selector(penButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var eraseButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Spec.Image.erase)?.withTintColor(Spec.Colors.iconsColor), for: .normal)
        button.setImage(UIImage(named: Spec.Image.erase)?.withTintColor(Spec.Colors.tint), for: .selected)
        button.addTarget(self, action: #selector(eraseButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var colorWell = {
        let colorWell = UIColorWell()
        colorWell.supportsAlpha = false
        colorWell.selectedColor = Spec.Colors.defaultDrawing
        colorWell.addTarget(self, action: #selector(colorChanged), for: .valueChanged)
        return colorWell
    }()
    
    lazy var buttonsStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Spec.Frame.Button.spacing
        stackView.addArrangedSubview(penButton)
        stackView.addArrangedSubview(eraseButton)
        stackView.addArrangedSubview(colorWell)
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
        penButton.isSelected = true
    }
    
    func setupConstraints() {
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        penButton.translatesAutoresizingMaskIntoConstraints = false
        eraseButton.translatesAutoresizingMaskIntoConstraints = false
        colorWell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            penButton.widthAnchor.constraint(equalTo: penButton.heightAnchor),
            eraseButton.widthAnchor.constraint(equalTo: eraseButton.heightAnchor),
            colorWell.widthAnchor.constraint(equalTo: colorWell.heightAnchor)
        ])
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
    
    @objc func colorChanged(sender: UIColorWell) {
        colorChangedClousure?(sender.selectedColor)
    }
    
    var penButtonClousure: (()->())?
    var eraseButtonClousure: (()->())?
    var colorChangedClousure: ((UIColor?)->())?
    
    func setInstruments(hidden: Bool) {
        buttonsStackView.isHidden = hidden
    }
}
