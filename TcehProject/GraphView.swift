//
//  GraphView.swift
//  TcehProject
//
//  Created by Dmitriy Borovikov on 26.09.16.
//  Copyright © 2016 Borovikov. All rights reserved.
//

import UIKit


enum GraphType: Int {
    case Graph
    case PieChart
}

@IBDesignable
class GraphView: UIView {
    
    
    @IBInspectable var graphType: Int = 0
    
    var values = [10, 20, 40, 10, 50, 100.0] {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    let PieChartColor: [UIColor] = [.redColor(), .greenColor(), .blueColor(), .cyanColor(), .yellowColor(), .magentaColor(), .orangeColor(), .purpleColor(), .brownColor(), .darkGrayColor() ]
    
    @IBInspectable var lineColor: UIColor = UIColor.redColor()
    
    func drawGraph(rect: CGRect) {
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
    
    func drawPieChart(rect: CGRect) {

        guard values.count > 0 else { return }
        
        //Нужен центр и радиус
        let center = CGPoint(x: CGFloat(rect.width) / 2 , y: CGFloat(rect.height) / 2)
        let radius = CGFloat(min(rect.width, rect.height) - 20) / 2
        
        var startAngle = CGFloat(0)
        let circle = values.reduce(0, combine: +)
        
        for (i, value) in values.enumerate() {
            let angle = CGFloat(M_PI * 2 * value / circle)
            
            let portionPath = UIBezierPath()
            portionPath.moveToPoint(center)
            portionPath.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: startAngle + angle , clockwise: true)
            portionPath.closePath()

            PieChartColor[i].setFill()
            portionPath.fill()
            
            startAngle += angle
        }
        
    }

    func drawBarChart(rect: CGRect) {
        UIColor.blackColor().setStroke()
        
        let xAxis = UIBezierPath()
        xAxis.lineWidth = 2
        xAxis.moveToPoint(CGPoint(x: 8, y: rect.height - 8))
        xAxis.addLineToPoint(CGPoint(x: rect.width, y: rect.height - 8))
        xAxis.stroke()
        
        let yAxis = UIBezierPath()
        yAxis.lineWidth = 2
        yAxis.moveToPoint(CGPoint(x: 8, y: rect.height - 8))
        yAxis.addLineToPoint(CGPoint(x: 8, y: 8))
        yAxis.stroke()
        
        //рисуем значения
        guard values.count > 0 else { return }
        
        let graphPath = UIBezierPath()
        graphPath.lineWidth = 2
        
        let maxValue = values.maxElement()!

        let barHeight = rect.height - 16
        //let barWidth = (Double(rect.width) - 16) / Double(values.count)
        
        let stepX = (rect.width - 8) / CGFloat(values.count - 1)
        for i in 1..<values.count {
            let value = values[i]
            
            let point = CGPoint(x: 8 + stepX * CGFloat(i),
                                y: rect.height - 8 - CGFloat(value) / CGFloat(maxValue) * barHeight)
            graphPath.moveToPoint(point)
            graphPath.addLineToPoint(point)
        }
        lineColor.setStroke()
        graphPath.stroke()
        
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        switch graphType {
        case 0:
            drawGraph(rect)
        case 1:
            drawPieChart(rect)
        default:
            drawBarChart(rect)
        }

    }
}
