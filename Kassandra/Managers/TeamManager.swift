//
//  TeamManager.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 17/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import Foundation
import CSV
import Alamofire
import Charts

class TeamManager {
  static let isde1: TeamManager = TeamManager(event: Event.isde1)
  static let isde3: TeamManager = TeamManager(event: Event.isde3)
  static let isde4: TeamManager = TeamManager(event: Event.isde4)
  static let iscmp: TeamManager = TeamManager(event: Event.iscmp)
  static let preRoebling: TeamManager = TeamManager(event: Event.preRoebling)

  static let shared: TeamManager = TeamManager()
  static var chosenEvent: Event = Event.roebling

  var matches: [MatchData]
  var event: Event

  var graphsDelegate: TeamManagerDelegate?
  var commentsDelegate: TeamManagerDelegate?
  var searchDelegate: TeamManagerDelegate?

  enum RecordType {
    case scales
    case switches
    case exchanges

    func color () -> UIColor {
      switch self {
        case .scales: return UIColor(red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 0.95)
        case .switches: return UIColor(red: 255.0/255.0, green: 152.0/255.0, blue: 0.0/255.0, alpha: 0.95)
        case .exchanges: return UIColor(red: 3.0/255.0, green: 169.0/255.0, blue: 244.0/255.0, alpha: 0.95)
      }
    }
  }

  enum ClimbType {
    case success
    case fail
    case didntTry
    case platform

    func color () -> UIColor {
      switch self {
        case .success: return Config.successColor
        case .fail: return Config.failColor
        case .platform: return Config.platformColor
        default: return UIColor.clear
      }
    }

    func scatterIcon () -> ScatterChartDataSet.Shape {
      switch self {
        case .success: return ScatterChartDataSet.Shape.square
        case .platform: return ScatterChartDataSet.Shape.triangle
        default: return ScatterChartDataSet.Shape.x
      }
    }
  }

  enum Event {
    case isde1
    case isde3
    case isde4
    case iscmp
    case preRoebling
    case roebling

    func name () -> String {
      switch self {
        case .isde1: return "ISDE 1"
        case .isde3: return "ISDE 3"
        case .isde4: return "ISDE 4"
        case .iscmp: return "ISCMP"
        case .roebling: return "Roebling Division"
        case .preRoebling: return "Pre-Champs"
      }
    }

    func filename () -> String {
      switch self {
        case .isde1: return "isde1"
        case .isde3: return "isde3"
        case .isde4: return "isde4"
        case .iscmp: return "iscmp"
        case .preRoebling: return "preroebling"
        case .roebling: return "roebling"
      }
    }

    func isChamps () -> Bool {
      switch self {
        case .roebling: return true
        case .preRoebling: return true
        default: return false
      }
    }
  }

  /*
   * Instance Methods
   */
  init (event: Event) {
    let data = TeamManager.getLocalData(in: event.filename())
    var m = [MatchData]()
    while let row = data.next() {
      m.append(MatchData(data: row))
    }
    self.matches = m
    self.event = event
  }

  init () {
    self.matches = []
    self.event = Event.roebling
  }

  func set (matches: [MatchData]) {
    self.matches = matches

    if let gDelegate = self.graphsDelegate {
      gDelegate.teamManager(didSetMatches: matches)
    }

    if let cDelegate = self.commentsDelegate {
      cDelegate.teamManager(didSetMatches: matches)
    }
  }

  func set (event: Event) {
    self.event = event
    TeamManager.chosenEvent = event

    if let gDelegate = self.graphsDelegate {
      gDelegate.teamManager(didChooseEvent: event)
    }

    if let cDelegate = self.commentsDelegate {
      cDelegate.teamManager(didChooseEvent: event)
    }

    if let sDelegate = self.searchDelegate {
      sDelegate.teamManager(didChooseEvent: event)
    }
  }

  func set (rankings: [Int], with callback: @escaping () -> ()) {
    let body: [String: [Int]] = [
      "ranks": rankings
    ]
    let configKey = self.event.isChamps() ? Config.champsRankingsKey : Config.isrRankingsKey

    Alamofire
      .request("\(Config.backendUrl)/rankings", method: .put, parameters: body, encoding: JSONEncoding.default, headers: nil)
      .responseJSON { (resp) in
        UserDefaults.standard.set(rankings, forKey: configKey)
        callback()
      }
  }

  func getMatches (of team: Int) -> [MatchData] {
    return self.matches.filter({ $0.teamNumber == team })
  }

  func isInEvent (team: Int) -> Bool {
    let key = "com.jonathano.Kassandra.team\(team).\(self.event)"
    let fromUD = UserDefaults.standard.bool(forKey: key)
    if fromUD {
      return fromUD
    } else {
      let data = self.getMatches(of: team).count > 0
      UserDefaults.standard.set(data, forKey: key)
      return data
    }
  }

