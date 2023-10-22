

import UIKit

class DrawingView: UIView {
    var drawColor = UIColor.red
    private var lineWidth: CGFloat = 5
    
    private var lastPoint: CGPoint!
    private var bezierPath: UIBezierPath!
    private var pointCounter: Int = 0
    private let pointLimit: Int = 128
    private var preRenderImage: UIImage!
    
    private var drawTimer: Timer?
    private let drawDelay: TimeInterval = 1.0
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initBezierPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBezierPath()
    }
    
    func initBezierPath() {
        bezierPath = UIBezierPath()
        bezierPath.lineCapStyle = CGLineCap.round
        bezierPath.lineJoinStyle = CGLineJoin.round
    }
    
    // MARK: - Touch handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        lastPoint = touch!.location(in: self)
        pointCounter = 0
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        let newPoint = touch!.location(in: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + getTime()) {
            
            self.bezierPath.move(to: self.lastPoint)
            self.bezierPath.addLine(to: newPoint)
            self.lastPoint = newPoint
            
            self.pointCounter += 1
            
            if self.pointCounter == self.pointLimit {
                self.pointCounter = 0
                self.renderToImage()
                self.setNeedsDisplay()
                self.bezierPath.removeAllPoints()
            }
            else {
                self.setNeedsDisplay()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + getTime()) {
            self.renderToImage()
            self.setNeedsDisplay()
            self.bezierPath.removeAllPoints()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        touchesEnded(touches!, with: event)
    }
    
    // MARK: - Pre render
    
    private func renderToImage() {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        if preRenderImage != nil {
            preRenderImage.draw(in: self.bounds)
        }
        
        bezierPath.lineWidth = lineWidth
        drawColor.setFill()
        drawColor.setStroke()
        bezierPath.stroke()
        
        preRenderImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    private func getTime() -> CGFloat {
        switch drawColor {
        case .red: return 1.0
        case .blue: return 3.0
        case .green: return 5.0
        case .white: return 2.0
        default: return 0.0
        }
    }
    // MARK: - Render
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if preRenderImage != nil {
            preRenderImage.draw(in: self.bounds)
        }
        
        bezierPath.lineWidth = lineWidth
        drawColor.setFill()
        drawColor.setStroke()
        bezierPath.stroke()
    }
}
