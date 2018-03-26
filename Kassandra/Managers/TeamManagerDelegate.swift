//
//  TeamManagerDelegate.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 24/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import Foundation

protocol TeamManagerDelegate {
  func teamManager (didSetMatches matches: [MatchData])
  func teamManager (didChooseEvent event: TeamManager.Event)
}
