//
//  LoadhealthVC.swift
//  Flink
//
//  Created by Joao Pedro Brandao on 7/29/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import UIKit
import HealthKit

class LoadhealthVC: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    var kl:Bool = true
    @IBAction func load(sender: AnyObject)
    {
        if kl
        {
            HealthDAO.loadHealthData(NSDate.distantPast() as! NSDate, endDate: NSDate())
            
            kl = false
            println("printei os dados")
        }
        else
        {
            performSegueWithIdentifier("graphit", sender: nil)
        }
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var viewController = segue.destinationViewController as! GraphVCTest
        viewController.identifier = HKQuantityTypeIdentifierBodyFatPercentage
        //viewController.identifier = HKQuantityTypeIdentifierLeanBodyMass
        //viewController.identifier = HKQuantityTypeIdentifierBodyMass
        //viewController.identifier = HKQuantityTypeIdentifierHeight
        //viewController.identifier = HKQuantityTypeIdentifierHeartRate
        //viewController.identifier = HKQuantityTypeIdentifierActiveEnergyBurned
        //viewController.identifier = HKQuantityTypeIdentifierDistanceCycling
        //viewController.identifier = HKQuantityTypeIdentifierFlightsClimbed
        //viewController.identifier = HKQuantityTypeIdentifierStepCount
        //viewController.identifier = HKQuantityTypeIdentifierDistanceWalkingRunning
        
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