  func getRemoteData (of team: Int, then: (() -> ())? = nil) {
    Alamofire.request("\(Config.backendUrl)/get_csv/\(team)").responseJSON { resp in
      let data = (resp.result.value! as! [[Any]])
        .map({ a in
          return a.map({ String(describing: $0) })
        }).map({ MatchData(data: $0) })
      self.set(matches: data)
      if let then = then {
        then()
      }
    }
  }

  func getEvents (of team: Int) -> [(String, Bool, Event)] {
    let isInIsde1 = TeamManager.isde1.isInEvent(team: team)
    let isInIsde3 = TeamManager.isde3.isInEvent(team: team)
    let isInIsde4 = TeamManager.isde4.isInEvent(team: team)
    let isInIscmp = TeamManager.iscmp.isInEvent(team: team)
    let isInRoebling = team == 3316 || (!isInIsde1 && !isInIsde3 && !isInIsde4 && !isInIscmp)

    return [
      ("ISR District #1", isInIsde1, Event.isde1),
      ("ISR District #3", isInIsde3, Event.isde3),
      ("ISR District #4", isInIsde4, Event.isde4),
      ("ISR District Championship", isInIscmp, Event.iscmp),
      ("Pre-Roebling", TeamManager.preRoebling.isInEvent(team: team), Event.preRoebling),
      ("Roebling Division", isInRoebling, Event.roebling)
    ]
  }

  func scatterDataSet (type: ClimbType, from data: [(Int, MatchData)], level: Double) -> ScatterChartDataSet {
    let entries = data.map({ ChartDataEntry(x: Double($0.0), y: level) })
    let dataSet = ScatterChartDataSet(values: entries)
    dataSet.setScatterShape(type.scatterIcon())
    dataSet.setColor(type.color())
    return dataSet
  }

  func scatterDataSet (type: ClimbType, from data: [(Int, MatchData)], level: Int) -> ScatterChartDataSet {
    return self.scatterDataSet(type: type, from: data, level: Double(level))
  }

  func autoRunSucc (from matches: [MatchData]) -> ScatterChartDataSet {
    let entries = matches
      .enumerated()
      .filter({ $0.1.autoRun })
    return self.scatterDataSet(type: .success, from: entries, level: 1)
  }

  func autoRunFail (from matches: [MatchData]) -> ScatterChartDataSet {
    let entries = matches
      .enumerated()
      .filter({ !$0.1.autoRun })
    return self.scatterDataSet(type: .fail, from: entries, level: 1)
  }

  func autoSwitchSucc (from matches: [MatchData]) -> ScatterChartDataSet {
    let entries = matches
      .enumerated()
      .filter({ $0.1.autoSwitch > 0 })
    return self.scatterDataSet(type: .success, from: entries, level: 2)
  }

  func autoSwitchFail (from matches: [MatchData]) -> ScatterChartDataSet {
    let entries = matches
      .enumerated()
      .filter({ $0.1.autoSwitchFail > 0 })
    return self.scatterDataSet(type: .fail, from: entries, level: 2)
  }

  func autoScaleSucc (from matches: [MatchData]) -> ScatterChartDataSet {
    let entries = matches
      .enumerated()
      .filter({ $0.1.autoScale > 0 })
    return self.scatterDataSet(type: .success, from: entries, level: 3)
  }

  func autoScaleFail (from matches: [MatchData]) -> ScatterChartDataSet {
    let entries = matches
      .enumerated()
      .filter({ $0.1.autoScaleFail > 0 })
    return self.scatterDataSet(type: .fail, from: entries, level: 3)
  }

  func partnerSucc (from matches: [MatchData]) -> ScatterChartDataSet {
    let entries = matches
      .enumerated()
      .filter({ $0.1.partnerClimb == Config.success })
    return self.scatterDataSet(type: .success, from: entries, level: 4)
  }

  func partnerFail (from matches: [MatchData]) -> ScatterChartDataSet {
    let entries = matches
      .enumerated()
      .filter({ $0.1.partnerClimb == Config.fail })
    return self.scatterDataSet(type: .fail, from: entries, level: 4)
  }

  func climbSucc (from matches: [MatchData]) -> ScatterChartDataSet {
    let entries = matches
      .enumerated()
      .filter({ $0.1.climb == Config.success })
    return self.scatterDataSet(type: .success, from: entries, level: 5)
  }

  func climbFail (from matches: [MatchData]) -> ScatterChartDataSet {
    let entries = matches
      .enumerated()
      .filter({ $0.1.climb == Config.fail })
    return self.scatterDataSet(type: .fail, from: entries, level: 5)
  }

  func platform (from matches: [MatchData]) -> ScatterChartDataSet {
    let entries = matches
      .enumerated()
      .filter({ $0.1.platform })
    return self.scatterDataSet(type: .platform, from: entries, level: 6)
  }

