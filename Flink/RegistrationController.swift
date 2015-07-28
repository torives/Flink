//
//  ViewController.swift
//  Flink
//
//  Created by Renan Almeida on 7/26/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var titleLabel: UILabel!


    @IBOutlet weak var firstNameTextField: UITextField!

    @IBOutlet weak var lastNameTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var genderTextField: UITextField!


    override func viewWillAppear (animated: Bool)
    {
        let text = (Facade.instance.isTrainer == true) ? "Trainer" : "User"
        titleLabel.text = "\(text) registration"
    }


    @IBAction func registerButtonAction (sender: UIButton)
    {
        let name = "\(firstNameTextField.text) \(lastNameTextField.text)"
        let email = emailTextField.text
        
        // TODO: let sex = genderTextField.text
        let sex = Sex.Male
        
        let birthDate = NSDate() // TODO: Gabriel
        let isTrainer = Facade.instance.isTrainer!

        let user = User(name: name, email: email, sex: sex, birthDate: birthDate, isTrainer: isTrainer)
        Facade.instance.saveUser(user)
        
        if (isTrainer) {
            performSegueWithIdentifier("toStudents", sender: nil)
        } else {
            performSegueWithIdentifier("toShare", sender: nil)
        }
    }


    /* **************************************************************************************************
    **
    **  MARK: UITextField Delegate
    **
    ****************************************************************************************************/

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}


