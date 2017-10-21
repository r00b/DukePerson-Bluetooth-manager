//
//  MarioBackground.swift
//  ECE564_F17_HOMEWORK
//
//  Created by The Ritler on 9/26/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import UIKit

class MarioBackground: UIView {
    
    // MARK: Initializers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    public func makeRed(){
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        let lightGreen = UIColor(red: 0.594, green: 0.980, blue: 0.593, alpha: 0.9)
        
        ctx.setFillColor(UIColor.red.cgColor)
        ctx.addRect(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height/2 + 115))
        ctx.fillPath()
        
        let rect = CGRect(x: 15, y: 50, width: 100, height: 100)
        drawSlice(rect: rect, startPercent: 0, endPercent: 50, color: lightGreen)
        
        ctx.setFillColor(lightGreen.cgColor)
        ctx.addRect(CGRect(x: 15, y: 100, width: 100, height: 294))
        ctx.fillPath()
        
        let rect2 = CGRect(x: 120, y: 200, width: 100, height: 100)
        drawSlice(rect: rect2, startPercent: 0, endPercent: 50, color: lightGreen)
        
        ctx.setFillColor(lightGreen.cgColor)
        ctx.addRect(CGRect(x: 120, y: 250, width: 100, height: 144))
        ctx.fillPath()
    }
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0)
        self.backgroundColor =  UIColor.white
        let _:CGFloat = 100.0
        let _:CGFloat = 100.0
        
        let lightGreen = UIColor(red: 0.594, green: 0.980, blue: 0.593, alpha: 0.9)
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        ctx.setFillColor(UIColor.init(red: 0.527, green: 0.804, blue: 0.976, alpha: 0.8).cgColor)
        ctx.addRect(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height/2 + 115))
        ctx.fillPath()
        ctx.addRect(CGRect(x: 0, y: center.y + 115, width: self.frame.width, height: self.frame.height))
        ctx.setLineWidth(10)
        ctx.setStrokeColor(UIColor.green.cgColor)
        ctx.strokePath()
        ctx.setFillColor(UIColor.brown.cgColor)
        ctx.addRect(CGRect(x: 0, y: center.y + 115, width: self.frame.width, height: self.frame.height))
        ctx.fillPath()
        let rect = CGRect(x: 15, y: 50, width: 100, height: 100)
        drawSlice(rect: rect, startPercent: 0, endPercent: 50, color: lightGreen)
        
        ctx.setFillColor(lightGreen.cgColor)
        ctx.addRect(CGRect(x: 15, y: 100, width: 100, height: 294))
        ctx.fillPath()
        
        let rect2 = CGRect(x: 120, y: 200, width: 100, height: 100)
        drawSlice(rect: rect2, startPercent: 0, endPercent: 50, color: lightGreen)
        
        ctx.setFillColor(lightGreen.cgColor)
        ctx.addRect(CGRect(x: 120, y: 250, width: 100, height: 144))
        ctx.fillPath()
    }
    
    private func drawSlice(rect: CGRect, startPercent: CGFloat, endPercent: CGFloat, color: UIColor) {
        let center = CGPoint(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        let startAngle = startPercent / 100 * CGFloat(Double.pi) * 2 - CGFloat(Double.pi)
        let endAngle = endPercent / 100 * CGFloat(Double.pi) * 2 - CGFloat(Double.pi)
        let path = UIBezierPath()
        path.move(to: center)
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.close()
        color.setFill()
        path.fill()
    }
}
