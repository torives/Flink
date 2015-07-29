//
//  DetailController.swift
//  Flink
//
//  Created by Renan Almeida on 7/29/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import UIKit

class DetailController: UIViewController
{
    /* **************************************************************************************************
    **
    **  MARK: UIViewController
    **
    ****************************************************************************************************/
    
    @IBOutlet weak var detailLabel: UILabel!

    override func viewDidLoad ()
    {
        // Set Status Bar White
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle () -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
}
