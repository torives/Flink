//
//  User.swift
//  Flink
//
//  Created by Renan Almeida on 7/26/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import Foundation

class User
{
    /* **************************************************************************************************
    **
    **  MARK: Instance variables
    **
    ****************************************************************************************************/
    
    let name: String
    
    let email: String?
    
    let sex: Sex
    
    let birthDate: NSDate?
    
    let isTrainer: Bool
    
    
    /* **************************************************************************************************
    **
    **  MARK: Instance methods
    **
    ****************************************************************************************************/
    
    /// Default constructor
    init (name: String, email: String?, sex: Sex, birthDate: NSDate?, isTrainer: Bool)
    {
        self.name = name
        self.email = email
        self.sex = sex
        self.birthDate = birthDate
        self.isTrainer = isTrainer
    }
}


