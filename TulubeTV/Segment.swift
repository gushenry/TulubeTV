//
//  Point.swift
//  Tulube
//
//  Created by James Ormond on 10/24/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation
import UIKit

/**
 This class represents a Segment in a Line. It contains a starting point
 (startX, startY), an ending point (endX, endY), a thickness value, and the id
 of the Line it belongs to.
 */
class Segment {
    
    /**
     The x value of the starting point.
     */
    var startX : CGFloat?
    /**
     The y value of the starting point.
     */
    var startY : CGFloat?
    
    /**
     The x value of the ending point.
     */
    var endX : CGFloat?
    /**
     The y value of the ending point.
     */
    var endY : CGFloat?
    
    /**
     The thickness of this segment.
     */
    var thickness : CGFloat
    
    /**
     The id of the Line this Segment belongs to.
     */
    var lineId : String
    
    /**
     The color of the Segment, represented by a hex String.
     */
    var color = "#000000"
    
    /**
     Initiates the Segment.
     
     - parameter lineId: The id of the Line this Segment belongs to.
     */
    init(lineId: String, thickness: CGFloat) {
        self.lineId = lineId
        self.thickness = thickness
    }
    
    /**
     Adds a starting point to this Segment.
     
     - parameter point: The CGPoint representing the starting point.
     */
    func addStart(point: CGPoint) {
        self.startX = point.x
        self.startY = point.y
    }
    
    /**
     Adds an ending point to this Segment.
     
     - parameter point: The CGPoint representing the ending point.
     */
    func addEnd(point: CGPoint) {
        self.endX = point.x
        self.endY = point.y
    }
    
    /**
     Determines if this is a complete Segment (i.e., contains both a starting
     point and an ending point).
     
     - returns: True if the Segment contains both a starting point and an ending
     point, False otherwise
     */
    func isComplete() -> Bool {
        if (self.startX == nil && self.startY == nil) || (self.endX == nil && self.endY == nil) {
            return false
        }
        return true
    }
    
}
