//
//  DrawModel.swift
//  Tulube
//
//  Created by James Ormond on 10/25/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation
import UIKit

/**
 The DrawModel handles all logic for the Canvas; all touches from the Canvas
 are sent to the DrawModel for handling.
 */
class DrawModel {
    
    /**
     Represents the current Segment being drawn. If *currentSegment* is nil,
     then the user is not currently drawing, and so no Segments are being created.
     If *currentSegment* is not nil, then the user is currently drawing, and so
     new Segments are being created.
     */
    var currentSegment : Segment?
    
    /**
     Represents the current Line being drawn. If *currentLinet* is nil,
     then the user is not currently drawing, and so no Lines are being created.
     If *currentLine* is not nil, then the user is currently drawing, and so
     new Lines are being created.
     */
    var currentLine : Line?
    
    /**
     Represents the current selected drawing color. Stored as a hex string.
     */
    var color : String = "#000000"
    
    /**
     Manages the Lines for this Canvas.
     */
    var lineManager = LineManager()
    
    var thickness : CGFloat = 5.0
    
    /**
     Handles a touch from the Canvas. All logic around drawing is handled in
     this function. There are a few process that can take place in this function:
     - If this is the first touch of a user's draw, then a new Line object is
     created, a new Segment object created (only adding the *start* property),
     and the new Line object is sent to the server.
     - If this is not the first touch of a user's draw, then either:
     - A new *currentSegment* is created, and the *start* property is set
     - Or the *currentSegment* is completed, that Segment is added to *currentLine*,
     *currentSegment* is sent to the DrawManager to be sent to the server, and
     a new *currentSegment* is created.
     
     - parameter touch: A UITouch representing the user's touch
     - parameter view: The UIView that the *touch* was in
     
     - returns: An Optional Segment, to be drawn on the Canvas if it exists.
     */
    func addTouch(touch: UITouch, view: UIView) -> Segment? {
        let currentPoint = touch.location(in: view)
        
        
        if let line = self.currentLine {
            if let segment = self.currentSegment {
                // complete the segment
                segment.addEnd(point: currentPoint)
                segment.color = line.color
                DrawManager.sharedInstance.sendSegment(segment: segment)
                line.addSegment(segment: segment)
                
                // start the next segment
                self.currentSegment = Segment(lineId: line._id, thickness: self.thickness)
                self.currentSegment!.addStart(point: currentPoint)
                
                return segment
            } else {
                // start a new segment
                self.currentSegment = Segment(lineId: line._id, thickness: self.thickness)
                self.currentSegment!.color = line.color
                self.currentSegment!.addStart(point: currentPoint)
            }
        } else {
            
            // first point of first segment of new line
            let line = Line()
            line.color = self.color
            let segment = Segment(lineId: line._id, thickness: self.thickness)
            segment.addStart(point: currentPoint)
            line.addSegment(segment: segment)
            
            self.lineManager.addLine(line: line)
            
            self.currentSegment = segment
            self.currentLine = line
            
            // emit new line
            DrawManager.sharedInstance.sendEmptyLine(line: self.currentLine!)
            
        }
        
        
        return nil
    }
    
    /**
     Called when the user finishes drawing. If there is a *currentLine*, it is
     sent to the SocketIOManager to be sent to the server. Then, *currentLine* and
     *currentSegment* are sent to nil, in preparation of the next drawig the user
     makes.
     */
    func endTouches() {
        if let line = self.currentLine {
            DrawManager.sharedInstance.sendCompletedLine(line: line)
        }
        self.currentLine = nil
        self.currentSegment = nil
    }
    
    /**
     Sets the current color to a new hex string.
     
     - parameter hex: The new String hex color.
     */
    func setColor(hex: String) {
        self.color = hex
    }
    
    func clearLocalLines() {
        self.lineManager.removeAllLines()
    }
    
}
