//
//  StudentsController.swift
//  Flink
//
//  Created by Renan Almeida on 7/26/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import UIKit

class StudentsController: UITableViewController
{
    /* **************************************************************************************************
    **
    **  MARK: Public
    **
    ****************************************************************************************************/
    
    override func viewDidLoad ()
    {
        // TODO: Get from DAO
        studentList = [User]()
        studentList.append(User(name: "Renan Student", email: "", sex: "", birthDate: NSDate(), isTrainer: false))
        studentList.append(User(name: "Alena Student", email: "", sex: "", birthDate: NSDate(), isTrainer: false))
        studentList.append(User(name: "Gus Student", email: "", sex: "", birthDate: NSDate(), isTrainer: false))
        studentList.append(User(name: "Carol Student", email: "", sex: "", birthDate: NSDate(), isTrainer: false))
    }
    
    
    /* **************************************************************************************************
    **
    **  MARK: Private variables
    **
    ****************************************************************************************************/
    
    var studentList: [User]!
    
    
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
        return studentList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier = "ShareCell"
        
        var cell: StudentsTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? StudentsTableViewCell
        
        if (cell == nil) {
            cell = StudentsTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        let trainer = studentList[indexPath.row]
        
//        cell.trainerName.text = trainer.name
        
        return cell
    }
}

class StudentsTableViewCell: UITableViewCell
{
    
}


