//
//  ViewController.swift
//  FlowMoSwift
//
//  Created by Bryan Ryczek on 12/3/15.
//  Copyright © 2015 Bryan Ryczek. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        FlowMoCam().viewDidLoad()
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

