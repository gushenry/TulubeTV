//
//  DrawManager.swift
//  Tulube
//
//  Created by James Ormond on 11/4/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation
import UIKit

/**
 The DrawManager acts as the middle man for the Canvas and the DrawModel.
 The DrawViewController and SocketIOManager need to communicate to both the
 Canvas and the DrawModel, but at inconsistent times, so all communication
 from the DrawViewController and SocketIOManger passes through the DrawManager
 and is passed to the Canvas and DrawModel, and vice versa.
 
 When an instance of the DrawManager is initiated with the intention of using it,
 it is imortant to set the *canvas* and *drawModel* properties.
 */
class DrawManager {
    
    /**
     The shared instance is the instance of DrawManager that we use in the app.
     */
    static let sharedInstance = DrawManager()
    
    /**
     Represents that Canvas that the DrawManager is in communication with.
     */
    var canvas : Canvas?
    
    /**
     Represents that DrawModel that the DrawManager is in communication with.
     */
    var drawModel : DrawModel?
    
    /**
     Called from the Canvas. Gives the DrawManager a touch event, and passes it to
     the DrawModel to be handled.
     
     - parameter touch: A UITouch event representing the user's touch.
     - parameter view: The UIView that the *touch* was in.
     
     - returns: An Optional Segment, to be passed back to the Canvas to be  drawn
     if it exists.
     */
    func handleTouch(touch: UITouch, fromCanvas view: UIView) -> Segment? {
        let segment = self.drawModel?.addTouch(touch: touch, view: view)
        return segment
    }
    
    /**
     Tells the DrawModel that the user has finished drawing.
     */
    func endTouches() {
        self.drawModel?.endTouches()
    }
    
    /**
     Tells the SocketIOManager to send a Segment to the server.
     
     - parameter segment: The Segment to be sent.
     */
    func sendSegment(segment: Segment) {
        SocketIOManager.sharedInstance.sendSegment(segment: segment)
    }
    
    /**
     Tells the SocketIOManager to send a Line to the server.
     
     - parameter line: The Line to be sent.
     */
    func sendEmptyLine(line: Line) {
        SocketIOManager.sharedInstance.sendEmptyLine(line: line)
    }
    
    func sendCompletedLine(line: Line) {
        SocketIOManager.sharedInstance.sendCompletedLine(line: line)
    }
    
    /**
     Processes a new Segment, and then sends it to the Canvas to be drawn.
     
     - parameter segment: The Segment to be sent to the Canvas.
     */
    func receiveNewSegment(segment: Segment) {
        segment.color = (self.drawModel?.lineManager.getColorFromId(id: segment.lineId))!
        self.drawModel?.lineManager.addSegmentToLine(segment: segment)
        self.canvas?.drawLineFromSegment(segment: segment)
    }
    
    /**
     Processes a new Line.
     */
    func receiveNewLine(line: Line) {
        self.drawModel?.lineManager.addLine(line: line)
    }
    
    func receiveNewLines(lines: [Line]) {
        for line in lines {
            self.drawModel?.lineManager.addLine(line: line)
            for segment in line.segments {
                segment.color = line.color
                self.canvas?.drawLineFromSegment(segment: segment)
            }
        }
    }
    
    /**
     It takes in a the new hex value set by the user, and passes it to the DrawModel.
     
     - parameter hex: The hex String representing the color.
     */
    func setColor(hex: String) {
        self.drawModel?.setColor(hex: hex)
    }
    
    /**
     Tells the Canvas that the eraser button has been pressed by the user.
     */
    func eraserPressed() {
        self.canvas?.eraserPressed()
    }
    
    /**
     Tells the Canvas that the clear button has been pressed by the user.
     */
    func clearCanvas(emit: Bool) {
        self.canvas?.clear()
        self.drawModel?.clearLocalLines()
        if emit {
            SocketIOManager.sharedInstance.emitClearCanvas()
        }
    }
    
    func updateThickness(thickness: Float) {
        self.drawModel?.thickness = CGFloat(thickness)
    }
    
}
