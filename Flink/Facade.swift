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
    /* **************************************************************************************************
    **
    **  MARK: Instance variables
    **
    ****************************************************************************************************/
    
    // Usado somente quando construindo o usuário
    // Para quando o usuário já esta cadastrado, usar appUser
    var isTrainer: Bool?
   
    // Usuário do aplicativo
    private(set) var appUser: User
    
    
    /* **************************************************************************************************
    **
    **  MARK: Instance methods
    **
    ****************************************************************************************************/

    func saveUser (user: User)
    {
        appUser = user
        // TODO: Salvar na plist
    }
    
    
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
        // TODO: Ler appUser da pList
        appUser = User(name: "", email: "", sex: "", birthDate: NSDate(), isTrainer: false)
    }
}