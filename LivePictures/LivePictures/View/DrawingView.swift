//
//  DrawingView.swift
//  LivePictures
//
//  Created by Tany on 28.10.2024.
//
import UIKit
import CoreGraphics


class DrawingView: UIView {
    
    var drawingUndoManager = UndoManager()
    var stack: [DrawingUnit] = []
    let settings = DrawingSettings()
    var image: UIImage? {
        didSet(oldImage) { redrawStack() }
    }
    
    private lazy var backgroundImageView = {
        let imageView = UIImageView(image: UIImage(named: "background.png"))
        self.addSubview(imageView)
        return imageView
    }()
    private lazy var imageView = {
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
        layer.cornerRadius = 25.0
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.frame = bounds
        imageView.frame = bounds
        redrawStack()
    }
    
    @objc func popDrawing() {
        drawingUndoManager.registerUndo(withTarget: self,
                                          selector: #selector(pushDrawing(_:)),
                                          object: stack.popLast())
        redrawStack()
    }

    @objc func pushDrawing(_ stroke: DrawingUnit) {
        stack.append(stroke)
        drawStrokeWithContext(stroke)
        drawingUndoManager.registerUndo(withTarget: self, selector: #selector(popDrawing), object: nil)
    }
    @objc internal func pushAll(_ strokes: [DrawingUnit]) {
        stack = strokes
        redrawStack()
        drawingUndoManager.registerUndo(withTarget: self, selector: #selector(clearDrawing), object: nil)
    }
    @objc open func clearDrawing() {
        if !drawingUndoManager.canUndo {
//            delegate?.undoEnabled?()
        }

        if drawingUndoManager.canRedo {
//            delegate?.redoDisabled?()
        }

        if stack.count > 0 {
//            delegate?.clearDisabled?()
        }

        drawingUndoManager.registerUndo(withTarget: self, selector: #selector(pushAll(_:)), object: stack)
        stack = []
        redrawStack()
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
        if drawingUndoManager.canRedo {
            let stackCount = stack.count

            if !drawingUndoManager.canUndo {
//                delegate?.undoEnabled?()
            }

            drawingUndoManager.redo()

            if !drawingUndoManager.canRedo {
//                self.delegate?.redoDisabled?()
            }

            updateClear(oldStackCount: stackCount)
        }
    }
    
    func updateClear(oldStackCount: Int) {
        if oldStackCount > 0 && stack.count == 0 {
            //            delegate?.clearDisabled?()
        } else if oldStackCount == 0 && stack.count > 0 {
            //            delegate?.clearEnabled?()
        }
    }
    
}
    
    // MARK: - Touch Actions
    
    extension DrawingView {
        
        /// Triggered when touches begin
        override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let touch = touches.first {
                let stroke = DrawingUnit(points: [touch.location(in: self)], settings: settings)
                stack.append(stroke)
            }
        }

        /// Triggered when touches move
        override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let touch = touches.first {
                let stroke = stack.last!
                let lastPoint = stroke.points.last
                let currentPoint = touch.location(in: self)
                drawLineWithContext(fromPoint: lastPoint!, toPoint: currentPoint, properties: stroke.settings)
                stroke.points.append(currentPoint)
            }
        }

        /// Triggered whenever touches end, resulting in a newly created Stroke
        override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            let stroke = stack.last!
            if stroke.points.count == 1 {
                let lastPoint = stroke.points.last!
                drawLineWithContext(fromPoint: lastPoint, toPoint: lastPoint, properties: stroke.settings)
            }

            if !drawingUndoManager.canUndo {
//                delegate?.undoEnabled?()
            }

            if drawingUndoManager.canRedo {
//                delegate?.redoDisabled?()
            }

            if stack.count == 1 {
//                delegate?.clearEnabled?()
            }

            drawingUndoManager.registerUndo(withTarget: self, selector: #selector(popDrawing), object: nil)
        }
    }
    
    
    // MARK: - Drawing

    fileprivate extension DrawingView {
       
        
        /// Begins the image context
        func beginImageContext() {
            UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, UIScreen.main.scale)
        }

        /// Ends image context and sets UIImage to what was on the context
        func endImageContext() {
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }

        /// Draws the current image for context
        func drawCurrentImage() {
            imageView.image?.draw(in: imageView.bounds)
        }

        /// Clears view, then draws stack
        func redrawStack() {
            if imageView.frame.size == .zero { return }
            beginImageContext()
//            imageView.image?.draw(in: imageView.bounds)
            image?.draw(in: imageView.bounds)

            for stroke in stack {
                drawStroke(stroke)
            }
            endImageContext()
        }

        /// Draws a single Stroke
        func drawStroke(_ stroke: DrawingUnit) {
            let properties = stroke.settings
            let points = stroke.points

            if points.count == 1 {
                let point = points[0]
                drawLine(fromPoint: point, toPoint: point, properties: properties)
            }

            for index in stride(from: 1, to: points.count, by: 1) {
                let point0 = points[index - 1]
                let point1 = points[index]
                drawLine(fromPoint: point0, toPoint: point1, properties: properties)
            }
        }

        /// Draws a single Stroke (begins/ends context
        func drawStrokeWithContext(_ stroke: DrawingUnit) {
            beginImageContext()
            drawCurrentImage()
            drawStroke(stroke)
            endImageContext()
        }

        /// Draws a line between two points
        func drawLine(fromPoint: CGPoint, toPoint: CGPoint, properties: DrawingSettings) {
            let context = UIGraphicsGetCurrentContext()
            context!.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
            context!.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))

            context!.setLineCap(CGLineCap.round)
            context!.setLineWidth(properties.width)

//            let color = properties.color
//            if color != nil {
                context!.setStrokeColor(red: properties.color.red,
                                        green: properties.color.green,
                                        blue: properties.color.blue,
                                        alpha: properties.color.alpha)
                context!.setBlendMode(CGBlendMode.normal)
//            } else {
//                context!.setBlendMode(CGBlendMode.clear)
//            }

            context!.strokePath()
        }

        /// Draws a line between two points (begins/ends context)
        func drawLineWithContext(fromPoint: CGPoint, toPoint: CGPoint, properties: DrawingSettings) {
            beginImageContext()
            drawCurrentImage()
            drawLine(fromPoint: fromPoint, toPoint: toPoint, properties: properties)
            endImageContext()
        }
    }



