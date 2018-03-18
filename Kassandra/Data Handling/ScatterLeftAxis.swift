//
//  ScatterLeftAxis.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 18/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import Foundation
import Charts

@objc class ScatterLeftAxis: NSObject, IAxisValueFormatter {
  let labels = ["[A] Run", "[A] Switch", "[A] Scale", "Partner", "Climb", "Platform", ""]

  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    if value - 1 >= 0 {
      return self.labels[Int(value - 1)]
    } else {
      return ""
    }
  }
}

