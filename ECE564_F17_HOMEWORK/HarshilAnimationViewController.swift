//
//  HarshilAnimationViewController.swift
//  ECE564_F17_HOMEWORK
//
//  Created by Harshil Garg on 9/24/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit

class HarshilAnimationViewController: UIViewController {
    
    var ballLayer: CAShapeLayer = CAShapeLayer()
    var maxBalls: Int = 100
    var ballCount: Int = 0
    
    var tennisplayer: UIImageView!
    var score: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background
        self.view.backgroundColor = UIColor(red: 26/255, green: 51/255, blue: 102/255, alpha: 1)
        
        // Court besides net
        let halfYPixel: CGFloat = 40
        let unitHeight: CGFloat = (view.bounds.height - 2*halfYPixel)/12
        let halfXPixel : CGFloat = (view.bounds.width - 3.5*unitHeight)/2
        
        let courtPath: UIBezierPath = UIBezierPath()
        courtPath.move(to: CGPoint(x: halfXPixel, y: halfYPixel))
        courtPath.addLine(to: CGPoint(x: halfXPixel, y: unitHeight*12 + halfYPixel))
        courtPath.addLine(to: CGPoint(x: halfXPixel + unitHeight*3.5, y: unitHeight*10.5 + halfYPixel))
        courtPath.addLine(to: CGPoint(x: halfXPixel + unitHeight*3.5, y: unitHeight*1.5 + halfYPixel))
        courtPath.addLine(to: CGPoint(x: halfXPixel, y: halfYPixel))
        courtPath.close()
        makeNewLayer().path = courtPath.cgPath
        
        let firstSinglesPath: UIBezierPath = UIBezierPath()
        firstSinglesPath.move(to: CGPoint(x: halfXPixel + unitHeight*0.8, y: unitHeight*0.35+halfYPixel))
        firstSinglesPath.addLine(to: CGPoint(x: halfXPixel + unitHeight*0.8, y: unitHeight*11.65+halfYPixel))
        firstSinglesPath.close()
        makeNewLayer().path = firstSinglesPath.cgPath
        
        let secondSinglesPath: UIBezierPath = UIBezierPath()
        secondSinglesPath.move(to: CGPoint(x: halfXPixel + unitHeight*3.2, y: unitHeight*1.4+halfYPixel))
        secondSinglesPath.addLine(to: CGPoint(x: halfXPixel + unitHeight*3.2, y: unitHeight*10.6+halfYPixel))
        secondSinglesPath.close()
        makeNewLayer().path = secondSinglesPath.cgPath
        
        let leftServeBoxPath: UIBezierPath = UIBezierPath()
        leftServeBoxPath.move(to: CGPoint(x: halfXPixel + unitHeight*0.8, y: unitHeight*3.3+halfYPixel))
        leftServeBoxPath.addLine(to: CGPoint(x: halfXPixel + unitHeight*3.2, y: unitHeight*4+halfYPixel))
        leftServeBoxPath.close()
        makeNewLayer().path = leftServeBoxPath.cgPath
        
        let rightServeBoxPath: UIBezierPath = UIBezierPath()
        rightServeBoxPath.move(to: CGPoint(x: halfXPixel + unitHeight*0.8, y: unitHeight*8.7+halfYPixel))
        rightServeBoxPath.addLine(to: CGPoint(x: halfXPixel + unitHeight*3.2, y:unitHeight*8+halfYPixel))
        rightServeBoxPath.close()
        makeNewLayer().path = rightServeBoxPath.cgPath
        
        let middleDividerPath: UIBezierPath = UIBezierPath()
        middleDividerPath.move(to: CGPoint(x: halfXPixel + unitHeight*2.1, y: unitHeight*3.7+halfYPixel))
        middleDividerPath.addLine(to: CGPoint(x: halfXPixel + unitHeight*2.1, y: unitHeight*8.3+halfYPixel))
        middleDividerPath.close()
        makeNewLayer().path = middleDividerPath.cgPath
        
