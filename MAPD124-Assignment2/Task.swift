//
//  Task.swift
//  MAPD124-Assignment2
//
//  Created by Shelalaine Chan on 2017-02-07.
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
