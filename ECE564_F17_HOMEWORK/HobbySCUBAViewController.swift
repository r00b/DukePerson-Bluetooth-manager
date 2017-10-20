//
//  HobbySCUBAViewController.swift
//  ECE564_F17_HOMEWORK
//
//  Created by Robert Steilberg on 9/26/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit

class HobbySCUBAViewController: UIViewController {
    
    var escapeButton =  UIButton()
    
    func addEscape(){
        escapeButton.frame = CGRect(x: 270, y: 23, width: 40, height: 40)
        escapeButton.setImage(#imageLiteral(resourceName: "x"), for: .normal)
        escapeButton.addTarget(self, action: #selector(escapeAction), for: .touchUpInside)
        self.view.addSubview(escapeButton)
        self.view.bringSubview(toFront: escapeButton)
    }
    
    @objc func escapeAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    let diverFrames: [UIImage] = [UIImage(named: "diver-1.png")!, UIImage(named: "diver-2.png")!, UIImage(named: "diver-3.png")!, UIImage(named: "diver-4.png")!]
    
    // x,y initial positions of each fish
    let fishPositions : [[Double]] = [[350, 50], [400, 210], [550, 300], [450, 333], [375, 400]]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Private functions
    
    private func renderScubaDiver() {
        let scubaDiver = UIImageView()
        scubaDiver.frame = CGRect(x: self.view.frame.width/2 - 100, y: 50, width: 100, height: 47)
        // set frames for image animation
        scubaDiver.animationImages = diverFrames
        scubaDiver.animationDuration = 0.5
        scubaDiver.startAnimating()
        self.view.addSubview(scubaDiver)
        animateDiverUp(scubaDiver: scubaDiver)
    }
    
    private func renderFish() {
        for position in fishPositions {
            
            let headLayer = CAShapeLayer()
            headLayer.fillColor = UIColor.orange.cgColor
            let radius: CGFloat = 10.0
            let headPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius), cornerRadius: radius).cgPath
            headLayer.path = headPath
            
            let tailLayer = CAShapeLayer()
            tailLayer.fillColor = UIColor.orange.cgColor
            let tailPath = CGMutablePath()
            tailPath.move(to: CGPoint(x: radius, y: radius))
            tailPath.addLine(to: CGPoint(x: radius + 18, y: radius + 10))
            tailPath.addLine(to: CGPoint(x: radius + 18, y: radius - 10))
            tailPath.closeSubpath()
            tailLayer.path = tailPath
            
            let eyeLayer = CAShapeLayer()
            eyeLayer.fillColor = UIColor.black.cgColor
            let eyePath = UIBezierPath(roundedRect: CGRect(x: 4, y: 4, width: 2.0 * radius/6, height: 2.0 * radius/6), cornerRadius: radius/6).cgPath
            eyeLayer.path = eyePath
            
            let fish = CALayer()
            fish.addSublayer(tailLayer)
            fish.addSublayer(headLayer)
            fish.addSublayer(eyeLayer)
            
            animateFish(fishLayer: fish, x: position[0], y: position[1])
            self.view.layer.addSublayer(fish)
        }
    }
    
    
    // MARK: Animation functions
    
    private func animateDiverUp(scubaDiver: UIImageView) {
        let animation = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) {
            scubaDiver.frame = CGRect(x: self.view.frame.width/2 - 100, y: 400, width: 100, height: 47)
        }
        animation.addCompletion({_ in
            self.animateDiverDown(scubaDiver: scubaDiver)
        })
        animation.startAnimation()
    }
    
    private func animateDiverDown(scubaDiver: UIImageView) {
        let animation = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) {
            scubaDiver.frame = CGRect(x: self.view.frame.width/2 - 100, y: 50, width: 100, height: 47)
        }
        animation.addCompletion({_ in
            self.animateDiverUp(scubaDiver: scubaDiver)
        })
        animation.startAnimation()
    }
    
    private func animateFish(fishLayer: CALayer, x: Double, y: Double) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "position")
        animation.duration = CFTimeInterval(arc4random_uniform(4) + 1)
        animation.repeatCount = .infinity
        animation.fromValue = CGPoint(x: x, y: y)
        animation.toValue = CGPoint(x: 0, y: y)
        animation.isRemovedOnCompletion = false
        fishLayer.add(animation, forKey: "position")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor(red: 0.27, green: 0.48, blue: 0.60, alpha: 1.0)
        
        renderScubaDiver()
        renderFish()
        addEscape()
    }
}

