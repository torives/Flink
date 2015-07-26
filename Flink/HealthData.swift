//
//  HealthData.swift
//  Flink
//
//  Created by Joao Pedro Brandao on 7/26/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import Foundation

class HealthData
{
    var name:String
    //var category:Category
    var value:Double
    var unit:String
    var creationDate:NSDate
    
    init(name:String, value:Double, unit:String, creationDate:NSDate)
    {
        self.name = name
        self.value = value
        self.unit = unit
        self.creationDate = creationDate
    }
}