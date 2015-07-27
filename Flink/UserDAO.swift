//
//  UserDAO.swift
//  Flink
//
//  Created by Renan Almeida on 7/26/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import Foundation

/// Abstract class
class UserDAO
{
    /* **************************************************************************************************
    **
    **  MARK: Class methods
    **
    ****************************************************************************************************/
    
    class func read () -> User?
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let isTrainer = defaults.objectForKey("userIsTrainer") as? Bool {
            let name = defaults.objectForKey("userName") as! String
            let email = defaults.objectForKey("userEmail") as! String
            let sex = defaults.objectForKey("userSex") as! String
            let birthDate = defaults.objectForKey("userBirthDate") as! NSDate
            
            return User(name: name, email: email, sex: sex, birthDate: birthDate, isTrainer: isTrainer)
        }
        
        return nil
    }
    
    class func save (user: User)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(user.name, forKey: "userName")
        defaults.setObject(user.email, forKey: "userEmail")
        defaults.setObject(user.sex, forKey: "userSex")
        defaults.setObject(user.birthDate, forKey: "userBirthDate")
        defaults.setObject(user.isTrainer, forKey: "userIsTrainer")
    }
}