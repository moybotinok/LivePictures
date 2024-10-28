//
//  TabBarView.swift
//  LivePictures
//
//  Created by Tany on 28.10.2024.
//
import UIKit

class TabBarView: UIView {
    
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
}
