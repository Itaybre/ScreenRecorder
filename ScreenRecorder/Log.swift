//
//  Log.swift
//  screenrecorder
//
//  Created by Itay Brenner on 7/10/20.
//  Copyright © 2020 Itaysoft. All rights reserved.
//

import Foundation

class Log {
    var verboseEnabled: Bool = false
    
    static let shared = Log()
    
    private init() {
        
    }
    
    func log(_ string: String) {
        if verboseEnabled {
            print(string)
        }
    }
}
