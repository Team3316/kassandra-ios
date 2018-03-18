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
    let dataArr = data.count < 1 ? Config.emptyDataArr : data
    self.fullName = dataArr[0]
    self.teamNumber = Int(dataArr[1]) ?? -1
    self.matchId = TeamManager.parseMatchData(from: dataArr[2])

    self.autoRun = dataArr[3] == Config.trueString
    self.autoExchange = dataArr[4] == Config.trueString
    self.autoSwitch = Int(dataArr[5]) ?? 0
    self.autoSwitchFail = Int(dataArr[6]) ?? 0
    self.autoScale = Int(dataArr[7]) ?? 0
    self.autoScaleFail = Int(dataArr[8]) ?? 0

    self.collection = dataArr[9]
    self.teleSwitch = Int(dataArr[10]) ?? 0
    self.teleSwitchFail = Int(dataArr[11]) ?? 0
    self.teleScale = Int(dataArr[12]) ?? 0
    self.teleScaleFail = Int(dataArr[13]) ?? 0
    self.teleExchange = Int(dataArr[14]) ?? 0
    self.teleExchangeFail = Int(dataArr[15]) ?? 0

    self.platform = dataArr[16] == Config.trueString
    self.climb = dataArr[17]
    self.partnerClimb = dataArr[18]

    self.techFoul = dataArr[19] == Config.trueString
    self.defenseComments = dataArr[20]
    self.comments = dataArr[21]
  }
}
