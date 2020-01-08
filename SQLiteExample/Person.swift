//
//  Person.swift
//  SQLiteExample
//
//  Created by Apple Guru on 2/1/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import Foundation

struct Person {
    var name: String = ""
    var age: Int = 0
    var id: Int = 0
    
    init(id:Int, name:String, age:Int)
    {
        self.id = id
        self.name = name
        self.age = age
    }
}
