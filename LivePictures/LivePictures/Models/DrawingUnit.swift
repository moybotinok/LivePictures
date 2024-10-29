//
//  DrawingUnit.swift
//  LivePictures
//
//  Created by Tany on 28.10.2024.
//
import Foundation
import UIKit
import CoreImage

@objc class DrawingUnit: NSObject {
    var points: [CGPoint] = []
    var settings = DrawingSettings()
    
    init(points: [CGPoint], settings: DrawingSettings = DrawingSettings()) {
        self.points = points
        self.settings = settings
    }
}

@objc class DrawingSettings: NSObject {
    var color: CIColor //= CIColor.black //clear
    var width: CGFloat// = 10
    
    init(color: CIColor = .black, width: CGFloat = 10) {
        self.color = color
        self.width = width
    }
}

class DrawingShot {
    var units: [DrawingUnit]
    var sketch: UIImage?
    
    init(units: [DrawingUnit], sketch: UIImage?) {
        self.units = units
        self.sketch = sketch
    }
}
