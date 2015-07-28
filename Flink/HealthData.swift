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
    var startDate:NSDate
    var endDate:NSDate
    
    init(name:String, value:Double, unit:String, startDate:NSDate, endDate:NSDate)
    {
        self.name = name
        self.value = value
        self.unit = unit
        self.startDate = startDate
        self.endDate = endDate
    }
}