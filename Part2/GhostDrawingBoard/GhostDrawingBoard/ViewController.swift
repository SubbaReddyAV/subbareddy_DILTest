//
//  ViewController.swift
//  GhostDrawingBoard
//
//  Created by Subba Reddy on 21/10/2566 BE.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var drwaingView: UIView!
    @IBOutlet private weak var redButton: UIButton!
    @IBOutlet private weak var blueButton: UIButton!
    @IBOutlet private weak var greenButton: UIButton!
    @IBOutlet private weak var eraseButton: UIButton!
    
    var currentColor: UIColor = .red
    var isErasing: Bool = false
    var lastPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    @IBAction func redButtonTapped(_ sender: Any) {
            currentColor = .red
            isErasing = false
    }
    
    @IBAction func blueButtonTapped(_ sender: Any) {
        currentColor = .blue
        isErasing = false
        
    }
    
    @IBAction func greenButtonTapped(_ sender: Any) {
        currentColor = .green
        isErasing = false
    }
    
    @IBAction func eraseButtonTapped(_ sender: Any) {
        currentColor = .clear
        isErasing = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if let touch = touches.first {
                lastPoint = touch.location(in: drwaingView)
            }
        }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let last = lastPoint {
            drawLine(from: last, to: touch.location(in: drwaingView))
            lastPoint = touch.location(in: drwaingView)
        }
    }
    
    func drawLine(from start: CGPoint, to end: CGPoint) {
        let brushSize: CGFloat = 10.0
        let brush = UIView(frame: CGRect(x: end.x, y: end.y, width: brushSize, height: brushSize))
        
        if isErasing {
            brush.backgroundColor = .white
        } else {
            brush.backgroundColor = currentColor
        }
        
        brush.layer.cornerRadius = brushSize / 2
        drwaingView.addSubview(brush)
    }
    
}

private extension ViewController {
    func setupUI() {
        drwaingView.layer.cornerRadius = 8
        drwaingView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        drwaingView.layer.borderWidth = 0.5
    }
    
    func getDelayForColor(_ color: UIColor) -> Double {
        if color == .red {
            return 1.0
        } else if color == .blue {
            return 3.0
        } else if color == .green {
            return 5.0
        }
        return 2.0
    }
}
