//
//  File.swift
//  FlowMoSwift
//
//  Created by Conor Carey on 1/12/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import Foundation

var SingletonModel: FlowMo {
    
    struct Singleton
    {
        static let model = FlowMo()
    }
    
    return Singleton.model
}
