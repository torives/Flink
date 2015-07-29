//
//  InfoController.swift
//  Flink
//
//  Created by Renan Almeida on 7/29/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import UIKit

class InfoController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    /* **************************************************************************************************
    **
    **  MARK: UIViewController
    **
    ****************************************************************************************************/

    override func viewDidLoad ()
    {
        // Set Status Bar White
        self.setNeedsStatusBarAppearanceUpdate()
        
        healthInformationList = ["Body Fat", "Lean Body Mass", "Body Mass", "Heart Rate",
            "Active Energy Burned", "Distance Cycling", "Flights Climbed", "Step Count",
            "Distance Running"]
    }
    
    override func preferredStatusBarStyle () -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }


    /* **************************************************************************************************
    **
    **  MARK: Public
    **
    ****************************************************************************************************/
    
    var healthInformationList: [String]!
    
    
    /* **************************************************************************************************
    **
    **  MARK: Actions
    **
    ****************************************************************************************************/

    @IBAction func backButtonAction (sender: UIButton)
    {
        performSegueWithIdentifier("fromInfoToStudents", sender: nil)
    }
    
    
    /* **************************************************************************************************
    **
    **  MARK: UITableView Data Source
    **
    ****************************************************************************************************/
    
    func numberOfSectionsInTableView (tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return healthInformationList.count
    }
    
    func tableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier = "HealthInformationCell"
        
        var cell: HealthInfoTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? HealthInfoTableViewCell
        
        if (cell == nil) {
            cell = HealthInfoTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        let healthInformation = healthInformationList[indexPath.row]
        cell.healthInformationName.text = healthInformation
        cell.healthInformationImage.image = UIImage(named: healthInformation)
        
        return cell
    }
    
    
    /* **************************************************************************************************
    **
    **  MARK: TableView Delegate
    **
    ****************************************************************************************************/
    
    func tableView (tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        performSegueWithIdentifier("fromInfoToDetail", sender: nil)
    }
}

class HealthInfoTableViewCell: UITableViewCell
{
    @IBOutlet weak var healthInformationName: UILabel!
    
    @IBOutlet weak var healthInformationImage: UIImageView!
}


