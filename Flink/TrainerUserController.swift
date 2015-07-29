//
//  TrainerUserController.swift
//  Flink
//
//  Created by Renan Almeida on 7/26/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import UIKit

class TrainerUserController: UIViewController
{
    override func viewDidLoad ()
    {
        // Set Status Bar White
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle () -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func choseUserButtonAction (sender: UIButton)
    {
        Facade.instance.isTrainer = false
    }

    @IBAction func choseTrainerButtonAction (sender: UIButton)
    {
        Facade.instance.isTrainer = true
    }
}
