//
//  ShareController.swift
//  Flink
//
//  Created by Renan Almeida on 7/27/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ShareController: UIViewController, UITableViewDataSource, UITableViewDelegate, MPCManagerDelegate
{
    /***************************************************************************************************
    **
    **  MARK: Interface
    **
    ****************************************************************************************************/
    
    @IBOutlet weak var connectionStatus: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var overlayView: UIView!
    
    
    /* **************************************************************************************************
    **
    **  MARK: UIViewController
    **
    ****************************************************************************************************/
    
    override func viewDidLoad ()
    {
        // Set Status Bar White
        self.setNeedsStatusBarAppearanceUpdate()
        
        var animationFrames = [UIImage]()
        for (var i = 1 ; i < 5 ; i++) {
            animationFrames.append(UIImage(named: "connection\(i)")!)
        }
        connectionStatus.animationImages = animationFrames
        connectionStatus.animationDuration = 1.5
        
        // TODO: Get from Yves
        isLookingForTrainers = false
        
        // Overlay View & Activity Indicator
        overlayView = UIView(frame: UIScreen.mainScreen().bounds)
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.center = view.center
        indicator.startAnimating()
        overlayView.addSubview(indicator)
        view.addSubview(overlayView)
        overlayView.hidden = true
        
        foundTrainerList = [User]()
        
        let message = "Warning! Insert really important message here"
        
        MPCManager.instance.configureMPCManagerWith(Facade.instance.appUser.name,
                                                    defaultInvitationMessage: message,
                                                    andDelegate: self)
        
        MPCManager.instance.startBrowsingForPeers()
    }
    
    override func preferredStatusBarStyle () -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        MPCManager.instance.disconnectFromCurrentSession()
        MPCManager.instance.stopAdversingPeer()
        MPCManager.instance.stopBrowsingForPeers()
    }
    
    /***************************************************************************************************
    **
    **  MARK: Public
    **
    ****************************************************************************************************/

    /// Mudar o valor dessa variável para indicar a pesquisa por treinadores
    var isLookingForTrainers: Bool! {
        didSet {
            if (isLookingForTrainers == true) {
                connectionStatus.startAnimating()
            } else {
                connectionStatus.stopAnimating()
            }
        }
    }
    
    var isSendingData: Bool = false {
        didSet {
            if (isSendingData) {
                overlayView.hidden = false
            } else {
                overlayView.hidden = true
                tableView.reloadData()
            }
        }
    }

    /// Lista de treinadores encontrados
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
    
    func numberOfSectionsInTableView (tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return foundTrainerList.count
    }
    
    func tableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier = "ShareCell"
        
        var cell: ShareTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ShareTableViewCell
        
        if (cell == nil) {
            cell = ShareTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        let trainer = foundTrainerList[indexPath.row]
        
        cell.trainerName.text = trainer.name
        cell.trainerImage.image = UIImage(named: "Trainer-\(trainer.sex.description)")
        
        return cell
    }


    /* **************************************************************************************************
    **
    **  MARK: UITableView Delegate
    **
    ****************************************************************************************************/
    
    func tableView (tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ShareTableViewCell
        let color = UIColor(red: 235/255.0, green: 184/255.0, blue: 49/255.0, alpha: 0.38)
        cell.contentView.backgroundColor = color
        cell.backgroundColor = color
    }

    func tableView (tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        isSendingData = true
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
}


class ShareTableViewCell: UITableViewCell
{
    @IBOutlet weak var trainerName: UILabel!
    
    @IBOutlet weak var trainerImage: UIImageView!
}


