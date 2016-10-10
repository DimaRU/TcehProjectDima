//
//  GraphView.swift
//  TcehProject
//
//  Created by Dmitriy Borovikov on 26.09.16.
//  Copyright © 2016 Borovikov. All rights reserved.
//

import UIKit
import QuartzCore



class GraphLayer: CALayer {
    dynamic var progress: Double = 0
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
        if let layer = layer as? GraphLayer {
            self.progress = layer.progress
        }
    }
    
    required init?(coder aDecoder: NSCoder) { // Из storyboard
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
    }
    
    override class func needsDisplayForKey(key: String) -> Bool {
        if key == "progress" {      // если меняется progress - запросить перерисовку
            return true
        }
        return super.needsDisplayForKey(key)
    }
    
}



enum GraphType: Int {
    case LineGraph
    case PieChart
    case BarChar
}

@IBDesignable
class GraphView: UIView {
    
    @IBInspectable var pieAnimationType = 0
    @IBInspectable var graphType: Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    

    var values = [10, 20, 40, 10, 50, 100.0] {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    let PieChartColor: [UIColor] = [.redColor(), .greenColor(), .blueColor(), .cyanColor(), .yellowColor(), .magentaColor(), .orangeColor(), .purpleColor(), .brownColor(), .darkGrayColor() ]
    
    @IBInspectable var lineColor: UIColor = UIColor.redColor()
    
    
    override class func layerClass() -> AnyClass {
        return GraphLayer.self
    }
    
    
    
    
    func drawLineGraph(rect: CGRect, progress: Double) {
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
    
    
    func drawPieChartAnimated(rect: CGRect, progress: Double) {
        guard values.count > 0 else { return }
        //Нужен центр и радиус
        let center = CGPoint(x: CGFloat(rect.width) / 2 , y: CGFloat(rect.height) / 2)
        // biggest address
        let startRadius = CGFloat(min(rect.width, rect.height) - 20) / 2
        let radius = startRadius * 2 / 3

        let rInner = startRadius/3 * CGFloat(1 - progress)
        
        switch pieAnimationType {
        case 0:
            drawPieChartAnimated1(radius, rInner: rInner, center: center)
        case 1:
            drawPieChartAnimated2(radius, center: center, progress: progress)
        default:
            drawPieChartAnimated3(radius, center: center, progress: progress)
        }
    }
        
    
    func drawPieChartAnimated1(radius: CGFloat, rInner: CGFloat, center: CGPoint) {
        var startAngle = CGFloat(0)
        let circle = values.reduce(0, combine: +)
        
        for (i, value) in values.enumerate() {
            let angle = CGFloat(M_PI * 2 * value / circle)
            
            // Clear outer arc
//            let portionPath = UIBezierPath()
//            portionPath.moveToPoint(center)
//            portionPath.addArcWithCenter(center,
//                                         radius: radius + rInner,
//                                         startAngle: startAngle,
//                                         endAngle: startAngle + angle,
//                                         clockwise: true)
//            portionPath.closePath()
//            UIColor.lightGrayColor().setFill()
//            portionPath.fill()
            
            // Draw outer-inner arc
            let x = center.x + rInner * cos(startAngle + angle/2)
            let y = center.y + rInner * sin(startAngle + angle/2)
            let centerInner = CGPoint(x: x, y: y)
            
            let drawPath = UIBezierPath()
            drawPath.moveToPoint(centerInner)
            drawPath.addArcWithCenter(centerInner,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: startAngle + angle,
                                      clockwise: true)
            drawPath.closePath()
            PieChartColor[i].setFill()
            drawPath.fill()
            
            startAngle += angle
        }
        
    }
    
    func drawPieChartAnimated2(radius: CGFloat, center: CGPoint, progress: Double) {
        
        var startAngle = CGFloat(0)
        let circle = values.reduce(0, combine: +)
        
        for (i, value) in values.enumerate() {
            let angle = CGFloat(M_PI * 2 * value / circle)
            
            let portionPath = UIBezierPath()
            portionPath.moveToPoint(center)
            portionPath.addArcWithCenter(center,
                                         radius: radius,
                                         startAngle: startAngle,
                                         endAngle: startAngle + angle * CGFloat(progress),
                                         clockwise: true)
            portionPath.closePath()
            
            PieChartColor[i].setFill()
            portionPath.fill()
            
            startAngle += angle
        }
        
    }

    func drawPieChartAnimated3(radius: CGFloat, center: CGPoint, progress: Double) {
        
        var startAngle = CGFloat(0)
        let circle = values.reduce(0, combine: +)
        
        for (i, value) in values.enumerate() {
            let angle = CGFloat(M_PI * 2 * progress * value / circle)
            
            let portionPath = UIBezierPath()
            portionPath.moveToPoint(center)
            portionPath.addArcWithCenter(center,
                                         radius: radius,
                                         startAngle: startAngle,
                                         endAngle: startAngle + angle,
                                         clockwise: true)
            portionPath.closePath()
            
            PieChartColor[i].setFill()
            portionPath.fill()
            
            startAngle += angle
        }
        
    }
    

    func drawBarChart(rect: CGRect, progress: Double) {
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
    
//    override func drawRect(rect: CGRect) {
//        super.drawRect(rect)
    //drawRect
    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        let rect = CGContextGetClipBoundingBox(ctx)
        
        UIGraphicsPushContext(ctx)
        defer { UIGraphicsPopContext() }
        
        let progress = (layer.presentationLayer() as? GraphLayer)?.progress ?? 0
    
        switch graphType {
        case 0:
            drawLineGraph(rect, progress: progress)
        case 1:
            drawPieChartAnimated(rect, progress: progress)
        default:
            drawBarChart(rect, progress: progress)
        }

    }
    
    
    func startAnimation(duration: Double) {
        pieAnimationType += 1
        if pieAnimationType > 2 {
            pieAnimationType = 0
        }
        let animation = CABasicAnimation(keyPath: "progress")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        animation.removedOnCompletion  = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        layer.addAnimation(animation, forKey: "anykey")
    }
    
}
