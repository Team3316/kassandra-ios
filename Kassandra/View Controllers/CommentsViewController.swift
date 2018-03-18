//
//  CommentsViewController.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 18/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var tableView: UITableView!

  var teamNumber: Int? {
    didSet {
      configureView()
    }
  }
  var comments: [(String, String)]? = nil

  func configureView () {
    self.loadViewIfNeeded()
    let comments = TeamManager.shared.getMatches(of: self.teamNumber!).map { ($0.matchName(), $0.comments) }
    self.comments = comments
    self.tableView.reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.comments!.count
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
