//
//  ViewController.swift
//  AngleDemo
//
//  Created by Hardik Trivedi on 01/12/18.
//  Copyright © 2018 iHardikTrivedi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate
{
    
    @IBOutlet weak var vwAngle: UIView!

    var pointA: CGPoint = CGPoint.zero
    var pointB: CGPoint = CGPoint.zero
    var pointC: CGPoint = CGPoint.zero
    
    var isMovingPoint: Bool = false
    var poitnOfMove: String = ""
    
    let angle = Angle.sharedAngle
    var pointToMove = 0
    var angleText: String = ""
    
    let baseColor: UIColor = UIColor.blue
    let otherColor: UIColor = UIColor.yellow
    
    var storedAngle: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))
        self.vwAngle.addGestureRecognizer(gesture)
        
        let panGesture : UIPanGestureRecognizer  = UIPanGestureRecognizer(target: self, action: #selector(self.movePointWithPan(_:)))
        panGesture.delegate = self
        self.vwAngle.addGestureRecognizer(panGesture)
        
        self.storedAngle = NSMutableArray()
        self.angle.removeAngle()
        self.vwAngle.setNeedsLayout()
        self.angleText = ""
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer)
    {
        let touchPoint = sender.location(in: self.vwAngle)
        if pointA == .zero {
            
            pointA = touchPoint
            self.drawCircle(atPoint: touchPoint, withColor: baseColor)
        } else if pointB == .zero {
            
            pointB = touchPoint
            self.drawCircle(atPoint: touchPoint, withColor: baseColor)
            self.drawLine(startPoint: pointA, endPoint: pointB, withColor: baseColor)
        } else if pointC == .zero {
            
            pointC = touchPoint
            self.drawCircle(atPoint: touchPoint, withColor: otherColor)
            self.drawLine(startPoint: pointB, endPoint: pointC, withColor: otherColor)
            
            let label = UILabel(frame: CGRect(x: (self.pointB.x + 13), y: (self.pointB.y - 25), width: 100, height: 30))
            
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.text = self.angleText
            label.textColor = otherColor
            label.textAlignment = .left
            label.tag = 123432
            
            self.vwAngle.viewWithTag(123432)?.removeFromSuperview()
            self.vwAngle.addSubview(label)
            
            for dict in self.storedAngle {
                
                let a: CGPoint = (dict as! NSDictionary).object(forKey: "pointA") as! CGPoint
                let b: CGPoint = (dict as! NSDictionary).object(forKey: "pointB") as! CGPoint
                let c: CGPoint = (dict as! NSDictionary).object(forKey: "pointC") as! CGPoint
                
                self.drawCircle(atPoint: a, withColor: baseColor)
                self.drawCircle(atPoint: b, withColor: baseColor)
                self.drawLine(startPoint: a, endPoint: b, withColor: baseColor)
                self.drawCircle(atPoint: c, withColor: otherColor)
                self.drawLine(startPoint: b, endPoint: c, withColor: otherColor)
                
                let label = UILabel(frame: CGRect(x: (b.x + 13), y: (b.y - 25), width: 100, height: 30))
                
                label.font = UIFont.systemFont(ofSize: 12.0)
                label.text = "\((dict as! NSDictionary).object(forKey: "angle")!)"
                label.textColor = otherColor
                label.textAlignment = .left
                
                self.vwAngle.addSubview(label)
            }
        }
    }
    
    func drawCircle(atPoint point: CGPoint, withColor color: UIColor)
    {
        let path: UIBezierPath = UIBezierPath(arcCenter: point, radius: 5.0, startAngle: 0.0, endAngle: 360.0, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 3.0
        
        self.vwAngle.layer.addSublayer(shapeLayer)
    }
    
    func drawLine(startPoint start: CGPoint, endPoint end: CGPoint, withColor color: UIColor)
    {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        
        line.strokeColor = color.cgColor
        line.lineWidth = 3.0
        
        line.lineJoin = CAShapeLayerLineJoin.round
        self.vwAngle.layer.addSublayer(line)
        
        self.getAngle(first: self.pointA, second: self.pointB, third: self.pointC, view: self.vwAngle)
    }
    
    func getAngle(first : CGPoint, second : CGPoint, third : CGPoint, view : UIView)
    {
        let vec1 = CGVector(dx: first.x - second.x, dy: first.y - second.y)
        let vec2 = CGVector(dx: third.x - second.x, dy: third.y - second.y)
        
        let theta1: CGFloat = CGFloat(atan2f(Float(vec1.dy), Float(vec1.dx)))
        let theta2: CGFloat = CGFloat(atan2f(Float(vec2.dy), Float(vec2.dx)))
        let angledata: CGFloat = theta1 - theta2
        
        let result : CGFloat = (angledata / .pi * 180)
        let final = String(format: "%.1f°", result)
        
        self.angleText = final
        angle.setAngle(firstPoint: first, SecondPoint: second, ThirdPoint: third)
    }
    
    @objc func movePointWithPan(_ sender: UIPanGestureRecognizer)
    {
        let p = sender.location(in: self.vwAngle)
        
        if sender.state == .began {
            
            let d1 : CGFloat = sqrt((p.x - angle.p1.x) * (p.x - angle.p1.x) + (p.y - angle.p1.y) * (p.y - angle.p1.y))
            let d2 : CGFloat = sqrt((p.x - angle.p2.x) * (p.x - angle.p2.x) + (p.y - angle.p2.y) * (p.y - angle.p2.y))
            let tolerance : CGFloat = 15.0
            
            if d1 < tolerance {
                
                pointToMove = 1
            } else if d2 < tolerance {
                
                pointToMove = 2
            } else {
                
                pointToMove = 3
            }
        } else {
            
            if pointToMove == 1 {
                
                angle.p1 = p
                self.pointA = p
            } else if pointToMove == 2 {
                
                angle.p2 = p
                self.pointC = p
            } else {
                
                angle.v = p
                self.pointB = p
            }
            
            self.vwAngle.setNeedsDisplay()
            self.angleText = angle.valueOfAngle()
            self.vwAngle.layer.sublayers?.removeAll()
            
            for dict in self.storedAngle {
                
                let a: CGPoint = (dict as! NSDictionary).object(forKey: "pointA") as! CGPoint
                let b: CGPoint = (dict as! NSDictionary).object(forKey: "pointB") as! CGPoint
                let c: CGPoint = (dict as! NSDictionary).object(forKey: "pointC") as! CGPoint
                
                self.drawCircle(atPoint: a, withColor: baseColor)
                self.drawCircle(atPoint: b, withColor: baseColor)
                self.drawLine(startPoint: a, endPoint: b, withColor: baseColor)
                self.drawCircle(atPoint: c, withColor: otherColor)
                self.drawLine(startPoint: b, endPoint: c, withColor: otherColor)
                
                let label = UILabel(frame: CGRect(x: (b.x + 13), y: (b.y - 25), width: 100, height: 30))
                
                label.font = UIFont.systemFont(ofSize: 12.0)
                label.text = "\((dict as! NSDictionary).object(forKey: "angle")!)"
                label.textColor = otherColor
                label.textAlignment = .left
                
                self.vwAngle.addSubview(label)
            }
            
            self.drawCircle(atPoint: self.pointA, withColor: baseColor)
            self.drawCircle(atPoint: self.pointB, withColor: baseColor)
            self.drawLine(startPoint: self.pointA, endPoint: self.pointB, withColor: baseColor)
            self.drawCircle(atPoint: self.pointC, withColor: otherColor)
            self.drawLine(startPoint: self.pointB, endPoint: self.pointC, withColor: otherColor)
            
            let label = UILabel(frame: CGRect(x: (self.pointB.x + 13), y: (self.pointB.y - 25), width: 100, height: 30))
            
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.text = self.angleText
            label.textColor = otherColor
            label.textAlignment = .left
            label.tag = 123432
            
            self.vwAngle.viewWithTag(123432)?.removeFromSuperview()
            self.vwAngle.addSubview(label)
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if gestureRecognizer .isKind(of: UIPanGestureRecognizer.self) {
            
            let p = gestureRecognizer.location(in: self.vwAngle)
            
            let d1 : CGFloat = sqrt((p.x - angle.p1.x) * (p.x - angle.p1.x) + (p.y - angle.p1.y) * (p.y - angle.p1.y))
            let d2 : CGFloat = sqrt((p.x - angle.p2.x) * (p.x - angle.p2.x) + (p.y - angle.p2.y) * (p.y - angle.p2.y))
            let d3 : CGFloat = sqrt((p.x - angle.v.x) * (p.x - angle.v.x) + (p.y - angle.v.y) * (p.y - angle.v.y))
            let tolerance : CGFloat = 15.0
            
            return (d1 < tolerance) || (d2 < tolerance) || (d3 < tolerance)
        }
        
        return true
    }
    
    @IBAction func btnClearTapped(_ sender: Any)
    {
        self.pointA = CGPoint.zero
        self.pointB = CGPoint.zero
        self.pointC = CGPoint.zero
        self.angleText = ""
        
        self.vwAngle.setNeedsLayout()
        self.angle.removeAngle()
        self.vwAngle.layer.sublayers?.removeAll()
        
        if self.storedAngle.count == 0 {
            
            let a: CGPoint = CGPoint.init(x: 0, y: 0)
            let b: CGPoint = CGPoint.init(x: 10, y: 0)
            let c: CGPoint = CGPoint.init(x: 0, y: 10)
            
            self.drawCircle(atPoint: a, withColor: UIColor.clear)
            self.drawCircle(atPoint: b, withColor: UIColor.clear)
            self.drawLine(startPoint: a, endPoint: b, withColor: UIColor.clear)
            self.drawCircle(atPoint: c, withColor: UIColor.clear)
            self.drawLine(startPoint: b, endPoint: c, withColor: UIColor.clear)
            
            let label = UILabel(frame: CGRect(x: (b.x + 13), y: (b.y - 25), width: 100, height: 30))
            
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.text = ""
            label.textColor = UIColor.clear
            label.textAlignment = .left
            
            self.vwAngle.addSubview(label)
        }
        
        for dict in self.storedAngle {
            
            let a: CGPoint = (dict as! NSDictionary).object(forKey: "pointA") as! CGPoint
            let b: CGPoint = (dict as! NSDictionary).object(forKey: "pointB") as! CGPoint
            let c: CGPoint = (dict as! NSDictionary).object(forKey: "pointC") as! CGPoint
            
            self.drawCircle(atPoint: a, withColor: baseColor)
            self.drawCircle(atPoint: b, withColor: baseColor)
            self.drawLine(startPoint: a, endPoint: b, withColor: baseColor)
            self.drawCircle(atPoint: c, withColor: otherColor)
            self.drawLine(startPoint: b, endPoint: c, withColor: otherColor)
            
            let label = UILabel(frame: CGRect(x: (b.x + 13), y: (b.y - 25), width: 100, height: 30))
            
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.text = "\((dict as! NSDictionary).object(forKey: "angle")!)"
            label.textColor = otherColor
            label.textAlignment = .left
            
            self.vwAngle.addSubview(label)
        }
    }
    
    @IBAction func btnDoneTapped(_ sender: Any)
    {
        if self.pointC == .zero {
            
            return
        }
        
        self.storedAngle.add(["pointA": self.pointA, "pointB": self.pointB, "pointC": self.pointC, "angle": self.angleText as Any])
        
        self.pointA = CGPoint.zero
        self.pointB = CGPoint.zero
        self.pointC = CGPoint.zero
        self.angleText = ""
        
        self.angle.removeAngle()
        self.vwAngle.setNeedsLayout()
    }
    
    @IBAction func btnResetDemoTapped(_ sender: Any)
    {
        self.storedAngle.removeAllObjects()
        self.vwAngle.layer.sublayers?.removeAll()
        
        self.pointA = CGPoint.zero
        self.pointB = CGPoint.zero
        self.pointC = CGPoint.zero
        self.angleText = ""
        
        if self.storedAngle.count == 0 {
            
            let a: CGPoint = CGPoint.init(x: 0, y: 0)
            let b: CGPoint = CGPoint.init(x: 10, y: 0)
            let c: CGPoint = CGPoint.init(x: 0, y: 10)
            
            self.drawCircle(atPoint: a, withColor: UIColor.clear)
            self.drawCircle(atPoint: b, withColor: UIColor.clear)
            self.drawLine(startPoint: a, endPoint: b, withColor: UIColor.clear)
            self.drawCircle(atPoint: c, withColor: UIColor.clear)
            self.drawLine(startPoint: b, endPoint: c, withColor: UIColor.clear)
            
            let label = UILabel(frame: CGRect(x: (b.x + 13), y: (b.y - 25), width: 100, height: 30))
            
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.text = ""
            label.textColor = UIColor.clear
            label.textAlignment = .left
            
            self.vwAngle.addSubview(label)
        }
        
        self.angle.removeAngle()
        self.vwAngle.setNeedsLayout()
    }
    
}

