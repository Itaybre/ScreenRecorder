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
    var udid: String?
    var waitingForDevice: Bool = false
    var selectedDevice: AVCaptureDevice? = nil
    
    func findDevice(udid: String?) {
        self.udid = udid
        
        enableNotifications()
        enableCoreMedia(true)
        
        DispatchQueue.global(qos: .background).async {
            // Use background thread to wait for devices
            self.waitForDevice()
        }
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
            exit(1)
        }

        print("Device found: \(device.localizedName)")
    }
    
    private func enableCoreMedia(_ enabled: Bool) {
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
            udid == nil || device.uniqueID == udid {
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
