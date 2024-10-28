//
//  DrawingView.swift
//  LivePictures
//
//  Created by Tany on 28.10.2024.
//
import UIKit
import CoreGraphics


class DrawingView: UIView {
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    var drawingUndoManager = UndoManager()
    var stack: [DrawingUnit] = []
    
    private lazy var imageView = {
        let imageView = UIImageView(image: UIImage(named: "background.png"))
        self.addSubview(imageView)
        return imageView
    }()
    
    private lazy var templateImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        self.addSubview(imageView)
        return imageView
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
        layer.cornerRadius = 25.0
        clipsToBounds = true
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        templateImageView.frame = imageView.frame
    }

    // MARK: - Undo Redo
    func undoButtonPressed() {
        if drawingUndoManager.canUndo {
            let stackCount = stack.count

            if !drawingUndoManager.canRedo {
//                delegate?.redoEnabled?()
            }

            drawingUndoManager.undo()

            if !drawingUndoManager.canUndo {
//                delegate?.undoDisabled?()
            }

            updateClear(oldStackCount: stackCount)
        }
    }
    func redoButtonPressed() {
        
    }
    
    func updateClear(oldStackCount: Int) {
        if oldStackCount > 0 && stack.count == 0 {
//            delegate?.clearDisabled?()
        } else if oldStackCount == 0 && stack.count > 0 {
//            delegate?.clearEnabled?()
        }
    }

// MARK: - Touch Actions

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

      if !swiped {
        // draw a single point
          drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
      }
      
      // Merge tempImageView into mainImageView
      UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), blendMode: .normal, alpha: 1.0)
        templateImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), blendMode: .normal, alpha: opacity)
      imageView.image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
        templateImageView.image = nil
    }
    
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        UIGraphicsBeginImageContext(self.frame.size)
        let context = UIGraphicsGetCurrentContext()
        templateImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        context?.setLineCap(.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(.init(red: red, green: green, blue: blue, alpha: 1))
        context?.setBlendMode(.normal)
        
        context?.strokePath()
        
        templateImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        templateImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }

}
