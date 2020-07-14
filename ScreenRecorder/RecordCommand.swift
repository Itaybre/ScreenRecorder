//
//  RecordCommand.swift
//  screenrecorder
//
//  Created by Itay Brenner on 7/10/20.
//  Copyright © 2020 Itaysoft. All rights reserved.
//

import Foundation
import ArgumentParser

struct RecordCommand: ParsableCommand {
    @Flag(name: .shortAndLong, help: "Enable verbose mode")
    var verbose = false

    @Option(name: .shortAndLong, help: "Device's UDID")
    var udid: String?
    
    @Option(name: .shortAndLong, help: "Output file")
    var output: String
    
    @Option(name: .shortAndLong, help: "Video FPS")
    var fps: Int = 60
    
    @Option(name: .shortAndLong, help: "Video Quality [low/medium/high]")
    var quality: Quality = .high

    mutating func run() throws {
        if let udid = udid {
            print("Using device: \(udid)")
        } else {
            print("No device selected, using first device detected")
        }
        
        if verbose {
            Log.shared.verboseEnabled = true
            Log.shared.log("Verbose enabled")
            Log.shared.log("FPS: \(fps)")
            Log.shared.log("Quality: \(quality)")
            Log.shared.log("Output Path: \(output)")
        }
        
        if FileManager.default.fileExists(atPath: output) {
            throw fatalError("There is already a file at path \(output)")
        }
        
        let config = Configuration(udid: udid, outputPath: output, fps: fps, quality: quality)
        DeviceFinder.shared.findDevice(configuration: config)
    }
}
