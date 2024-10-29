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
        static let play = "play.png"
        static let stop = "stop.png"
        static let color = "color.png"
    }
    
    struct Colors {
        static let defaultDrawing = UIColor.black
        static let tint = UIColor(red: 168/255, green: 219/255, blue: 16/255, alpha: 1)
        static let lightTextColor = UIColor.white
    }
    
    struct Frame {
        struct Button {
            static let width: CGFloat = 32
            static let spacing: CGFloat = 8
        }
    }
}
