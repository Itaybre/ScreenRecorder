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
            print("Verbose enabled")
            print("FPS: \(fps)")
            print("Quality: \(quality)")
            print("Output Path: \(output)")
        }
    }
}
