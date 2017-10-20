//
//  TriangleUIView.swift
//  ECE564_F17_HOMEWORK
//
//  Created by Theodore Franceschi on 9/28/17.
//  Copyright © 2017 ece564. All rights reserved.
//Based on code from https://stackoverflow.com/questions/30650343/triangle-uiview-swift

import UIKit

class TriangleUIView : UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let path = UIGraphicsGetCurrentContext() else { return }
        
        path.beginPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        path.closePath()
        
        path.setFillColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1)
        path.fillPath()
    }
}

