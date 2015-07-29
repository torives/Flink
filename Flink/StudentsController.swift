//
//  StudentsController.swift
//  Flink
//
//  Created by Renan Almeida on 7/26/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import UIKit

class StudentsController: UIViewController, UITableViewDataSource, UITableViewDelegate, MPCManagerDelegate
{
    /***************************************************************************************************
    **
    **  MARK: UIViewController
    **
    ****************************************************************************************************/
    
    override func viewDidLoad ()
    {
        // Set Status Bar White
        self.setNeedsStatusBarAppearanceUpdate()
        
        // TODO: Get from DAO
        studentList = [User]()
        
        MPCManager.instance.configureMPCManagerWith(Facade.instance.appUser.name, defaultInvitationMessage: "", andDelegate: self)
        MPCManager.instance.startAdvertisingPeer()
        //MPCManager.instance.startBrowsingForPeers()
        
//        studentList.append(User(name: "Renan Student", email: "", sex: "", birthDate: NSDate(), isTrainer: false))
//        studentList.append(User(name: "Alena Student", email: "", sex: "", birthDate: NSDate(), isTrainer: false))
//        studentList.append(User(name: "Gus Student", email: "", sex: "", birthDate: NSDate(), isTrainer: false))
//        studentList.append(User(name: "Carol Student", email: "", sex: "", birthDate: NSDate(), isTrainer: false))
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        MPCManager.instance.disconnectFromCurrentSession()
        MPCManager.instance.stopAdversingPeer()
        MPCManager.instance.stopBrowsingForPeers()
    }
    
    
    override func preferredStatusBarStyle () -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }


    /* **************************************************************************************************
    **
    **  MARK: Private variables
    **
    ****************************************************************************************************/
    
    private var studentList: [User]!
    
    
    /***************************************************************************************************
    **
    **  MARK: MPCManager Delegate
    **
    ****************************************************************************************************/
    
    func mpcManagerPeerDidChangedState(peerInfo: Dictionary<String,NSObject>)
    {
        
    }
    func mpcManagerDidFoundPeerWithDiscoveryInfo(info: [NSObject : AnyObject]!)
    {
        
    }
    
    func mpcManagerDidLostPeerNamed(peerName: String)
    {
        
    }
    
    func mpcManagerReceivedConnectionInvitation(alertController: UIAlertController)
    {
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    /***************************************************************************************************
    **
    **  MARK: TableView Data Source
    **
    ****************************************************************************************************/
    
    func numberOfSectionsInTableView (tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return studentList.count
    }
    
    func tableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier = "StudentsCell"
        
        var cell: StudentsTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? StudentsTableViewCell
        
        if (cell == nil) {
            cell = StudentsTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        let student = studentList[indexPath.row]
        
        cell.studentName.text = student.name
        cell.studentImage.image = UIImage(named: "Student-\(student.sex.description)")
        
        return cell
    }
    
    
    /* **************************************************************************************************
    **
    **  MARK: TableView Delegate
    **
    ****************************************************************************************************/
    
    func tableView (tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return CGFloat(70)
    }
    
    func tableView (tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let student = studentList[indexPath.row]
        Facade.instance.currentStudent = student
        performSegueWithIdentifier("toInfo", sender: nil)
    }
}


class StudentsTableViewCell: UITableViewCell
{
    @IBOutlet weak var studentName: UILabel!
    
    @IBOutlet weak var studentImage: UIImageView!
}


