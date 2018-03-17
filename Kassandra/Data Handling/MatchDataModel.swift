//
//  MatchDataModel.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 17/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import Foundation

// Specification of the MatchData model
class MatchData {
  // General Before Game
  let fullName: String
  let teamNumber: Int
  let matchId: (String, Int)

  // Autonomous
  let autoRun: Bool
  let autoExchange: Bool
  let autoSwitch: Int
  let autoSwitchFail: Int
  let autoScale: Int
  let autoScaleFail: Int

  // TeleOp
  let collection: String
  let teleSwitch: Int
  let teleSwitchFail: Int
  let teleScale: Int
  let teleScaleFail: Int
  let teleExchange: Int
  let teleExchangeFail: Int

  // Endgame
  let platform: Bool
  let climb: String
  let partnerClimb: String

  // General After Game
  let techFoul: Bool
  let defenseComments: String
  let comments: String

  init (data: [String]) {
    self.fullName = data[0]
    self.teamNumber = Int(data[1])!
    self.matchId = TeamManager.parseMatchData(from: data[2].uppercased())

    self.autoRun = data[3] == Config.trueString
    self.autoExchange = data[4] == Config.trueString
    self.autoSwitch = Int(data[5]) ?? 0
    self.autoSwitchFail = Int(data[6]) ?? 0
    self.autoScale = Int(data[7]) ?? 0
    self.autoScaleFail = Int(data[8]) ?? 0

    self.collection = data[9]
    self.teleSwitch = Int(data[10]) ?? 0
    self.teleSwitchFail = Int(data[11]) ?? 0
    self.teleScale = Int(data[12]) ?? 0
    self.teleScaleFail = Int(data[13]) ?? 0
    self.teleExchange = Int(data[14]) ?? 0
    self.teleExchangeFail = Int(data[15]) ?? 0

    self.platform = data[16] == Config.trueString
    self.climb = data[17]
    self.partnerClimb = data[18]

    self.techFoul = data[19] == Config.trueString
    self.defenseComments = data[20]
    self.comments = data[21]
  }
}
