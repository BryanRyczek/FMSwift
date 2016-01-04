//
//  FlowMoCam.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 12/7/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CoreMedia
//import PermissionScope

class FlowMoCam: FlowMoController {
    
//    let permissions = PermissionScope()
    
    // MARK: SETUP METHODS
    override func viewDidLoad() {

        super.viewDidLoad()
        
        cameraViewLoad()
        buttonsView()
        audioLoad()
        setupDoubleTapGesture()
        setupUpSwipeGesture()
        
        //Code to load Camera
//        let status = permissions.statusCamera()
//        print(status)
//        // Permissions
//        permissions.headerLabel.text = "So glad you made it!"
//        permissions.bodyLabel.text = "Lorem Ipsum"
//        permissions.addPermission(CameraPermission(),
//        message: "We steal your memories")
//        permissions.addPermission(MicrophonePermission(),
//        message: "We steal your voice")
//        permissions.addPermission(PhotosPermission(),
//        message: "We save your photos")
//        
//        permissions.show({ finished, results in
//            print("got results \(results)")
//            }, cancelled: { (results) -> Void in
//                print("thing was cancelled")
//        })
//        print(status)
//        
//        
//        switch permissions.statusCamera() {
//        case .Unknown:
//            print("Dunno")
//        case .Unauthorized, .Disabled:
//            return
//        case .Authorized:
//            cameraViewLoad()
//            buttonsView()
//            return
//        }
//        
//        switch permissions.statusMicrophone() {
//        case .Unknown:
//            print("Dunno")
//        case .Unauthorized, .Disabled:
//            return
//        case .Authorized:
//            audioLoad()
//            return
//        }
//        
  }
    
    // MARK: BUTTON METHODS
    func cameraViewLoad() {
        loadCamera()
        var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        captureSession.startRunning()
    }
    
    func audioLoad() {
        //Audio Recorder Setup
        loadAudio()
    }
    
    func buttonsView() {
        //Button Setup
        toggleTorchButton()
        captureButton()
        toggleCameraButton()
    }
    
