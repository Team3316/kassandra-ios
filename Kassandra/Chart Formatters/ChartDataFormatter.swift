//
//  ChartDataFormatter.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 17/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import Foundation
import Charts

@objc class ChartDataFormatter: NSObject, IAxisValueFormatter {
  let matches: [MatchData]

  init (with data: [MatchData]) {
    self.matches = data
  }

  func stringForValue (_ value: Double, axis: AxisBase?) -> String {
    return self.matches[Int(value)].matchName()
  }
}
