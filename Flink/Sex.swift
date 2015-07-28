//
//  Sex.swift
//  Flink
//
//  Created by Renan Almeida on 7/28/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import Foundation

enum Sex
{
    case Male
    case Female
    case Other
    
    var description: String {
        switch (self) {
            case .Male:
                return "Male"
            case .Female:
                return "Female"
            case .Other:
                return "Other"
        }
    }
}