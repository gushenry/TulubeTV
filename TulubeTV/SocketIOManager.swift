//
//  SocketIOManager.swift
//  Tulube
//
//  Created by James Ormond on 10/24/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

/**
 This class manages the web sockets. It is used as the connection
 between the client (this iOS device) and the server. All communication
 is handled here.
 */
class SocketIOManager: NSObject {
    /**
     The shared instance is the instance of SocketIOManager that we use in the app.
     */
    static let sharedInstance = SocketIOManager()
    
    /**
     The socket represents the web socket for communication between this client and the server.
     It takes in the URL of the server.
     */
    var socket : SocketIOClient = SocketIOClient(socketURL: NSURL(string: "https://tulube.herokuapp.com")! as URL)
//    var socket : SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://localhost:8080")! as URL)
  
    var drawViewController: DrawViewController? = nil
  
    /**
     Initiates the SocketIOManger object. In this function, the class establishes which functions
     need to be called depending on which messeges are received from the server.
     */
    override init() {
        print("init")
        super.init()
        socket.on("getAllLines") {
            data in
            print("got all lines")
            self.newLines(data: data.0)
        }
        socket.on("newClientSegment") {
            data in
            self.newSegment(data: data.0)
        }
        socket.on("newClientEmptyLine") {
            data in
            self.newEmptyLine(data: data.0)
        }
        socket.on("serverToClientNewLine") {
            data in
            self.newLine(data: data.0)
        }
        socket.on("clearCanvas") {
            _ in
            self.clearCanvas()
        }
        socket.on("deviceCode") {
            data in
            self.displayDeviceCode(data: data.0)
        }
    }
    
    /**
     Establishes the connection to the server by calling server.connect().
     */
    func establishConnection() {
        socket.connect()
    }
    
    /**
     Closes the connection to the server by calling socket.disconnect().
     */
    func closeConnection() {
        socket.disconnect()
    }
    
    /**
     Sends a Line from the client (this iOS device) to the server.
     
     - parameter line: The Line object to be sent.
     */
    func sendEmptyLine(line: Line) {
        let data : [String : Any] = [
            "_id": line._id,
            "color": line.color,
            "boardId": line.boardId,
            "username": line.username
        ]
        socket.emit("newServerEmptyLine", data)
    }
    
    func convertSegmentToDictionary(segment: Segment) -> [String : Any] {
        let data : [String : Any] = [
            "lineId": segment.lineId,
            "startX": segment.startX!,
            "startY": segment.startY!,
            "endX": segment.endX!,
            "endY": segment.endY!,
            "thickness": segment.thickness
        ]
        return data
    }
    
    func sendCompletedLine(line: Line) {
        var segments = [[String : Any]]()
        for segment in line.segments {
            segments.append(self.convertSegmentToDictionary(segment: segment))
        }
        let data : [String : Any] = [
            "_id": line._id,
            "segments": segments,
            "color": line.color,
            "boardId": line.boardId,
            "username": line.username
        ]
        
        socket.emit("newServerLine", data)
    }
    
    /**
     Sends a Segment from the client (this iOS device) to the server.
     
     - parameter segment: The Segment object to be sent.
     */
    func sendSegment(segment: Segment) {
        let data = self.convertSegmentToDictionary(segment: segment)
        socket.emit("newServerSegment", data)
    }
    
    /**
     This function is the callback for when the server pushes a Segment to the client
     (this iOS device). The data is converted to a Segment, and then sent to the DrawManager
     for handling.
     
     - parameter data: The data received from the server, assumed to be data that can be
     converted into a Segment object.
     */
    func newSegment(data: [Any]) {
        // extract the segment from the data
        let segment = self.convertDataToSegment(data: data[0] as! NSDictionary)
        
        // send the segment to the DrawModel
        DrawManager.sharedInstance.receiveNewSegment(segment: segment)
    }
    
    func newLines(data: [Any]) {
        let lines = self.convertDataToLines(data: data[0] as! [NSDictionary])
        DrawManager.sharedInstance.receiveNewLines(lines: lines)
    }
    
    /**
     This function is the callback for when the server pushes a Line to the client
     (this iOS device). The data is converted to a Line, and then sent to the DrawManager
     for handling.
     
     - parameter data: The data received from the server, assumed to be data that can be
     converted into a Line object.
     */
    func newLine(data: [Any]) {
        //        // extract the line from the data
        //        let line = data[0] as! Line
        //
        //        // extract the segment from the data
        //        if let segment = line.segments.first {
        //            DrawModel.sharedInstance.addSegment(segment: segment)
        //        }
        //
        //        // save the line locally
    }
    
    func newEmptyLine(data: [Any]) {
        let line = self.convertDataToEmptyLine(data: data[0] as! NSDictionary)
        DrawManager.sharedInstance.receiveNewLine(line: line)
    }
    
    /**
     Takes an NSDictionary representing the data needed for a Segment, extracts the data,
     and then creates and returns a Segment object.
     
     - parameter data: An NSDictionary containing the data needed to create a Seegment.
     
     - returns: A new Segment from the data received.
     */
    func convertDataToSegment(data: NSDictionary) -> Segment {
        let startX = data["startX"] as! CGFloat
        let startY = data["startY"] as! CGFloat
        let endX = data["endX"] as! CGFloat
        let endY = data["endY"] as! CGFloat
        let lineId = data["lineId"] as? String ?? "no_id"
        let thickness = data["thickness"] as! CGFloat
        let segment = Segment(lineId: lineId, thickness: thickness)
        segment.addStart(point: CGPoint(x: startX, y: startY))
        segment.addEnd(point: CGPoint(x: endX, y: endY))
        return segment
    }
    
    func convertDataToLine(data: NSDictionary) -> Line {
        let _id = data["_id"] as? String ?? Mongo.MongoObjectId()
        let color = data["color"] as? String ?? "000000"
        let boardId = data["boardId"] as? Int ?? 0
        let username = data["username"] as? String ?? ""
        var segments = [Segment]()
        if let segmentsData = data["segments"] as? [NSDictionary] {
            for segmentData in segmentsData {
                segments.append(self.convertDataToSegment(data: segmentData))
            }
        }
        let line = Line()
        line._id = _id
        line.segments = segments
        line.color = color
        line.boardId = boardId
        line.username = username
        return line
    }
    
    func convertDataToLines(data: [NSDictionary]) -> [Line] {
        var lines = [Line]()
        for lineData in data {
            lines.append(self.convertDataToLine(data: lineData))
        }
        return lines
    }
    
    func convertDataToEmptyLine(data: NSDictionary) -> Line {
        let _id = data["_id"] as? String ?? Mongo.MongoObjectId()
        let color = data["color"] as? String ?? "000000"
        let boardId = data["boardId"] as? Int ?? 0
        let username = data["username"] as? String ?? ""
        let line = Line()
        line._id = _id
        line.color = color
        line.boardId = boardId
        line.username = username
        return line
    }
    
    /**
     Tells the DrawManager to clear the current Canvas.
     */
    func clearCanvas() {
        DrawManager.sharedInstance.clearCanvas(emit: false)
    }
    
    func emitClearCanvas() {
        socket.emit("requestCanvasCleared")
    }
  
    func displayDeviceCode(data: [Any]) {
        var newData = data[0] as! NSDictionary
        drawViewController?.deviceCodeLabel.text = newData["_id"] as? String ?? "idk!!!"
    }
  
}
