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
    lazy var paintButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Spec.Image.paint)?.withTintColor(Spec.Colors.iconsColor), for: .normal)
        button.setImage(UIImage(named: Spec.Image.paint)?.withTintColor(Spec.Colors.tint), for: .selected)
        button.addTarget(self, action: #selector(paintButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var saveButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Spec.Image.save)?.withTintColor(Spec.Colors.iconsColor), for: .normal)
        button.setImage(UIImage(named: Spec.Image.save)?.withTintColor(Spec.Colors.tint), for: .selected)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var downloadButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Spec.Image.download)?.withTintColor(Spec.Colors.iconsColor), for: .normal)
        button.setImage(UIImage(named: Spec.Image.download)?.withTintColor(Spec.Colors.tint), for: .selected)
        button.addTarget(self, action: #selector(downloadButtonPressed), for: .touchUpInside)
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
        stackView.addArrangedSubview(paintButton)
        stackView.addArrangedSubview(colorWell)
        stackView.addArrangedSubview(saveButton)
        stackView.addArrangedSubview(downloadButton)
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
        paintButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        colorWell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spec.Frame.border),
            buttonsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            penButton.widthAnchor.constraint(equalTo: penButton.heightAnchor),
            eraseButton.widthAnchor.constraint(equalTo: eraseButton.heightAnchor),
            paintButton.widthAnchor.constraint(equalTo: paintButton.heightAnchor),
            saveButton.widthAnchor.constraint(equalTo: paintButton.heightAnchor),
            downloadButton.widthAnchor.constraint(equalTo: paintButton.heightAnchor),
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
    
    @objc func paintButtonPressed() {
        paintButtonClousure?()
    }
    
    @objc func saveButtonPressed() {
        saveButtonClousure?()
    }
    
    @objc func downloadButtonPressed() {
        downloadButtonClousure?()
    }
    
    @objc func colorChanged(sender: UIColorWell) {
        colorChangedClousure?(sender.selectedColor)
    }
    
    var penButtonClousure: (()->())?
    var eraseButtonClousure: (()->())?
    var paintButtonClousure: (()->())?
    var saveButtonClousure: (()->())?
    var downloadButtonClousure: (()->())?
    var colorChangedClousure: ((UIColor?)->())?
    
    func setInstruments(hidden: Bool) {
        buttonsStackView.isHidden = hidden
    }
}
