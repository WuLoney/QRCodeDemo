//
//  QRCodeHollowView.swift
//  QRCodeDemo
//
//  Created by maiGit on 2017/4/19.
//  Copyright © 2017年 maiGit. All rights reserved.
//  

import UIKit

class QRCodeHollowView: UIView {
    
    /// 镂空部分的位置大小
    var _hollowRect: CGRect?

    override func draw(_ rect: CGRect) {
        
        let shLayer = CAShapeLayer()
        layer.addSublayer(shLayer)
        /// 创建一个可变的路径对象
        let path = CGMutablePath()
        path.addRect(self.bounds)
        path.addRect(_hollowRect!)
        shLayer.fillRule = kCAFillRuleEvenOdd
        shLayer.path = path
        shLayer.fillColor = UIColor.black.cgColor
        shLayer.opacity = 0.5
    }
}