  /*
   * Static methods
   */
  static func getLocalData (`in` file: String) -> CSV {
    let filePath = Bundle.main.path(forResource: file, ofType: "csv")
    let input = InputStream(fileAtPath: filePath!)
    return try! CSV(stream: input!, hasHeaderRow: true)
  }

  static func parseMatchData (from text: String) -> (String, Int) {
    let regex = try! NSRegularExpression(pattern: Config.matchRegex)
    let result = regex.matches(in: text, range: NSMakeRange(0, text.utf16.count))
    if result.count > 0 {
      let id = text.substring(from: result[0].range(at: 1))
      let num = text.substring(from: result[0].range(at: 2))
      return (id, Int(num) ?? 0)
    } else {
      return ("", 0)
    }
  }

  static func getChartDataSet (from matches: [MatchData], type: RecordType) -> LineChartDataSet {
    let values = matches.enumerated().map({ (i, match) -> ChartDataEntry in
      var yValue: Int = -1
      // We are summing the values of the scales, switches and exchange in order to
      // make the chart look more like a stacked area chart.
      switch type {
        case .scales: yValue = match.totalScale() + match.totalSwitch() + match.exchange()
        case .switches: yValue = match.totalSwitch() + match.exchange()
        case .exchanges: yValue = match.exchange()
      }
      return ChartDataEntry(x: Double(i), y: Double(yValue))
    })
    let dataSet = LineChartDataSet(values: values, label: nil)
    dataSet.setColor(type.color())
    dataSet.valueTextColor = UIColor.white
    dataSet.fill = Fill.fillWithColor(type.color())
    dataSet.drawFilledEnabled = true
    dataSet.drawCirclesEnabled = false
    dataSet.drawValuesEnabled = false
    dataSet.fillAlpha = 1
    dataSet.valueFormatter = StackedAreaFormatter(with: matches, level: type)
    return dataSet
  }

  static func shouldKeep (data: [MatchData], percentile: Double = 0.75) -> Double {
    let len = Double(data.count)
    return ceil(len * percentile)
  }

  static func average (data: [Double], keep: Double) -> Double {
    let sum = data
      .sorted()
      .reduce(0, +)
    return sum / keep
  }

  static func totalCubesAverage (from data: [MatchData]) -> Double {
    let scales = data.map({ Double($0.totalScale()) })
    let switches = data.map({ Double($0.totalSwitch()) })
    let exchanges = data.map({ Double($0.exchange()) })
    return average(data: scales + switches + exchanges, keep: Double(data.count))
  }

  static func getIsrTeams (with callback: @escaping ([Int]) -> ()) {
    let headers: HTTPHeaders = [
      "X-TBA-Auth-Key": Config.authKey
    ]

    let teamsList = UserDefaults.standard.array(forKey: Config.isrTeamsKey)
    if teamsList == nil {
      Alamofire.request(Config.tbaIsrUrl, headers: headers).responseJSON { resp in
        // Array of teams in ranks 1 to 45
        let data = resp.result.value! as! [[String: Any]]
        let participatingTeams = data
          .filter({ ($0["rank"] as! Int) <= 45 })
          .map({ Int(($0["team_key"] as! String).replacingOccurrences(of: "frc", with: "")) ?? -1 })
        UserDefaults.standard.set(participatingTeams, forKey: Config.isrTeamsKey)
        callback(participatingTeams)
      }
    } else {
      callback(teamsList as! [Int])
    }
  }

  static func getChampsTeams (with callback: @escaping ([Int]) -> ()) {
    let headers: HTTPHeaders = [
      "X-TBA-Auth-Key": Config.authKey
    ]

    let teamsList = UserDefaults.standard.array(forKey: Config.champsTeamsKey)
    if teamsList == nil {
      Alamofire.request(Config.tbaChampsUrl, headers: headers).responseJSON { resp in
        let data = resp.result.value! as! [[String: Any]]
        let participatingTeams = data
          .map({ Int(($0["key"] as! String).replacingOccurrences(of: "frc", with: "")) ?? -1 })
        UserDefaults.standard.set(participatingTeams, forKey: Config.champsTeamsKey)
        callback(participatingTeams)
      }
    } else {
      callback(teamsList as! [Int])
    }
  }

  static func getTeams (with callback: @escaping ([Int]) -> ()) {
    if self.chosenEvent.isChamps() {
      self.getChampsTeams(with: callback)
    } else {
      self.getIsrTeams(with: callback)
    }
  }

  static func getRankings (with callback: @escaping ([Int]) -> ()) {
    let configKey = self.chosenEvent.isChamps() ? Config.champsTeamsKey : Config.isrRankingsKey
    let rankings = UserDefaults.standard.array(forKey: configKey)

    if rankings == nil {
      TeamManager.getTeams() { (teams) in
        UserDefaults.standard.set(teams, forKey: configKey)
        callback(teams)
      }
    } else {
      callback(rankings as! [Int])
    }
  }
}
