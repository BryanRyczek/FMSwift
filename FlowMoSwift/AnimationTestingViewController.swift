////
////  AnimationTestingViewController.swift
////  FlowMoSwift
////
////  Created by Bryan Ryczek on 12/10/15.
////  Copyright © 2015 Bryan Ryczek. All rights reserved.
////
//
//import Foundation
//import UIKit
////import PermissionScope
//
//
//class AnimationTestingViewController: UIViewController {
////    let pscope = PermissionScope()
//    
//    override func viewDidLoad() {
//        let coloredSquare = UIView()
//        coloredSquare.backgroundColor = UIColor.blueColor()
//        coloredSquare.frame = CGRect(x: 0, y: 0, width: 0, height: 20)
//        self.view.addSubview(coloredSquare)
//        
//        UIView.animateWithDuration(3.0, animations: {
//            coloredSquare.backgroundColor = UIColor.redColor()
//            coloredSquare.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 20)
//            } , completion: { finished in
//             print("finished")
//        })
//        p()
//        //NSProgressIndicator()
//    }
//    
////    let permissions = PermissionScope()
//    
//    // MARK: SETUP METHODS
//    func p() {
//        
//        super.viewDidLoad()
//        
//        //Code to load Camera
//        let status = permissions.statusContacts()
//        print(status)
//        // Permissions
//        permissions.headerLabel.text = "So glad you made it!"
//        permissions.bodyLabel.text = "Lorem Ipsum"
//        permissions.addPermission(CameraPermission(),
//            message: "We steal your memories")
//        permissions.addPermission(MicrophonePermission(),
//            message: "We steal your voice")
//        permissions.addPermission(PhotosPermission(),
//            message: "We save your photos")
//        
//        permissions.show({ finished, results in
//            print("got results \(results)")
//            }, cancelled: { (results) -> Void in
//                print("thing was cancelled")
//        })
//        print(status)
//        
//        switch permissions.statusContacts() {
//        case .Unknown:
//            print("unkown")
//            return
//        case .Unauthorized, .Disabled:
//            print("Unauth")
//            return
//        case .Authorized:
//            print("Auth")
//            return
//        }
//        
//    }
//
//    
//    func NSProgressIndicator() {
//        pscope.addPermission(ContactsPermission(),
//            message: "We use this to steal\r\nyour friends")
//        pscope.addPermission(NotificationsPermission(notificationCategories: nil),
//            message: "We use this to send you\r\nspam and love notes")
//        pscope.addPermission(LocationWhileInUsePermission(),
//            message: "We use this to track\r\nwhere you live")
//        
//        // Show dialog with callbacks
//        pscope.show({ finished, results in
//            print("got results \(results)")
//            }, cancelled: { (results) -> Void in
//                print("thing was cancelled")
//        })   
//    }
//
//}
