//
//  Canvas.swift
//  Tulube
//
//  Created by James Ormond on 10/26/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

/**
 This class represents the drawing space used by the user. All touches are observed here,
 and then delegated appropriately. Additionally, actual drawing is done in this class.
 */
class Canvas: UIImageView {
    
    var opacity: CGFloat = 1.0
    
    /**
     Determines if the current drawing is a line (swiped = true) or just a
     dot (swiped = false). On touchesBegan, this value is set to false; on
     touchesMoved, this values is set to true, communicating that a line
     (rather than a dot) is being created.
     */
    var swiped = false
    
    /**
     This function takes a Segment and draws it on the Canvas. The drawing
     process uses UIGraphics.
     
     - parameter segment: The Segment to be drawn on the Canvas.
     */
    func drawLineFromSegment(segment: Segment) {
        
        let fromPoint = CGPoint(x: segment.startX!, y: segment.startY!)
        let toPoint = CGPoint(x: segment.endX!, y: segment.endY!)
        
        // let convertedPoints = self.convertPointsToCurrentCanvasSize(from: fromPoint, to: toPoint)
        
        UIGraphicsBeginImageContext(self.bounds.size)
        self.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        let context = UIGraphicsGetCurrentContext()
        
        context!.move(to: fromPoint)
        context!.addLine(to: toPoint)
        
        //        context!.move(to: convertedPoints.from)
        //        context!.addLine(to: convertedPoints.to)
        
        context!.setLineCap(CGLineCap.round)
        context!.setLineWidth(segment.thickness)
        context!.setStrokeColor(self.convertHexToRGB(hex: segment.color))
        context!.setBlendMode(CGBlendMode.normal)
        
        context!.strokePath()
        
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        self.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.swiped = false
        if let touch = touches.first {
            if let segment = DrawManager.sharedInstance.handleTouch(touch: touch, fromCanvas: self) {
                self.drawLineFromSegment(segment: segment)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.swiped = true
        if let touch = touches.first {
            if let segment = DrawManager.sharedInstance.handleTouch(touch: touch, fromCanvas: self) {
                self.drawLineFromSegment(segment: segment)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            if let touch = touches.first {
                if let segment = DrawManager.sharedInstance.handleTouch(touch: touch, fromCanvas: self) {
                    self.drawLineFromSegment(segment: segment)
                }
            }
        }
        
        DrawManager.sharedInstance.endTouches()
    }
    
    /**
     Takes two CGPoints and converts them to two CGPoints that correspond to the
     current Canvas size.
     
     - parameter from: A CGPoint
     - parameter to: A CGPoint
     
     - returns: A tuple containing the converted parameters *from* and *to*
     */
    func convertPointsToCurrentCanvasSize(from: CGPoint, to: CGPoint) -> (from: CGPoint, to: CGPoint) {
        let ogDimensions = CGSize(width: 900, height: 600)
        let currentDimensions = self.frame.size
        
        // from
        let newFromX = (from.x / ogDimensions.width) * currentDimensions.width
        let newFromY = (from.y / ogDimensions.height) * currentDimensions.height
        
        let newFrom = CGPoint(x: newFromX, y: newFromY)
        
        // to
        let newToX = (to.x / ogDimensions.width) * currentDimensions.width
        let newToY = (to.y / ogDimensions.height) * currentDimensions.height
        
        let newTo = CGPoint(x: newToX, y: newToY)
        
        return (from: newFrom, to: newTo)
    }
    
    /**
     Notifies the Canvas to enter eraser mode.
     */
    func eraserPressed() {
        
    }
    
    /**
     Notifies the Canvas to clear all current drawings.
     */
    func clear() {
        self.image = nil
    }
    
    /**
     Converts a hex value to its corresponding CGColor.
     
     - paramter hex: The String hex value.
     
     - returns: The CGColor representation of the hex String.
     */
    func convertHexToRGB(hex: String) -> CGColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray.cgColor
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        let color = UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
        return color.cgColor
    }
    
}
