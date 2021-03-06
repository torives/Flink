//
//  MPCManager.swift
//  Flink
//
//  Created by Victor Yves Crispim on 07/5/15.
//  Copyright (c) 2015 Flink. All rights reserved.
//

import MultipeerConnectivity

/**
 *
 *  MPCManager is a singleton responsible for handling the search
 *  and connection of different devices using the Flink app,
 *  besides receiving and transfering data between those devices.
 *
 *  The configureMPCManagerWith(displayName:andDelegate:) method
 *  should always be the first method to be called.
 *
*/
class MPCManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate
{
    
    //MARK: Singleton Pattern
    
    private static var singletonInstance: MPCManager!
    
    static var instance: MPCManager {
        
        if (singletonInstance == nil) {
            singletonInstance = MPCManager()
        }
        return singletonInstance
    }
    
    private override init()
    {
        super.init()
    }
    
    
    //MARK: Private attributes
    
    private var defaultInviteMessage: String?
    private let serviceTypeString = "flinkservice"
    private var delegate: MPCManagerDelegate?
    private var foundPeers = NSMutableSet()
    
    private var session: MCSession?
    private var peer: MCPeerID?
    private var browser: MCNearbyServiceBrowser?
    private var advertiser: MCNearbyServiceAdvertiser?
    
    
    //MARK: MCNearbyServiceBrowserDelegate methods
    
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!)
    {
        println("\(error)")
    }
    
    func browser(   browser: MCNearbyServiceBrowser!,
                    foundPeer peerID: MCPeerID!,
                    withDiscoveryInfo info: [NSObject : AnyObject]!)
    {
        
        let isTrainer = info["isTrainer"] as! String
        
        if isTrainer == "true" && !foundPeers.containsObject(peerID)
        {
            foundPeers.addObject(peerID)
            delegate?.mpcManagerDidFoundPeerWithDiscoveryInfo(info)
        }
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!)
    {
        let lostPeerName = peerID.displayName
        delegate?.mpcManagerDidLostPeerNamed(lostPeerName)

        foundPeers.removeObject(peerID)
    }
    
    
    //MARK: MCNearbyServiceAdvertiserDelegate methods
    
    func advertiser(    advertiser: MCNearbyServiceAdvertiser!,
                        didReceiveInvitationFromPeer peerID: MCPeerID!,
                        withContext context: NSData!,
                        invitationHandler: ((Bool, MCSession!) -> Void)!)
    {
        let alertController = UIAlertController(    title: "Atention!", message: defaultInviteMessage,
                                                    preferredStyle: UIAlertControllerStyle.Alert)
        
        let rejectAction = UIAlertAction(title: "Reject", style: .Destructive)
        { (action) in
            invitationHandler(false,nil)
        }

        let acceptAction = UIAlertAction(title: "Accept", style: .Default)
        { (action) in
            
            self.session = MCSession(peer:self.peer)
            self.session?.delegate = self
            
            invitationHandler(true,self.session)
        }

        alertController.addAction(acceptAction)
        alertController.addAction(rejectAction)
        
        delegate!.mpcManagerReceivedConnectionInvitation(alertController)
    }
    
    func advertiser(    advertiser: MCNearbyServiceAdvertiser!,
                        didNotStartAdvertisingPeer error: NSError!)
    {
        println("\(error)")
    }
    
    
    //MARK: MCSessionDelegate methods
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState)
    {
        var peerInfo: [String:NSObject] = ["peerID":peerID, "state":state.rawValue]
        delegate?.mpcManagerPeerDidChangedState(peerInfo)
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!)
    {
        let receivedData:AnyObject = NSKeyedUnarchiver.unarchiveObjectWithData(data) as AnyObject!
        let requestType = receivedData["request"] as! String
        
        switch(requestType)
        {
            //FIX-ME this case is never used because of current app logic
            case "HealthDataRequest":

                var healthData:String?

                if let data = healthData
                {
                    let message: [String:AnyObject] =   [   "request" : "HealthDataSent",
                                                            "data"    : data
                                                        ]
                    var host = [peerID]
                    sendData(message, toPeers: host)
                }

            case "HealthDataSent":
                println("Received health data from \(peerID.displayName)")
            
                let jsonString = receivedData["data"] as! String
            
                let healthData = JSONService.convertStringToHealthDataArray(jsonString)
            
                //TODO store received healthData
            
            default:
                println("Incompatible request type")
        }
    }
    
    //Methods to handle file and data stream transfer. Not used, but needed
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) { }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) { }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) { }
    
    
    //MARK: Custom methods
    
    /**
     *
     *  Creates all the objects necessary to the MPC Framework
     *  and performs the initial setup
     *
     *  :param: displayName The name that will be displayed to others
     *                      when searching for connections. Can't be
     *                      changed without destroying the actual session
     *
     *  :param: delegate    The object responsible for handling new events
     *                      generated by the MPCManager
     *
     *  :param: message     The message to be displayed to an invited peer
    */
    func configureMPCManagerWith(   displayName: String,
                                    defaultInvitationMessage message: String,
                                    andDelegate delegate: MPCManagerDelegate?)
    {
        peer = MCPeerID(displayName: displayName)
        defaultInviteMessage = message
        
        setupBrowser()
        setupAdvertiser()
        
        self.delegate = delegate
    }
    
    
    /**
     *
     *  Sends a connection invitation to the designated peer
     *
     *  :param: peerDisplayName  The name of the peer who will receive
     *                           the invitation
    */
    func connectToPeerNamed(peerDisplayName: String)
    {
        session = MCSession(peer: peer)
        session?.delegate = self
        
        for (index,guestPeer) in enumerate(foundPeers)
        {
            if (guestPeer as! MCPeerID).displayName == peerDisplayName
            {
                browser?.invitePeer(guestPeer as! MCPeerID, toSession: self.session, withContext: nil, timeout: 30.0)
                return
            }
        }
        
        println("peer \(peerDisplayName) was not found")
    }
    
    
    func sendHealthData(dataToSend: [HealthData])
    {
     
        let healthData: [String:AnyObject] =    [   "request":"HealthDataSent",
                                                    "data"   :JSONService.stringfyHealthDataArray(dataToSend)
                                                ]
        
        sendData(healthData, toPeers: session?.connectedPeers as! [MCPeerID])
    }
 
    func disconnectFromCurrentSession()
    {
        session!.disconnect()
    }
    
    func startBrowsingForPeers()
    {
        self.browser?.startBrowsingForPeers()
    }
    
    func stopBrowsingForPeers()
    {
        browser?.stopBrowsingForPeers()
    }
    
    func startAdvertisingPeer()
    {
        advertiser?.startAdvertisingPeer()
    }
    
    func stopAdversingPeer()
    {
        advertiser?.stopAdvertisingPeer();
    }
    

    //MARK: Private Methods
    
    private func sendData(data: Dictionary<String,AnyObject>, toPeers peers: [MCPeerID!]) -> Bool{
        
        let dataToSend = NSKeyedArchiver.archivedDataWithRootObject(data)
        var error: NSError?
        
        if !session!.sendData(  dataToSend,
                                toPeers: peers,
                                withMode: MCSessionSendDataMode.Reliable,
                                error: &error)
        {
            println("\(error)")
            return false
        }
        return true
    }
    
    func setupBrowser()
    {
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceTypeString)
        browser?.delegate = self
    }
    
    func setupAdvertiser()
    {
        var discoveryInfo = [String:AnyObject]()
        discoveryInfo["userName"] = Facade.instance.appUser.name
        discoveryInfo["userSex"] = Facade.instance.appUser.sex.description
        discoveryInfo["isTrainer"] = Facade.instance.appUser.isTrainer.description
        
        advertiser = MCNearbyServiceAdvertiser( peer: peer, discoveryInfo: discoveryInfo,
                                                serviceType: serviceTypeString)
        advertiser?.delegate = self
    }
}