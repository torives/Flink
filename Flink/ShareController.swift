//
//  ShareController.swift
//  Flink
//
//  Created by Renan Almeida on 7/27/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import UIKit

class ShareController: UITableViewController
{
    /* **************************************************************************************************
    **
    **  MARK: Public
    **
    ****************************************************************************************************/

    override func viewDidLoad ()
    {
        // TODO: Get from DAO
        trainerList = [User]()
        trainerList.append(User(name: "Renan", email: "", sex: "", birthDate: NSDate(), isTrainer: true))
        trainerList.append(User(name: "Alena", email: "", sex: "", birthDate: NSDate(), isTrainer: true))
        trainerList.append(User(name: "Gus", email: "", sex: "", birthDate: NSDate(), isTrainer: true))
        trainerList.append(User(name: "Carol", email: "", sex: "", birthDate: NSDate(), isTrainer: true))
    }
    
    
    /* **************************************************************************************************
    **
    **  MARK: Private variables
    **
    ****************************************************************************************************/

    var trainerList: [User]!

    
    /* **************************************************************************************************
    **
    **  MARK: TableView Data Source
    **
    ****************************************************************************************************/
    
    override func numberOfSectionsInTableView (tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return trainerList.count
    }
    
    override func tableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier = "ShareCell"
        
        var cell: ShareTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ShareTableViewCell
        
        if (cell == nil) {
            cell = ShareTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        let trainer = trainerList[indexPath.row]
        
        cell.trainerName.text = trainer.name
        
        return cell
    }
    
    
    /* **************************************************************************************************
    **
    **  MARK: TableView Delegate
    **
    ****************************************************************************************************/

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return CGFloat(70)
    }
}

class ShareTableViewCell: UITableViewCell
{
    @IBOutlet weak var trainerName: UILabel!
}
