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
    /* **************************************************************************************************
    **
    **  MARK: Interface
    **
    ****************************************************************************************************/

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var firstNameTextField: UITextField!

    @IBOutlet weak var lastNameTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var genderTextField: UITextField!

    
    /* **************************************************************************************************
    **
    **  MARK: UIViewController
    **
    ****************************************************************************************************/
    
    override func viewDidLoad ()
    {
        // Set Status Bar White
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillAppear (animated: Bool)
    {
        let text = (Facade.instance.isTrainer == true) ? "Trainer" : "User"
        titleLabel.text = "\(text) registration"
    }
    
    override func preferredStatusBarStyle () -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }


    /* **************************************************************************************************
    **
    **  MARK: Actions
    **
    ****************************************************************************************************/

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
        
        if (isTrainer)
        {
            performSegueWithIdentifier("toStudents", sender: nil)
        }
        else
        {
            
            HealthDAO.authorizeHealthKit { (authorized,  error) -> Void in
                if authorized
                {
                    println("HealthKit authorization received.")
                }
                else
                {
                    println("HealthKit authorization denied!")
                    if error != nil
                    {
                        println("\(error)")
                    }
                }
                println("Autorizei")
            }
            
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


