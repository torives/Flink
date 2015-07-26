//
//  ViewController.swift
//  Flink
//
//  Created by Renan Almeida on 7/26/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController
{
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    
    override func viewWillAppear(animated: Bool)
    {
        let text = (Facade.instance.isTrainer == true) ? "Trainer" : "User"
        titleLabel.text = "\(text) registration"
    }
    

    @IBAction func registerButtonAction (sender: UIButton)
    {
        // TODO: Save appUser using Facade
    }
}

