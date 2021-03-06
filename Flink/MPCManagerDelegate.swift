//
//  MPCManagerDelegate.swift
//  Flink
//
//  Created by Victor Yves Crispim on 07/5/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import MultipeerConnectivity

protocol MPCManagerDelegate
{
    func mpcManagerPeerDidChangedState(peerInfo: Dictionary<String,NSObject>)
    
    func mpcManagerDidFoundPeerWithDiscoveryInfo(info: [NSObject : AnyObject]!)
    
    func mpcManagerDidLostPeerNamed(peerName: String)
    
    func mpcManagerReceivedConnectionInvitation(alertController: UIAlertController)
    
    //FIX-ME
    //func mpcManagerReceivedHealthData(healthData: [HealthData])
}