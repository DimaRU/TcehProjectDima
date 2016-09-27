//
//  GraphView.swift
//  TcehProject
//
//  Created by Dmitriy Borovikov on 26.09.16.
//  Copyright © 2016 Borovikov. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    var values = [10, 20, 40, 10, 50, 100.0] {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineColor: UIColor = UIColor.redColor()
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        UIColor.blackColor().setStroke()
        
        let xAxis = UIBezierPath()
        xAxis.lineWidth = 2
        //переместиться на некую начальную точку
        xAxis.moveToPoint(CGPoint(x: 8, y: rect.height - 8))
        //добавить линию с текущей точки до следующей
        xAxis.addLineToPoint(CGPoint(x: rect.width, y: rect.height - 8))
        xAxis.stroke()
        
        let yAxis = UIBezierPath()
        yAxis.lineWidth = 2
        //переместиться на некую начальную точку
        yAxis.moveToPoint(CGPoint(x: 8, y: rect.height - 8))
        //добавить линию с текущей точки до следующей
        yAxis.addLineToPoint(CGPoint(x: 8, y: 8))
        yAxis.stroke()
        
        //рисуем значения
        guard values.count > 1 else { return }
        
        let graphPath = UIBezierPath()
        graphPath.lineWidth = 2
        
        let maxValue = values.maxElement()!
        
        let firstValue = values[0]
        let height = rect.height - 16
        let point = CGPoint(x: 8,
                            y: rect.height - 8 - CGFloat(firstValue) / CGFloat(maxValue) * height)
        graphPath.moveToPoint(point)
        
        let stepX = (rect.width - 8) / CGFloat(values.count - 1)
        for i in 1..<values.count {
            let value = values[i]
            
            let point = CGPoint(x: 8 + stepX * CGFloat(i),
                                y: rect.height - 8 - CGFloat(value) / CGFloat(maxValue) * height)
            graphPath.addLineToPoint(point)
        }
        lineColor.setStroke()
        graphPath.stroke()
    }
}
