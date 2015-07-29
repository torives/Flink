//
//  ShareController.swift
//  Flink
//
//  Created by Renan Almeida on 7/27/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import UIKit

class ShareController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    /* **************************************************************************************************
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
        
        // TODO: Get from DAO
        trainerList = [User]()
        trainerList.append(User(name: "Renan", email: "", sex: .Male, birthDate: NSDate(), isTrainer: true))
        trainerList.append(User(name: "Alena", email: "", sex: .Female, birthDate: NSDate(), isTrainer: true))
        trainerList.append(User(name: "Gus", email: "", sex: .Female, birthDate: NSDate(), isTrainer: true))
        trainerList.append(User(name: "Carol", email: "", sex: .Female, birthDate: NSDate(), isTrainer: true))
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
    var trainerList: [User]!

    
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
        return trainerList.count
    }
    
    func tableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier = "ShareCell"
        
        var cell: ShareTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ShareTableViewCell
        
        if (cell == nil) {
            cell = ShareTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        let trainer = trainerList[indexPath.row]
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


