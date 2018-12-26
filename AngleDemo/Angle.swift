//
//  Angle.swift
//  AngleDemo
//
//  Created by Hardik Trivedi on 02/12/18.
//  Copyright © 2018 iHardikTrivedi. All rights reserved.
//

import UIKit

class Angle: NSObject
{
    var p1 : CGPoint = CGPoint()
    var p2 : CGPoint = CGPoint()
    var v : CGPoint  = CGPoint()
    
    static let sharedAngle = Angle()
    
    override init()
    {
        super.init()
        
        p1 = CGPoint(x: -10, y: -20)
        p2 = CGPoint(x: -10, y: -20)
        v = CGPoint(x: -10, y: -10)
    }
    
    func removeAngle()
    {
        p1 = CGPoint(x: -10, y: -20)
        p2 = CGPoint(x: -10, y: -20)
        v = CGPoint(x: -10, y: -10)
    }
    
    func setAngle(firstPoint : CGPoint, SecondPoint : CGPoint,ThirdPoint : CGPoint)
    {
        self.p1 = firstPoint
        self.v = SecondPoint
        self.p2 = ThirdPoint
    }
    
    func valueOfAngle() -> String
    {
        let vec1 = CGVector(dx: p1.x - v.x, dy: p1.y - v.y)
        let vec2 = CGVector(dx: p2.x - v.x, dy: p2.y - v.y)
     
        let theta1: CGFloat = CGFloat(atan2f(Float(vec1.dy), Float(vec1.dx)))
        let theta2: CGFloat = CGFloat(atan2f(Float(vec2.dy), Float(vec2.dx)))
        
        let angledata: CGFloat = theta1 - theta2
        let result : CGFloat = (angledata / .pi * 180)
        
        return String(format: "%.1f°", result)
    }
    
}