        let net: UIBezierPath = UIBezierPath()
        net.move(to: CGPoint(x: halfXPixel - 10, y: unitHeight*6+halfYPixel))
        net.addLine(to: CGPoint(x: halfXPixel + unitHeight*3.5 + 30, y: unitHeight*6 + halfYPixel))
        net.close()
        let netLayer = makeNewLayer()
        netLayer.strokeColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 225/255).cgColor
        netLayer.path = net.cgPath
        
        let netLeft: UIBezierPath = UIBezierPath()
        netLeft.move(to: CGPoint(x: halfXPixel - 10, y: unitHeight*6+halfYPixel - 2))
        netLeft.addLine(to: CGPoint(x: halfXPixel + unitHeight*3.5 + 30, y: unitHeight*6 + halfYPixel - 2))
        netLeft.close()
        let netLeftLayer = makeNewLayer()
        netLeftLayer.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 225/255).cgColor
        netLeftLayer.lineWidth = 2
        netLeftLayer.path = netLeft.cgPath
        
        let netRight: UIBezierPath = UIBezierPath()
        netRight.move(to: CGPoint(x: halfXPixel - 10, y: unitHeight*6+halfYPixel + 2))
        netRight.addLine(to: CGPoint(x: halfXPixel + unitHeight*3.5 + 30, y: unitHeight*6 + halfYPixel + 2))
        netRight.close()
        let netRightLayer = makeNewLayer()
        netRightLayer.strokeColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 255/255).cgColor
        netRightLayer.lineWidth = 2
        netRightLayer.path = netRight.cgPath
        
        tennisplayer = UIImageView()
        tennisplayer.image = #imageLiteral(resourceName: "tennis")
        tennisplayer.frame = CGRect(x: 100, y:25, width: 88.5, height: 80.625)
        tennisplayer.transform = tennisplayer.transform.rotated(by: CGFloat(Double.pi/2))
        self.view.addSubview(tennisplayer)
        
        score = UILabel(frame: CGRect(x:190, y:188, width:200, height:20))
        score.text = "0-0"
        score.font = score.font.withSize(20)
        score.textColor = UIColor.white
        self.view.addSubview(score)
        score.transform = score.transform.rotated(by: CGFloat((Double.pi / 2.0)))
        
        ballCount = 0
        
        addEscape()
        animate()
        // Do any additional setup after loading the view.
    }
    
    private func makeNewLayer() -> CAShapeLayer {
        let court: CAShapeLayer = CAShapeLayer()
        view.layer.addSublayer(court)
        court.opacity = 1
        court.lineWidth = 3
        court.lineJoin = kCALineJoinMiter
        court.strokeColor = UIColor.white.cgColor
        court.fillColor = UIColor(red: 115/255, green: 208/255, blue: 61/255, alpha: 255/255).cgColor
        return court
    }
    
    private func makeNewBall() -> CAShapeLayer {
        let randomX: CGFloat = CGFloat(175 + (100 * Float(arc4random()) / Float(UINT32_MAX)))
        tennisplayer.frame = CGRect(x: randomX - 70, y:25, width: 88.5, height: 80.625)
        // Tennis ball
        let circlePath: UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: randomX, y: 100), radius: CGFloat(8), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let ballLayer: CAShapeLayer = makeNewLayer()
        ballLayer.fillColor = UIColor(red: 241/255, green: 246/255, blue: 78/255, alpha: 1).cgColor
        ballLayer.strokeColor = UIColor.white.cgColor
        ballLayer.lineWidth = 0
        ballLayer.path = circlePath.cgPath
        return ballLayer
    }
    
    func animate() {
        if (ballCount < maxBalls) {
            let when = DispatchTime.now() + 1.5 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.animateHelper(ball: self.makeNewBall())
                if (self.ballCount % 5 == 0) {
                    self.score.text = "0-0"
                } else if (self.ballCount % 5 == 1) {
                    self.score.text = "15-0"
                } else if (self.ballCount % 5 == 2) {
                    self.score.text = "30-0"
                } else if (self.ballCount % 5 == 3) {
                    self.score.text = "30-15"
                } else if (self.ballCount % 5 == 4) {
                    self.score.text = "40-15"
                }
                self.ballCount = self.ballCount + 1
            }
        }
    }
    
    private func animateHelper(ball: CAShapeLayer) {
        let x0: CGFloat = ball.position.x
        let y0: CGFloat = ball.position.y
        
        let xFactorRandom: CGFloat = CGFloat(0.3+(0.7*Float(arc4random()) / Float(UINT32_MAX)))
        
        // First hit
        var values: [NSValue] = []
        for i in 0...32 {
            let y1: CGFloat = CGFloat(10*i)
            let intermediate1 = (10*i - 1227/8)*(10*i - 1227/8)
            let intermediate2 = sqrt(28066.650625 - Double(intermediate1))
            let intermediate3 = intermediate2 - 337/5
            let x1: CGFloat = CGFloat(intermediate3)
            let value: NSValue = NSValue(cgPoint: CGPoint(x: x0 + xFactorRandom*x1, y: y0 + y1))
            values += [value]
        }
        // Bounce
        for i in 32...52 {
            let y1: CGFloat = CGFloat(10*i)
            
            let intermediate1 = (10*i - 420)*(10*i - 420)
            let intermediate2 = sqrt(10696.3 - Double(intermediate1))
            let intermediate3 = intermediate2 - 53.4228
            let x1: CGFloat = CGFloat(intermediate3)
            let value: NSValue = NSValue(cgPoint: CGPoint(x: x0 + xFactorRandom*x1, y: y0 + y1))
            values += [value]
        }
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.values = values
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.duration = 1.5
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        ball.add(animation, forKey: "position")
        animate()
    }
    
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
    
    //    private func animateBall(ball: CAShapeLayer)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
