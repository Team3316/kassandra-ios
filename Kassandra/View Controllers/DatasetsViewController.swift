//
//  DatasetsViewController.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 23/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import UIKit

class DatasetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var tableView: UITableView!

  var teamNumber: Int = -1
  var teamManager: TeamManager? = nil
  var events: [(String, Bool, TeamManager.Event)] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.dataSource = self
    self.tableView.delegate = self

    self.events = self.teamManager!.getEvents(of: self.teamNumber)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.events.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: "eventCell")
    if cell == nil {
      cell = UITableViewCell(style: .default, reuseIdentifier: "eventCell")
      let event = self.events[indexPath.row]
      cell!.textLabel?.text = "\(event.0)"
      cell?.textLabel?.textColor = event.1 ? Config.successColor : Config.failColor
      cell!.accessoryType = event.1 ? .checkmark : .none
    }
    return cell!
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let event = self.events[indexPath.row]
    if event.1 {
      self.teamManager?.set(event: event.2)
      self.dismiss(animated: true, completion: nil)
    } else {
      tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
  }
}
