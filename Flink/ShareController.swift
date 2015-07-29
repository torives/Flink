//
//  ShareController.swift
//  Flink
//
//  Created by Renan Almeida on 7/27/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ShareController: UITableViewController, MPCManagerDelegate
{
    /***************************************************************************************************
    **
    **  MARK: Public
    **
    ****************************************************************************************************/

    override func viewDidLoad ()
    {
        foundTrainerList = [User]()
        
        let message = "Warning! Insert really important message here"
        
        MPCManager.instance.configureMPCManagerWith(Facade.instance.appUser.name,
                                                    defaultInvitationMessage: message,
                                                    andDelegate: self)
        
        //MPCManager.instance.startAdvertisingPeer()
        MPCManager.instance.startBrowsingForPeers()
    }
    
    
    override func viewWillDisappear(animated: Bool)
    {
        MPCManager.instance.disconnectFromCurrentSession()
        MPCManager.instance.stopAdversingPeer()
        MPCManager.instance.stopBrowsingForPeers()
    }
    
    /***************************************************************************************************
    **
    **  MARK: Private variables
    **
    ****************************************************************************************************/

    var foundTrainerList: [User]!

    
    /***************************************************************************************************
    **
    **  MARK: MPCManager Delegate
    **
    ****************************************************************************************************/
    
    func mpcManagerDidFoundPeerWithDiscoveryInfo(info: [NSObject : AnyObject]!)
    {
    
        let userName = info["userName"] as! String
        let userSex = info["userSex"] as! String
        
        let newTrainer = User(name: userName, email: nil, sex: userSex, birthDate: nil, isTrainer: true)
        foundTrainerList.append(newTrainer)
        
        self.tableView.reloadData()
    }
    
    
    //tem que conferir o caso de ter perdido a conexao com um ja conectado
    //ou um nao conectado ter saido de alcance
    func mpcManagerDidLostPeerNamed(peerName: String)
    {
        for var i=0; i < foundTrainerList.count; i++
        {
            if foundTrainerList[i].name == peerName
            {
                foundTrainerList.removeAtIndex(i)
                break
            }
        }
        self.tableView.reloadData()
    }
    
    func mpcManagerReceivedConnectionInvitation(alertController: UIAlertController)
    {
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    //tem que conferir o caso de ter perdido a conexao com um ja conectado
    //ou um nao conectado ter saido de alcance
    func mpcManagerPeerDidChangedState(peerInfo: Dictionary<String,NSObject>)
    {
        let peerID = peerInfo["peerID"] as! MCPeerID
        let peerDisplayName = peerID.displayName
        
        let state = MCSessionState(rawValue: peerInfo["state"] as! Int)!
        
        switch (state)
        {
            case .Connecting:
                println("Establishing connection with peer named \(peerID.displayName)")

            case .Connected:
                println("Established connection with peer named \(peerID.displayName)")
            case .NotConnected:
                
                println("Disconnected from peer named \(peerID.displayName)")
                
                for var i=0; i < foundTrainerList.count; i++
                {
                    if foundTrainerList[i].name == peerDisplayName
                    {
                        foundTrainerList.removeAtIndex(i)
                        break
                    }
                }
        }
        self.tableView.reloadData()
    }
    
    
    /***************************************************************************************************
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
        return foundTrainerList.count
    }
    
    override func tableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier = "ShareCell"
        
        var cell: ShareTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ShareTableViewCell
        
        if (cell == nil) {
            cell = ShareTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        let trainer = foundTrainerList[indexPath.row]
        
        cell.trainerName.text = trainer.name
        
        return cell
    }
    
    
    /***************************************************************************************************
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
