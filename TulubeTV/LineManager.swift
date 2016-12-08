//
//  LineManager.swift
//  Tulube
//
//  Created by James Ormond on 11/28/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation

class LineManager {
    
    var lines = [Line]()
    
    func addLine(line: Line) {
        self.lines.append(line)
    }
    
    func getLineFromId(id: String) -> Line? {
        for line in self.lines {
            if line._id == id {
                return line
            }
        }
        return nil
    }
    
    func getColorFromId(id: String) -> String {
        for line in self.lines {
            if line._id == id {
                return line.color
            }
        }
        return "000000"
    }
    
    func addSegmentToLine(segment: Segment) {
        for line in self.lines {
            if line._id == segment.lineId {
                line.addSegment(segment: segment)
            }
        }
    }
    
    func removeAllLines() {
        self.lines.removeAll()
    }
    
}
