//
//  File Name:      Task.swift
//  Project Name:   MAPD124-Assignment2
//  Description:    This is the Task class
//
//  Created by:     Shelalaine Chan
//  Student ID:     300924281
//  Change History: 2017-02-07, Created
//                  2017-02-20, Added unique identifier
//
//  Copyright © 2017 ShelalaineChan. All rights reserved.
//

import Foundation

class Task {
    var id: Int?
    var name: String
    var notes: String
    var onGoing: Bool
    
    init(name: String, id:Int?, _ notes: String, _ onGoing: Bool) {
        self.id = id
        self.name = name
        self.notes = notes
        self.onGoing = onGoing
    }
}
