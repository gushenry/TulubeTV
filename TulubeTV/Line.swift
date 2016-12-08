//
//  Line.swift
//  Tulube
//
//  Created by James Ormond on 10/27/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation
import UIKit

/**
 This class represents a Line on the Canvas. It contains an array of the Segments
 that make up the line, the color of the line, and the id of the Board it belongs
 to.
 */
class Line {
    
    /**
     The id of this Line.
     */
    var _id : String
    
    /**
     The array of Segments composing this Line.
     */
    var segments = [Segment]()
    
    /**
     The color of the Line, represented by a hex String.
     */
    var color : String = "#000000"
    
    /**
     The id of the Board this Line belongs to.
     */
    var boardId : Int = 0
    
    var username : String = ""
    
    init() {
        self._id = Mongo.MongoObjectId()
    }
    
    /**
     Takes a Segment and adds it to *segments*.
     
     - parameter segment: The Segment to be added to this Line.
     */
    func addSegment(segment: Segment) {
        self.segments.append(segment)
    }
    
}
