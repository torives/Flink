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
    **  MARK: TableView Data Source
    **
    ****************************************************************************************************/
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 0
    }
}
