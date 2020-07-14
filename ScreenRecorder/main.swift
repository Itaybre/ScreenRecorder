//
//  main.swift
//  ScreenRecorder
//
//  Created by Itay Brenner on 7/9/20.
//  Copyright © 2020 Itaysoft. All rights reserved.
//

import Foundation

// Ignore SIGINT Signal
signal(SIGINT, SIG_IGN)

// Custom Handler for SIGINT Signal
let source = DispatchSource.makeSignalSource(signal: SIGINT)
source.setEventHandler {
    print("Stopping recording...")
    DispatchQueue.main.sync {
        DeviceFinder.shared.stop()
    }
            
    exit(0)
}
source.resume()

RecordCommand.main()

RunLoop.main.run()
