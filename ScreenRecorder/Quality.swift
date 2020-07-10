//
//  Quality.swift
//  screenrecorder
//
//  Created by Itay Brenner on 7/10/20.
//  Copyright © 2020 Itaysoft. All rights reserved.
//

import Foundation
import ArgumentParser

enum Quality: String, CaseIterable, ExpressibleByArgument {
  case low, medium, high
}
