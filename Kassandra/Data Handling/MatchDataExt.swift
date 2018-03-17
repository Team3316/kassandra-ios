//
//  MatchDataExt.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 17/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import Foundation

extension MatchData {
  func matchName () -> String {
    return "\(self.matchId.0) \(self.matchId.1)"
  }

  func matchKey () -> Int {
    let matchNum = self.matchId.1

    switch self.matchId.0 {
    case "PM":
      return matchNum - 100
    case "QM":
      return matchNum
    case "QF":
      return matchNum + 1000
    case "SF":
      return matchNum + 2000
    case "F":
      return matchNum + 3000
    default:
      return 4000
    }
  }

  func exchange () -> Int {
    return self.teleExchange
  }

  func totalSwitch () -> Int {
    return self.autoSwitch + self.teleSwitch
  }

  func totalScale () -> Int {
    return self.autoScale + self.teleScale
  }
}
