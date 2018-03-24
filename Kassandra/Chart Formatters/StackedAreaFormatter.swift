//
//  StackedAreaFormatter.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 24/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import Charts

class StackedAreaFormatter: NSObject, IValueFormatter {
  let level: TeamManager.RecordType
  let matches: [MatchData]

  init (with matches: [MatchData], level: TeamManager.RecordType) {
    self.level = level
    self.matches = matches
  }

  func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
    let matchIndex = Int(entry.x)
    let match = self.matches[matchIndex]
    var val = 0.0
    switch self.level {
      case .exchanges: val = value
      case .switches: val = value - Double(match.exchange())
      case .scales: val = value - Double(match.exchange()) - Double(match.totalSwitch())
    }
    return val == 0 ? "" : "\(Int(val))"
  }
}
