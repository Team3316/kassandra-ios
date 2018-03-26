//
//  DetailViewController.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 17/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import UIKit
import Charts
import MBProgressHUD

class StatsViewController: UIViewController, TeamManagerDelegate {
  @IBOutlet weak var lineChart: LineChartView!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var scatterChart: ScatterChartView!
  
  var isChosen: Bool = false
  var teamManager: TeamManager? = nil

  var teamNumber: Int? {
    didSet {
      self.configureView()
    }
  }

  func configureView() {
    self.loadViewIfNeeded()

    MBProgressHUD.hide(for: self.view, animated: true)

    let matches = self.teamManager!.matches.sorted { $0.matchKey() < $1.matchKey() }
    if matches.count > 0 {
      self.configureChart(with: matches)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.teamManager?.graphsDelegate = self

    self.prepareStackView()
    self.prepareLineChart()
    self.prepareScatterChart()
  }

  override func viewDidAppear(_ animated: Bool) {
    let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(self.popover(_:)))
    settingsButton.tintColor = Config.teamColor
    self.parent?.navigationItem.rightBarButtonItem = settingsButton

    let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshData))
    refreshButton.tintColor = Config.teamColor
    self.parent?.navigationItem.leftBarButtonItem = refreshButton
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

/*
 * TeamManager delegation
 */
extension StatsViewController {
  func teamManager (didChooseEvent event: TeamManager.Event) {
    self.teamManager?.set(matches: [])
    if event != TeamManager.Event.iscmp {
      var matches: [MatchData] = []
      switch event {
        case .isde1: matches = TeamManager.isde1.getMatches(of: self.teamNumber!)
        case .isde3: matches = TeamManager.isde3.getMatches(of: self.teamNumber!)
        case .isde4: matches = TeamManager.isde4.getMatches(of: self.teamNumber!)
        default: matches = []
      }
      self.teamManager?.set(matches: matches)
    } else {
      self.refreshData()
    }
    self.parent?.title = "Details - Team #\(self.teamNumber!) in \(event.name())"
  }

  func teamManager(didSetMatches matches: [MatchData]) {
    self.configureView()
  }
}
