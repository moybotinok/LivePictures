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
    
    let shotsStorage = ShotsStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Spec.Colors.background
        drawingView.undoDelegate = self
        
        setupHeaderView()
        setupTabBarView()
        setupConstraints()
    }
    
    func setupHeaderView() {
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
    }
    
    func setupTabBarView() {
        tabBarView.penButtonClousure = { [weak self] in
            guard let self = self else { return }
            drawingView.settings.color = drawingView.selectedColor
        }
        tabBarView.eraseButtonClousure = { [weak self] in
            self?.drawingView.settings.color = .clear
        }
//        tabBarView.paintButtonClousure = { [weak self] in
//
//        }
        tabBarView.colorChangedClousure = { [weak self] color in
            guard let self else { return }
            drawingView.settings.color = CIColor(color: (color ?? .clear))
            drawingView.selectedColor = CIColor(color: (color ?? .clear))
        }
        tabBarView.saveButtonClousure = { [weak self] in
            self?.saveButtonPressed()
        }
        tabBarView.downloadButtonClousure = { [weak self] in
            self?.downloadButtonPressed()
        }
    }

    func saveButtonPressed() {
        shotsStorage.save(shots: shots)
    }
    
    func downloadButtonPressed() {
        shots = shotsStorage.fetch()
        
        drawingView.updateSkatches(shots: shots)
        drawingView.replaceShot(shot: shots.popLast(), previousShot: shots.last)
    }
    
    func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Spec.Frame.HeaderView.height),
            
            drawingView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Spec.Frame.DrawindView.top),
            drawingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spec.Frame.DrawindView.border),
            drawingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spec.Frame.DrawindView.border),
            drawingView.bottomAnchor.constraint(equalTo: tabBarView.topAnchor, constant: -Spec.Frame.DrawindView.bottom),

            tabBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: Spec.Frame.TabBarView.height)
        ])
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
