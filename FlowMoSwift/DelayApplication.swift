//
//  DelayApplication.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 2/8/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit
import Foundation

private let g_secs = 5.0

class DelayApplication: UIApplication
{
    var idle_timer : dispatch_cancelable_closure?
    
    override init()
    {
        super.init()
        reset_idle_timer()
    }
    
//    override func sendEvent( event: UIEvent )
//    {
//        super.sendEvent( event )
//        
//        if let allTouches = event.allTouches() {
//            if ( allTouches.count > 0 ) {
//                let phase = (allTouches.anyObject() as UITouch).phase
//                if phase == UITouchPhase.Began {
//                    reset_idle_timer()
//                }
//            }
//        }
//    }
    
    private func reset_idle_timer()
    {
        cancel_delay( idle_timer )
        idle_timer = delay( g_secs ) { self.idle_timer_exceeded() }
    }
    
    func idle_timer_exceeded()
    {
        //print( "Ring ----------------------- Do some Idle Work!" )
        reset_idle_timer()
    }
}