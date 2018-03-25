//
//  Config.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 17/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import UIKit

struct Config {
  static let tbaUrl: String = "https://www.thebluealliance.com/api/v3/district/2018isr/rankings"
  static let backendUrl: String = "https://powerful-oasis-78904.herokuapp.com/get_csv"
  static let authKey: String = "2AaKZlZHDHpdYxMNN6Qj6nNGpXMA1JAYqsnRXmva3Cau6GMqB9nSHIPbCElKsxwO"
  static let teamsKey: String = "com.jonathano.Kassandra.teamList"

  static let matchRegex: String = "(PM|QM|QF|SF|F)[ -]?([0-9]+)"
  static let trueString: String = "TRUE"
  static let success: String = "Successful"
  static let fail: String = "Failed"

  static let successColor: UIColor = UIColor(red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0)
  static let failColor: UIColor = UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1.0)
  static let platformColor: UIColor = UIColor(red: 41.0/255.0, green: 98.0/255.0, blue: 255.0/255.0, alpha: 1.0)
  static let teamColor: UIColor = UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 2.0/255.0, alpha: 1.0)

  static let emptyMatch: MatchData = MatchData(data: [])
  static let emptyDataArr: [String] = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
}
