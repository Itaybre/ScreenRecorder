//
//  DeviceFinder.swift
//  screenrecorder
//
//  Created by Itay Brenner on 7/10/20.
//  Copyright © 2020 Itaysoft. All rights reserved.
//

import Foundation
import CoreMediaIO
import AVFoundation

class DeviceFinder {
    var configuration: Configuration!
    
    var waitingForDevice: Bool = false
    var selectedDevice: AVCaptureDevice? = nil
    var recordingSession: RecordSession?
    
    static let shared = DeviceFinder()
    
    private init() {
    }
    
    func findDevice(configuration: Configuration) {
        self.configuration = configuration
        
        enableNotifications()
        enableCoreMedia(true)
        
        DispatchQueue.global(qos: .background).async {
            // Use background thread to wait for devices
            self.waitForDevice()
        }
    }
    
    func stop() {
        recordingSession?.stopRecording()
    }
    
    private func waitForDevice() {
        // Required to get new devices connected
        AVCaptureDevice.devices()
        
        print("Waiting for device...")
        
        var timeWaited = 0
        while selectedDevice == nil && timeWaited < 10 {
            // Wait for selected device (up to 10 seconds)
            sleep(1)
            timeWaited += 1
        }
        
        guard let device = selectedDevice else {
            print("No device found")
            DeviceFinder.shared.enableCoreMedia(false)
            exit(1)
        }

        print("Device found: \(device.localizedName)")
        recordingSession = RecordSession(device: device, configuration:configuration)
        recordingSession?.startRecording()
    }
    
    func enableCoreMedia(_ enabled: Bool) {
        var prop = CMIOObjectPropertyAddress(
          mSelector: CMIOObjectPropertySelector(kCMIOHardwarePropertyAllowScreenCaptureDevices),
          mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
          mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMaster)
        )

        var allow : UInt32 = enabled ? 1 : 0
        let sizeOfAllow = UInt32(MemoryLayout<UInt32>.size)
        let zero : UInt32 = 0
        CMIOObjectSetPropertyData(CMIOObjectID(kCMIOObjectSystemObject), &prop, zero, nil, sizeOfAllow, &allow)
    }
    
    private func enableNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deviceAttached(_:)),
                                               name: NSNotification.Name.AVCaptureDeviceWasConnected,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deviceDetached(_:)),
                                               name: NSNotification.Name.AVCaptureDeviceWasDisconnected,
                                               object: nil)
    }
    
    deinit {
        enableCoreMedia(false)
    }
}


// MARK: - Notification Listeners
extension DeviceFinder {
    @objc
    private func deviceAttached(_ notification:Notification) {
        let device = notification.object as! AVCaptureDevice
        if device.hasMediaType(.muxed),
            device.modelID == "iOS Device",
            configuration.udid == nil || device.uniqueID == configuration.udid {
            waitingForDevice = false
            selectedDevice = device
        }
        
        Log.shared.log(notification.description)
    }
    
    @objc
    private func deviceDetached(_ notification:Notification) {
        Log.shared.log(notification.description)
        // TODO: Stop if device disconnected
    }
}
