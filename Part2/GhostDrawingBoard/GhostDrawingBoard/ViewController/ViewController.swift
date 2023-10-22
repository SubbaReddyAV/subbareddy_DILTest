//
//  ViewController.swift
//  GhostDrawingBoard
//
//  Created by Subba Reddy on 21/10/2566 BE.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var drwaingView: DrawingView!
    @IBOutlet private weak var redButton: UIButton!
    @IBOutlet private weak var blueButton: UIButton!
    @IBOutlet private weak var greenButton: UIButton!
    @IBOutlet private weak var eraseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyBorder(redButton)
    }
    
    @IBAction func redButtonTapped(_ sender: Any) {
        applyBorder(redButton)
        drwaingView.drawColor = .red
        removeBorder([blueButton, greenButton, eraseButton])
    }
    
    @IBAction func blueButtonTapped(_ sender: Any) {
        drwaingView.drawColor = .blue
        applyBorder(blueButton)
        removeBorder([redButton, greenButton, eraseButton])
    }
    
    @IBAction func greenButtonTapped(_ sender: Any) {
        applyBorder(greenButton)
        drwaingView.drawColor = .green
        removeBorder([redButton, blueButton, eraseButton])
    }
    
    @IBAction func eraseButtonTapped(_ sender: Any) {
        applyBorder(eraseButton)
        drwaingView.drawColor = .white
        removeBorder([redButton, blueButton, greenButton])
    }
    
    private func applyBorder(_ button: UIButton) {
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 4
    }
    
    private func removeBorder(_ buttons: [UIButton]) {
        buttons.forEach { button in
            button.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
