//
//  Facade.swift
//  Flink
//
//  Created by Renan Almeida on 7/26/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import Foundation

// Singleton
class Facade
{
    var isTrainer: Bool!
   
    
    /* **************************************************************************************************
    **
    **  MARK: Singleton Pattern
    **
    ****************************************************************************************************/

    static var instance: Facade {
        if (singletonInstance == nil) {
            singletonInstance = Facade()
        }
        return singletonInstance
    }
    
    private static var singletonInstance: Facade!
    
    private init ()
    {
        
    }
}