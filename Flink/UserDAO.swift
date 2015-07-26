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
        // TODO: Ler de NSUserDefaults e se não tiver nada, retornar nil
        return nil
    }
    
    class func save (user: User)
    {
        // TODO: Salvar em NSUserDefaults
    }
}