    func setupUpSwipeGesture() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: "setTorchMode:")
        upSwipe.direction = .Up
        upSwipe.delaysTouchesBegan = true
        view.addGestureRecognizer(upSwipe)
    }
    
    func setupDoubleTapGesture() {
    let tap = UITapGestureRecognizer(target: self, action: "toggleCamera:")
    tap.numberOfTapsRequired = 2
    tap.delaysTouchesBegan = true
    view.addGestureRecognizer(tap)
    }
    

    func toggleTorchButton() {
        let toggleTorchButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        toggleTorchButton.frame = CGRectMake(70, (self.view.frame.height)-70, 70, 70)
        toggleTorchButton.backgroundColor = UIColor.whiteColor()
        toggleTorchButton.addTarget(self, action: "setTorchMode:", forControlEvents: .TouchUpInside)
       
        
        //// Color Declarations
        let white = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        var flashOffPath = UIBezierPath()
        flashOffPath.moveToPoint(CGPointMake(13.84, 25.33))
        flashOffPath.addCurveToPoint(CGPointMake(8.34, 25.33), controlPoint1: CGPointMake(11.96, 25.33), controlPoint2: CGPointMake(10.15, 25.33))
        flashOffPath.addCurveToPoint(CGPointMake(1.14, 25.34), controlPoint1: CGPointMake(5.94, 25.33), controlPoint2: CGPointMake(3.54, 25.33))
        flashOffPath.addCurveToPoint(CGPointMake(0.1, 24.89), controlPoint1: CGPointMake(0.72, 25.34), controlPoint2: CGPointMake(0.33, 25.31))
        flashOffPath.addCurveToPoint(CGPointMake(0.25, 23.79), controlPoint1: CGPointMake(-0.11, 24.49), controlPoint2: CGPointMake(0.04, 24.15))
        flashOffPath.addCurveToPoint(CGPointMake(10.63, 6.1), controlPoint1: CGPointMake(3.71, 17.9), controlPoint2: CGPointMake(7.17, 12))
        flashOffPath.addCurveToPoint(CGPointMake(13.91, 0.5), controlPoint1: CGPointMake(11.72, 4.23), controlPoint2: CGPointMake(12.82, 2.36))
        flashOffPath.addCurveToPoint(CGPointMake(14.76, 0), controlPoint1: CGPointMake(14.1, 0.16), controlPoint2: CGPointMake(14.37, -0.02))
        flashOffPath.addCurveToPoint(CGPointMake(15.49, 0.54), controlPoint1: CGPointMake(15.11, 0.02), controlPoint2: CGPointMake(15.37, 0.21))
        flashOffPath.addCurveToPoint(CGPointMake(15.55, 1.01), controlPoint1: CGPointMake(15.55, 0.69), controlPoint2: CGPointMake(15.55, 0.86))
        flashOffPath.addCurveToPoint(CGPointMake(15.56, 14.51), controlPoint1: CGPointMake(15.56, 5.51), controlPoint2: CGPointMake(15.56, 10.01))
        flashOffPath.addCurveToPoint(CGPointMake(15.56, 14.98), controlPoint1: CGPointMake(15.56, 14.66), controlPoint2: CGPointMake(15.56, 14.8))
        flashOffPath.addCurveToPoint(CGPointMake(18.08, 14.98), controlPoint1: CGPointMake(16.42, 14.98), controlPoint2: CGPointMake(17.25, 14.98))
        flashOffPath.addCurveToPoint(CGPointMake(29.1, 14.98), controlPoint1: CGPointMake(21.75, 14.98), controlPoint2: CGPointMake(25.42, 14.99))
        flashOffPath.addCurveToPoint(CGPointMake(30.05, 15.44), controlPoint1: CGPointMake(29.5, 14.98), controlPoint2: CGPointMake(29.85, 15.05))
        flashOffPath.addCurveToPoint(CGPointMake(29.93, 16.46), controlPoint1: CGPointMake(30.24, 15.8), controlPoint2: CGPointMake(30.14, 16.13))
        flashOffPath.addCurveToPoint(CGPointMake(15.53, 39.45), controlPoint1: CGPointMake(25.13, 24.12), controlPoint2: CGPointMake(20.33, 31.79))
        flashOffPath.addCurveToPoint(CGPointMake(14.46, 39.96), controlPoint1: CGPointMake(15.23, 39.92), controlPoint2: CGPointMake(14.89, 40.08))
        flashOffPath.addCurveToPoint(CGPointMake(13.84, 38.95), controlPoint1: CGPointMake(14.05, 39.85), controlPoint2: CGPointMake(13.84, 39.52))
        flashOffPath.addCurveToPoint(CGPointMake(13.84, 25.9), controlPoint1: CGPointMake(13.83, 34.6), controlPoint2: CGPointMake(13.84, 30.25))
        flashOffPath.addCurveToPoint(CGPointMake(13.84, 25.33), controlPoint1: CGPointMake(13.84, 25.73), controlPoint2: CGPointMake(13.84, 25.56))
        flashOffPath.closePath()
        flashOffPath.moveToPoint(CGPointMake(27.71, 16.74))
        flashOffPath.addCurveToPoint(CGPointMake(27.38, 16.72), controlPoint1: CGPointMake(27.54, 16.73), controlPoint2: CGPointMake(27.46, 16.72))
        flashOffPath.addCurveToPoint(CGPointMake(20.75, 16.72), controlPoint1: CGPointMake(25.17, 16.72), controlPoint2: CGPointMake(22.96, 16.72))
        flashOffPath.addCurveToPoint(CGPointMake(14.87, 16.72), controlPoint1: CGPointMake(18.79, 16.72), controlPoint2: CGPointMake(16.83, 16.72))
        flashOffPath.addCurveToPoint(CGPointMake(13.84, 15.69), controlPoint1: CGPointMake(14.15, 16.71), controlPoint2: CGPointMake(13.86, 16.42))
        flashOffPath.addCurveToPoint(CGPointMake(13.83, 15.28), controlPoint1: CGPointMake(13.83, 15.55), controlPoint2: CGPointMake(13.83, 15.42))
        flashOffPath.addCurveToPoint(CGPointMake(13.84, 4.61), controlPoint1: CGPointMake(13.83, 11.73), controlPoint2: CGPointMake(13.84, 8.17))
        flashOffPath.addCurveToPoint(CGPointMake(13.81, 4.26), controlPoint1: CGPointMake(13.84, 4.49), controlPoint2: CGPointMake(13.82, 4.38))
        flashOffPath.addCurveToPoint(CGPointMake(13.72, 4.25), controlPoint1: CGPointMake(13.78, 4.26), controlPoint2: CGPointMake(13.75, 4.25))
        flashOffPath.addCurveToPoint(CGPointMake(2.38, 23.6), controlPoint1: CGPointMake(9.95, 10.68), controlPoint2: CGPointMake(6.19, 17.1))
        flashOffPath.addCurveToPoint(CGPointMake(3.03, 23.6), controlPoint1: CGPointMake(2.67, 23.6), controlPoint2: CGPointMake(2.85, 23.6))
        flashOffPath.addCurveToPoint(CGPointMake(14.37, 23.6), controlPoint1: CGPointMake(6.81, 23.6), controlPoint2: CGPointMake(10.6, 23.61))
        flashOffPath.addCurveToPoint(CGPointMake(15.57, 24.8), controlPoint1: CGPointMake(15.09, 23.59), controlPoint2: CGPointMake(15.58, 23.8))
        flashOffPath.addCurveToPoint(CGPointMake(15.56, 35.6), controlPoint1: CGPointMake(15.54, 28.4), controlPoint2: CGPointMake(15.56, 32))
        flashOffPath.addCurveToPoint(CGPointMake(15.56, 35.99), controlPoint1: CGPointMake(15.56, 35.73), controlPoint2: CGPointMake(15.56, 35.86))
        flashOffPath.addCurveToPoint(CGPointMake(15.64, 36), controlPoint1: CGPointMake(15.59, 36), controlPoint2: CGPointMake(15.61, 36))
        flashOffPath.addCurveToPoint(CGPointMake(27.71, 16.74), controlPoint1: CGPointMake(19.65, 29.6), controlPoint2: CGPointMake(23.66, 23.2))
        flashOffPath.closePath()
        flashOffPath.miterLimit = 4;
        
        flashOffPath.usesEvenOddFillRule = true;
        
        white.setFill()
        flashOffPath.fill()

        let flashLayer = CAShapeLayer()
        flashLayer.frame = toggleTorchButton.bounds
        flashLayer.path = flashOffPath.CGPath
        flashLayer.position = toggleTorchButton.center
        print(toggleTorchButton.center)
      //  flashLayer.fillColor = white.CGColor
        toggleTorchButton.layer.mask = flashLayer
        self.view.addSubview(toggleTorchButton)
    }
    
    func captureButton() {
        let captureButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        captureButton.frame = CGRectMake((self.view.frame.width/2)-35, (self.view.frame.height)-105, 70, 70)
        captureButton.backgroundColor = UIColor.whiteColor()
        let longPressCaptureRecognizer = UILongPressGestureRecognizer(target: self, action: "capture:")
        longPressCaptureRecognizer.minimumPressDuration = 0.3
        captureButton.addGestureRecognizer(longPressCaptureRecognizer)
        self.view.addSubview(captureButton)
        
    }
    
    func toggleCameraButton() {
        let toggleCameraButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        toggleCameraButton.frame = CGRectMake((self.view.frame.width/2)+175, (self.view.frame.height/2)+100, 70, 70)
        toggleCameraButton.backgroundColor = UIColor.redColor()
        toggleCameraButton.addTarget(self, action: "toggleCamera:", forControlEvents: .TouchUpInside)
        self.view.addSubview(toggleCameraButton)
    }
    
    //MARK: HELPER METHODS
    //hide iphone status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}