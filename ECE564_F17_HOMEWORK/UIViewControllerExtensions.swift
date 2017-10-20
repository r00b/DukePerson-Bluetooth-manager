//
//  UIViewControllerExtensions.swift
//  TheGargsHW
//
//  Created by Theodore Franceschi on 10/20/17.
//  Copyright © 2017 ece564. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    func toggleKeyboard()
    {
        let click: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(click)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
