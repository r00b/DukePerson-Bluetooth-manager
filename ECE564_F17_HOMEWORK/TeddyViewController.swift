//
//  TeddyViewController.swift
//  ECE564_F17_HOMEWORK
//
//  Created by Theodore Franceschi on 9/28/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit

class TeddyViewController: UIViewController {
    
    // MARK: Properties
    
    var escapeButton =  UIButton()
    
    // MARK: Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.shootingStar), userInfo: nil, repeats: true)
        
        let circle = UIView(frame: CGRect(x: 0.0, y: 80.0, width: 100.0, height: 100.0))
        
        circle.center.x = self.view.center.x
        circle.layer.cornerRadius = 50
        circle.backgroundColor = UIColor.white
        circle.clipsToBounds = true
        
        let lightBlur = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        let blurView = UIVisualEffectView(effect: lightBlur)
        blurView.frame = circle.bounds
        circle.addSubview(blurView)
        self.view.addSubview(circle)
        
        let ground = UIView(frame: CGRect(x: 0.0, y: 525.0, width: self.view.bounds.width, height: 100.0))
        ground.center.x = self.view.center.x
        ground.layer.cornerRadius = 100
        ground.backgroundColor = UIColor.darkGray
        ground.clipsToBounds = true
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let darkBlurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = ground.bounds
        ground.addSubview(darkBlurView)
        self.view.addSubview(ground)
        
        let star = UIView(frame: CGRect(x: 0.0, y: 0, width: 10, height: 10))
        star.layer.cornerRadius = 5
        star.backgroundColor = UIColor.black
        star.clipsToBounds = true
        
        UIView.animate(withDuration: 1, animations:{
            star.frame.origin.x+=320
            star.frame.origin.y+=300
        }, completion:nil)
        
        self.view.addSubview(star)
        for starBall in popStars(){
            self.view.addSubview(starBall)
        }
        
        /*
         let fire: UIImageView
         fire = UIImageView(frame: CGRect(x: 0.0, y: 0, width: 30, height: 30))
         fire.image = #imageLiteral(resourceName: "fire")
         fire.bounds.origin.x = self.view.center.x
         fire.bounds.origin.y = self.view.center.y-100
         self.view.addSubview(fire)
         */
        
        let tent = TriangleUIView(frame: CGRect(x: (self.view.bounds.width-100)/2, y: self.view.bounds.height-150, width: 100 , height: 100))
        tent.backgroundColor = UIColor.green
        view.addSubview(tent)
        view.addSubview(escapeButton)
        addEscape()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: Functions
    
    @objc func escapeAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func addEscape(){
        escapeButton.frame = CGRect(x: 270, y: 23, width: 40, height: 40)
        escapeButton.setImage(#imageLiteral(resourceName: "x"), for: .normal)
        escapeButton.addTarget(self, action: #selector(escapeAction), for: .touchUpInside)
        self.view.addSubview(escapeButton)
        self.view.bringSubview(toFront: escapeButton)
    }
    
    
    // MARK: Private functions
    
    private func popStars()->[UIView]{
        var list = [UIView]()
        for _ in 1...100{
            
            let star = UIView(frame: CGRect(x: random(0.0,self.view.bounds.width), y: random(0.0,self.view.bounds.height-100), width: 4, height: 4))
            star.layer.cornerRadius = 2
            star.backgroundColor = UIColor.white
            star.clipsToBounds = true
            list.append(star)
        }
        return list
    }
    
    @objc private func shootingStar(){
        let star = UIView(frame: CGRect(x: random(0.0,300), y: random(0.0,300), width: 10, height: 10))
        star.layer.cornerRadius = 5
        star.backgroundColor = UIColor.white
        star.clipsToBounds = true
        UIView.animate(withDuration: 1, animations:{
            star.frame.origin.x+=320
            star.frame.origin.y+=300
        }, completion:nil)
        self.view.addSubview(star)
    }
    
    private func random(_ firstNum: CGFloat, _ secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
}
