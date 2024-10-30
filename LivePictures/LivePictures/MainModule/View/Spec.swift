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
        static let paint = "paint.png"
        
        static let save = "square.and.arrow.down"
        static let download = "square.and.arrow.up"
    }
    
    struct Colors {
        static let background = UIColor(named: "backgroundColor")
        static let iconsColor = UIColor(named: "iconsColor") ?? .black
        static let tint = UIColor(named: "tintColor") ?? .black
        static let defaultDrawing = UIColor(named: "backgroundColor") ?? .black //UIColor.black
    }
    
    struct Frame {
        static let border: CGFloat = 16
        
        struct HeaderView {
            static let height: CGFloat = 44
        }
        
        struct TabBarView {
            static let height: CGFloat = 44
        }
        
        struct DrawindView {
            static let border: CGFloat  = 16
            static let top: CGFloat = 16
            static let bottom: CGFloat = 16
        }
        
        struct Button {
            static let width: CGFloat = 32
            static let spacing: CGFloat = 8
        }
    }
}
