//
//  Spec.swift
//  LivePictures
//
//  Created by Tany on 29.10.2024.
//
import UIKit

struct Spec {
    
    struct Image {
        static let background = "background.png"
        static let undo = "undo.png"
        static let redo = "redo.png"
        static let pen = "pen.png"
        static let erase = "erase.png"
        static let bin = "bin.png"
        static let plus = "plus.png"
    }
    
    struct Colors {
        static let tint = UIColor(red: 168/255, green: 219/255, blue: 16/255, alpha: 1)
    }
 
    struct HeaderView {
        static let topOffset = 0
        static let borderOffset = 0
        static let height = 50
    }
    struct DrawindView {
        static let borderOffset = 20
        static let topOffset = 20
    }
    struct TabBarView {
        static let topOffset = 20
        static let borderOffset = 20
    }
}
