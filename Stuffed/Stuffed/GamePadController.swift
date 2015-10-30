//
//  GamePadController.swift
//  Stuffed
//
//  Created by Kelly Robinson on 10/27/15.
//  Copyright © 2015 Kelly Robinson. All rights reserved.
//

import UIKit

import MultipeerConnectivity



class GamePadController: UIViewController, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {
    
    var session: MCSession!
    var advertiser: MCNearbyServiceAdvertiser!
    var myPeerID: MCPeerID = MCPeerID(displayName: "Kelly")
    
    var boardID: MCPeerID?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        session = MCSession(peer: myPeerID)
        session.delegate = self
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: ["color":"orange"], serviceType: serviceType)
        advertiser.delegate = self

        advertiser.startAdvertisingPeer()
        
        
        
    }
    
    /////////////// ADVERTISER
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        
        print("Inviting Peer \(peerID.displayName)")
        
        if peerID.displayName == "Board" {
            
            boardID = peerID
            
            print(peerID)
            
            print("Accept Invite")
//            advertiser.stopAdvertisingPeer()
            invitationHandler(true, session)
            
        } else {
            
            print("Decline Invitation")
            invitationHandler(false, session)
            
        }
        
    }

    ///////////////////////
    /////////////////////// SESSION
    ///////////////////////
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        
        
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
        let states = ["Not Connected","Connecting","Connected"]
        
        let stateName = states[state.rawValue]
        
        print(peerID)
        
        print("\(peerID.displayName)" + stateName)
        print(session.connectedPeers)
        
        
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    //////////////// BUTTONS
    
    @IBAction func jump(sender: AnyObject) {
        
        sendData(GameData(action: .Jump))
        
    }
    
    
    @IBAction func left(sender: AnyObject) {
        
        sendData(GameData(action: .Move, direction: .Left))
        
               
    }
    
    
    @IBAction func fire(sender: AnyObject) {
        
        
        sendData(GameData(action: .Fire))
        
    }
    
    @IBAction func right(sender: AnyObject) {
        

        sendData(GameData(action: .Move, direction: .Right))
        
    
        
        //// NSJSONSerialization
        
//        if let data = try? NSJSONSerialization.dataWithJSONObject(info, options: .PrettyPrinted) {
//        
//        try? session.sendData(data, toPeers: session.connectedPeers, withMode: .Reliable)
//            
//        }
        
        
        
    }
    
    func sendData(gameData: GameData) {
        
        if let bID = boardID {
            
            do {
                
                
                try session.sendData(gameData.data, toPeers: [bID], withMode: .Reliable)
                
            } catch {
                
                print(error)
                
            }
            
            
        }
        
    }

  

  
    
}
