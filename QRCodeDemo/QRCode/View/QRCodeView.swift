//
//  QRCodeView.swift
//  QRCodeDemo
//
//  Created by maiGit on 2017/4/18.
//  Copyright © 2017年 maiGit. All rights reserved.
//

import UIKit

class QRCodeView: UIView {

    @IBInspectable var bordWith: CGFloat = 0.0 {
        didSet{
            layer.borderWidth = bordWith
        }
    }
    
    @IBInspectable var bordColor: UIColor = UIColor.clear {
        didSet{
            layer.borderColor = bordColor.cgColor
        }
    }
}
