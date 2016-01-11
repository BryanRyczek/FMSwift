//
//  AnimationTestingViewController.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 12/10/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//

import Foundation
import UIKit
//import PermissionScope


class AnimationTestingViewController: UIViewController {
//    let pscope = PermissionScope()
    
    let wordLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        let coloredSquare = UIView()
        coloredSquare.backgroundColor = UIColor.blueColor()
        coloredSquare.frame = CGRect(x: 0, y: 0, width: 0, height: 20)
        self.view.addSubview(coloredSquare)
        
        UIView.animateWithDuration(3.0, animations: {
            coloredSquare.backgroundColor = UIColor.redColor()
            coloredSquare.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 20)
            } , completion: { finished in
             print("finished")
        })
        
        //// Color Declarations
        let color3 = UIColor(red: 0.076, green: 0.615, blue: 0.920, alpha: 1.000)
        
        let letterLayer = CAShapeLayer()
        //// theLetterF Drawing
        let theLetterFPath = UIBezierPath()
        theLetterFPath.moveToPoint(CGPointMake(34.73, 53.2))
        theLetterFPath.addLineToPoint(CGPointMake(67.5, 53.2))
        theLetterFPath.addLineToPoint(CGPointMake(67.5, 69.53))
        theLetterFPath.addLineToPoint(CGPointMake(34.68, 69.53))
        theLetterFPath.addLineToPoint(CGPointMake(34.68, 111.38))
        theLetterFPath.addLineToPoint(CGPointMake(17.88, 111.38))
        theLetterFPath.addLineToPoint(CGPointMake(17.88, 11.38))
        theLetterFPath.addLineToPoint(CGPointMake(75.04, 11.38))
        theLetterFPath.addLineToPoint(CGPointMake(75.04, 28.34))
        theLetterFPath.addLineToPoint(CGPointMake(35.2, 28.34))
        theLetterFPath.usesEvenOddFillRule = true;
        
       
        letterLayer.path = theLetterFPath.CGPath
        letterLayer.fillColor = UIColor.clearColor().CGColor
        letterLayer.strokeColor = color3.CGColor
        letterLayer.lineWidth = 4
        
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = 2.0
        animateStrokeEnd.fromValue = 0.0
        animateStrokeEnd.toValue = 1.0
        
        // add the animation
        letterLayer.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
        
        view.layer.addSublayer(letterLayer)
        
       drawLetter()
        
        let animateWord = CABasicAnimation(keyPath: "strokeEnd")
        animateWord.duration = 5.0
        animateWord.fromValue = 0.0
        animateWord.toValue = 1.0
        
    
        wordLayer.addAnimation(animateWord, forKey: "animate")
        //NSProgressIndicator()
    }
    
    func drawLetter() {
    
    let word = "Flomo"
    let path = UIBezierPath()
    let spacing: CGFloat = 50
    var i: CGFloat = 0
    for letter in word.characters {
    let newPath = getPathForLetter(letter)
    let actualPathRect = CGPathGetBoundingBox(path.CGPath)
    let transform = CGAffineTransformMakeTranslation((CGRectGetWidth(actualPathRect) + min(i, 1)*spacing), 0)
    newPath.applyTransform(transform)
    path.appendPath(newPath)
    i++
        
        }
    wordLayer.strokeColor = UIColor.greenColor().CGColor
    wordLayer.fillColor = UIColor.clearColor().CGColor
    wordLayer.path = path.CGPath
    view.layer.addSublayer(wordLayer)
    }
  
    
    func getPathForLetter(letter: Character) -> UIBezierPath {
        var path = UIBezierPath()
        let font = CTFontCreateWithName("HelveticaNeue", 64, nil)
        var unichars = [UniChar]("\(letter)".utf16)
        var glyphs = [CGGlyph](count: unichars.count, repeatedValue: 0)
        
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        if gotGlyphs {
            let cgpath = CTFontCreatePathForGlyph(font, glyphs[0], nil)
            path = UIBezierPath(CGPath: cgpath!)
        }
        
        return path
    }
    
    
//    let permissions = PermissionScope()
    
    // MARK: SETUP METHODS
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

}
