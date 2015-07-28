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

    override func viewDidLoad()
    {
        super.viewDidLoad()
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
        
    }

    override func viewWillAppear (animated: Bool)
    {
        let text = (Facade.instance.isTrainer == true) ? "Trainer" : "User"
        titleLabel.text = "\(text) registration"
    }


    @IBAction func registerButtonAction (sender: UIButton)
    {
        let name = "\(firstNameTextField.text) \(lastNameTextField.text)"
        let email = emailTextField.text
        let sex = genderTextField.text
        let birthDate = NSDate() // TODO: Gabriel
        let isTrainer = Facade.instance.isTrainer!

        let user = User(name: name, email: email, sex: sex, birthDate: birthDate, isTrainer: isTrainer)
        Facade.instance.saveUser(user)
        
        if (isTrainer) {
            performSegueWithIdentifier("toStudents", sender: nil)
        } else {
            performSegueWithIdentifier("toShare", sender: nil)
        }
        
        
        // mini teste para verficar se os dados estao sendo puxados
//        var hdata = HealthDAO.loadHealthData(NSDate.distantPast() as! NSDate, endDate: NSDate())
//        println("printei os dados")
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


