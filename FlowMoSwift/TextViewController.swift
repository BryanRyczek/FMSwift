//
//  TextViewController.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 12/8/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//

import UIKit
import Chameleon

class TextViewController: UIViewController{
    
    var hersheyArray: [UIBezierPath] = []
    
    var xOffset : CGFloat = 0
    
    var hersheyOffset = [String: CGFloat]()
    
    let animation = CAKeyframeAnimation()
    
    var word: String?
    // These number values represent each slider position
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    
    func cursivePathFromString(string: String) -> UIBezierPath {
        
        hersheyOffset = [" ": 0.0, //Special characters
            "a":12.0, "b":0.0, "c":12.0, "d":0.0, "e":12.0, "f":0.0, "g":12.0, "h":0.0, "i":7.0, "j":7.0, "k":0.0, "l":0.0, "m":12.0, "n":12.0, "o":12.0, "p":11.0, "q":12.0, "r":11.0, "s":11.0, "t":0.0, "u":12.0, "v":12.0, "w":12.0, "x":12.0, "y":12.0, "z":12.0, //lowercase leters
            "A": 0.0, "B": 0.0, "C": 0.0, "D": 0.0, "E": 0.0, "F": 0.0, "G": 0.0, "H": 0.0, "I": 0.0, "J": 0.0, "K": 0.0, "L": 0.0, "M": 0.0, "N": 0.0, "O": 0.0, "P": 0.0, "Q": 0.0, "R": 0.0, "S": 0.0, "T": 0.0, "U": 0.0, "V": 0.0, "W": 0.0, "X": 0.0, "Y": 0.0, "Z": 0.0, //UPPERCASE LETTERS
            "0": 0.0, "1": 0.0, "2": 0.0, "3": 0.0, "4": 0.0, "5": 0.0, "6": 0.0, "7": 0.0, "8": 0.0,"9": 0.0, //numb3r5
            "!": 0.0, "\"": 0.0, "#": 0.0, "$": 0.0, "%": 0.0, "&": 0.0, "(": 0.0, ")": 0.0, "*": 0.0, "+": 0.0, ",": 0.0, "-": 0.0, ".": 0.0, "/": 0.0, ":": 0.0, ";": 0.0, "<": 0.0, "=": 0.0, ">": 0.0, "?": 0.0, "@": 0.0, "[": 0.0, "\\": 0.0, "]": 0.0, "^": 0.0, "_": 0.0, "'": 0.0, "{": 0.0, "|": 0.0, "}": 0.0, "~": 0.0  //Symbols

        ]

        let wordArray = Array(string.characters)
        let wordPath = UIBezierPath()
        
        for letter in wordArray {
            if (letter == " ") {
                
            }
            
            let yOffset = hersheyOffset[String(letter)]
            let letterPath = BezierObjects().getPathForLetter(String(letter))
            
            switch letter {
            case "f":
                xOffset -= 5.0
            case "j":
                xOffset -= 8.0
            case "p":
                xOffset -= 4.0
            case "0":
                xOffset += 4.0
            case "1":
                xOffset += 4.0
            case "2":
                xOffset += 4.0
            case "3":
                xOffset += 4.0
            case "4":
                xOffset += 4.0
            case "5":
                xOffset += 4.0
            case "6":
                xOffset += 4.0
            case "7":
                xOffset += 4.0
            case "8":
                xOffset += 4.0
            case "9":
                xOffset += 4.0
                
            default:
                break
            }
            
            //print(actualPathRect)
            let transform = CGAffineTransformMakeTranslation(xOffset,yOffset!)
            let unTransform = CGAffineTransformMakeTranslation(-(xOffset), -(yOffset!))
            letterPath.applyTransform(transform)
            wordPath.appendPath(letterPath)
            letterPath.applyTransform(unTransform)
            //print(letterPath)
            let actualPathRect = CGPathGetBoundingBox(letterPath.CGPath)
            xOffset = xOffset + CGRectGetWidth(actualPathRect)
            
        }
        return wordPath
        
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
