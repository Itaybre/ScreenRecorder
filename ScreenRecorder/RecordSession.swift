//
//  RecordSession.swift
//  screenrecorder
//
//  Created by Itay Brenner on 7/13/20.
//  Copyright © 2020 Itaysoft. All rights reserved.
//

import Foundation
import AVFoundation

class RecordSession: NSObject {
    var device: AVCaptureDevice
    var config: Configuration
    var captureSession: AVCaptureSession!
    var captureOutput: AVCaptureMovieFileOutput!
    
    init(device: AVCaptureDevice, configuration: Configuration) {
        self.device = device
        self.config = configuration
    }
    
    func startRecording() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = videoQuality()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(runtimeError(_:)),
                                               name: NSNotification.Name.AVCaptureSessionRuntimeError,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(interrumpted(_:)),
                                               name: NSNotification.Name.AVCaptureSessionWasInterrupted,
                                               object: nil)
        
        do {
            captureSession.beginConfiguration()
            let input = try AVCaptureDeviceInput(device: device)
            captureSession.addInput(input)
            captureOutput = AVCaptureMovieFileOutput()
            
            
            captureSession.addOutput(captureOutput)
            captureSession.commitConfiguration()
            
            captureSession.startRunning()
            let url = URL(fileURLWithPath: config.outputPath)
            captureOutput.startRecording(to: url, recordingDelegate: self)
            
            let connection = captureOutput.connections.first!

            let frameDuration = CMTimeMake(value: 1, timescale: Int32(config.fps))
            if (connection.isVideoMinFrameDurationSupported) {
                connection.videoMinFrameDuration = frameDuration
            }
            
            if (connection.isVideoMaxFrameDurationSupported) {
                connection.videoMaxFrameDuration = frameDuration
            }
        } catch {
            DeviceFinder.shared.enableCoreMedia(false)
            exit(1)
        }
    }
    
    func stopRecording() {
        captureOutput.stopRecording()
        captureSession.stopRunning()
    }
    
    @objc
    func runtimeError(_ notification:Notification) {
        print("Runtime error: \(notification)")
        stopRecording()
    }
    
    @objc
    func interrumpted(_ notification:Notification) {
        print("interrumpted: \(notification)")
        stopRecording()
    }
    
    private func videoQuality() -> AVCaptureSession.Preset {
        switch config.quality {
        case .high:
            return .high
        case .medium:
            return .medium
        case .low:
            return .low
        }
    }
}

extension RecordSession: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("Did finish recording")
        
        DeviceFinder.shared.enableCoreMedia(false)
        exit(0)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("Did start recording")
    }
}
