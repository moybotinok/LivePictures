//
//  DrawingView.swift
//  LivePictures
//
//  Created by Tany on 28.10.2024.
//
import UIKit
import CoreGraphics

protocol UndoDelegate: AnyObject {
    func setUndo(enable: Bool)
    func setRedo(enable: Bool)
//    func setDelete(enable: Bool)
}

class DrawingView: UIView {
    weak var undoDelegate: UndoDelegate? {
        didSet {
            updateControlsEnable()
        }
    }
    var drawingUndoManager = UndoManager()
    var stack: [DrawingUnit] = []
    let settings = DrawingSettings()
    var selectedColor: CIColor = .black
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
    private lazy var previousSketchImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.alpha = 0.5
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
        previousSketchImageView.frame = bounds
        imageView.frame = bounds
        redrawStack()
    }
    
    func saveShot() -> DrawingShot {
        previousSketchImageView.image = imageView.image
        let shot = DrawingShot(units: stack, sketch: imageView.image)
        imageView.image = nil
        stack = []
        drawingUndoManager.removeAllActions()
        updateControlsEnable()
        return shot
    }
    
    func replaceShot(shot: DrawingShot?, previousShot: DrawingShot?) {
        drawingUndoManager.removeAllActions()
        stack = shot?.units ?? []
        //        for _ in stack.reversed() {
        //            drawingUndoManager.registerUndo(withTarget: self, selector: #selector(popDrawing), object: nil)
        //        }
        //        drawingUndoManager.registerUndo(withTarget: self, selector: #selector(pushAll(_:)), object: stack)
        //        drawingUndoManager.registerUndo(withTarget: self, selector: #selector(pushAll(_:)), object: stack)
        previousSketchImageView.image = previousShot?.sketch
        previousSketchImageView.isHidden = false
        redrawStack()
        updateControlsEnable()
    }
    
    func play(shots: [DrawingShot]) {
        previousSketchImageView.isHidden = true
        imageView.animationImages = shots.compactMap() { $0.sketch }
        imageView.animationDuration = 2
        imageView.startAnimating()
    }
    
    func stop() {
        imageView.stopAnimating()
    }
    
    /////
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
            undoDelegate?.setUndo(enable: true)
        }
        
        if drawingUndoManager.canRedo {
            //            delegate?.redoDisabled?()
            undoDelegate?.setRedo(enable: false)
        }
        
        if stack.count > 0 {
            //            delegate?.clearDisabled?()
//            undoDelegate?.setDelete(enable: false)
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
                undoDelegate?.setRedo(enable: true)
            }
            
            drawingUndoManager.undo()
            
            if !drawingUndoManager.canUndo {
                undoDelegate?.setUndo(enable: false)
            }
            
            updateClear(oldStackCount: stackCount)
        }
    }
    func redoButtonPressed() {
        if drawingUndoManager.canRedo {
            let stackCount = stack.count
            
            if !drawingUndoManager.canUndo {
                //                delegate?.undoEnabled?()
                undoDelegate?.setUndo(enable: true)
            }
            
            drawingUndoManager.redo()
            
            if !drawingUndoManager.canRedo {
                //                self.delegate?.redoDisabled?()
                undoDelegate?.setRedo(enable: false)
            }
            
            updateClear(oldStackCount: stackCount)
        }
    }
    
    func updateClear(oldStackCount: Int) {
        if oldStackCount > 0 && stack.count == 0 {
//                        delegate?.clearDisabled?()
//            undoDelegate?.setDelete(enable: false)

        } else if oldStackCount == 0 && stack.count > 0 {
            //            delegate?.clearEnabled?()
//            undoDelegate?.setDelete(enable: true)
        }
    }
    
    func updateControlsEnable() {
        undoDelegate?.setUndo(enable: drawingUndoManager.canUndo)
        undoDelegate?.setRedo(enable: drawingUndoManager.canRedo)
//        undoDelegate?.setDelete(enable: stack.count > 0)
    }
    
}

// MARK: - Touch Actions

extension DrawingView {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let stroke = DrawingUnit(
                points: [touch.location(in: self)],
                settings: DrawingSettings(color: settings.color))
            stack.append(stroke)
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let stroke = stack.last!
            let lastPoint = stroke.points.last
            let currentPoint = touch.location(in: self)
            drawLineWithContext(fromPoint: lastPoint!, toPoint: currentPoint, properties: stroke.settings)
            stroke.points.append(currentPoint)
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let stroke = stack.last!
        if stroke.points.count == 1 {
            let lastPoint = stroke.points.last!
            drawLineWithContext(fromPoint: lastPoint, toPoint: lastPoint, properties: stroke.settings)
        }
        
        if !drawingUndoManager.canUndo {
            undoDelegate?.setUndo(enable: true)
        }
        
        if drawingUndoManager.canRedo {
            //                delegate?.redoDisabled?()
            undoDelegate?.setRedo(enable: true) //
            
        }
        
        if stack.count == 1 {
//            undoDelegate?.setDelete(enable: true)
        }
        
        drawingUndoManager.registerUndo(withTarget: self, selector: #selector(popDrawing), object: nil)
    }
}


// MARK: - Drawing

fileprivate extension DrawingView {
    
    func beginImageContext() {
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, UIScreen.main.scale)
    }
    
    func endImageContext() {
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func drawCurrentImage() {
        imageView.image?.draw(in: imageView.bounds)
    }
    
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
    
    func drawStrokeWithContext(_ stroke: DrawingUnit) {
        beginImageContext()
        drawCurrentImage()
        drawStroke(stroke)
        endImageContext()
    }
    
    func drawLine(fromPoint: CGPoint, toPoint: CGPoint, properties: DrawingSettings) {
        let context = UIGraphicsGetCurrentContext()
        context!.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context!.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        context!.setLineCap(CGLineCap.round)
        context!.setLineWidth(properties.width)
        
        if properties.color != .clear {
            context!.setStrokeColor(red: properties.color.red,
                                    green: properties.color.green,
                                    blue: properties.color.blue,
                                    alpha: properties.color.alpha)
            context!.setBlendMode(CGBlendMode.normal)
        } else {
            context!.setBlendMode(CGBlendMode.clear)
        }
        
        context!.strokePath()
    }
    
    func drawLineWithContext(fromPoint: CGPoint, toPoint: CGPoint, properties: DrawingSettings) {
        beginImageContext()
        drawCurrentImage()
        drawLine(fromPoint: fromPoint, toPoint: toPoint, properties: properties)
        endImageContext()
    }
}



