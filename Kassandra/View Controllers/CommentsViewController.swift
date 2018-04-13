//
//  CommentsViewController.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 18/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import UIKit
import MBProgressHUD

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TeamManagerDelegate {
  @IBOutlet weak var tableView: UITableView!

  var teamManager: TeamManager? = nil
  var teamNumber: Int? {
    didSet {
      configureView()
    }
  }
  var comments: [(String, String)]? = nil

  func configureView () {
    self.loadViewIfNeeded()
    MBProgressHUD.hide(for: self.view, animated: true)

    let comments = self.teamManager!.getMatches(of: self.teamNumber!).map { ($0.matchName(), $0.comments) }
    self.comments = comments
    self.tableView.reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.teamManager?.commentsDelegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.comments?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentCell else {
      fatalError("Cell dequeued isn't a team cell!")
    }

    let currentMatch = self.comments![indexPath.row]
    cell.matchIdLabel.text = currentMatch.0
    cell.commentLabel.text = currentMatch.1

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150.0
  }
}

/*
 * TeamManager delegation
 */
extension CommentsViewController {
  func teamManager(didSetMatches matches: [MatchData]) {
    self.configureView()
  }

  func teamManager(didChooseEvent event: TeamManager.Event) {
    self.teamManager?.set(matches: [])
    if event != TeamManager.Event.roebling {
      var matches: [MatchData] = []
      switch event {
        case .isde1: matches = TeamManager.isde1.getMatches(of: self.teamNumber!)
        case .isde3: matches = TeamManager.isde3.getMatches(of: self.teamNumber!)
        case .isde4: matches = TeamManager.isde4.getMatches(of: self.teamNumber!)
        case .iscmp: matches = TeamManager.iscmp.getMatches(of: self.teamNumber!)
        case .preRoebling: matches = TeamManager.preRoebling.getMatches(of: self.teamNumber!)
        default: matches = []
      }
      self.teamManager?.set(matches: matches)
    } else {
      self.refreshData()
    }
    self.parent?.title = "Comments - Team #\(self.teamNumber!) in \(event.name())"
  }

  func refreshData () {
    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.label.text = "Loading matches..."
    self.teamManager?.getRemoteData(of: self.teamNumber!)
  }
}
