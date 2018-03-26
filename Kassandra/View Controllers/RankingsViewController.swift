//
//  RankingsViewController.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 25/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import UIKit
import MBProgressHUD

class RankingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var tableView: UITableView!

  var teams = [Int]()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self

    TeamManager.getRankings() { (teams) in
      self.teams = teams
      self.tableView.reloadData()
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editData))
    editButton.tintColor = Config.teamColor
    self.parent?.navigationItem.rightBarButtonItem = editButton

    let submitButton = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(self.submitRankings))
    submitButton.tintColor = Config.teamColor
    self.parent?.navigationItem.leftBarButtonItem = submitButton

    self.parent?.title = "Rankings"
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @objc func editData () {
    let isEditing = self.tableView.isEditing
    self.tableView.setEditing(!isEditing, animated: true)
  }

  @objc func submitRankings () {
    if !self.tableView.isEditing {
      let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
      hud.label.text = "Submitting rankings..."
      TeamManager.shared.set(rankings: self.teams) {
        MBProgressHUD.hide(for: self.view, animated: true)
      }
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.teams.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell") as! TeamCell
    let team = self.teams[indexPath.row]
    cell.rankLabel.text = "\(indexPath.row + 1)."
    cell.teamLabel.text = "\(team)"
    if team == Config.teamNumber {
      cell.pickLabel.text = "Our team"
    } else if indexPath.row <= 8 {
      cell.pickLabel.text = "1st pick"
    } else if indexPath.row <= 16 {
      cell.pickLabel.text = "2nd pick"
    } else {
      cell.pickLabel.text = "3rd pick"
    }
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 48.0
  }

  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let teamToMove = self.teams[sourceIndexPath.row]
    self.teams.remove(at: sourceIndexPath.row)
    self.teams.insert(teamToMove, at: destinationIndexPath.row)
    self.tableView.reloadData()
  }
}
