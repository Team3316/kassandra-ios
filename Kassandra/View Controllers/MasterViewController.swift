//
//  MasterViewController.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 17/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//
import UIKit

class MasterViewController: UITableViewController {
  var detailViewController: StatsViewController? = nil
  var objects = [Int]()
  var filtered = [Int]()

  override func viewDidLoad() {
    super.viewDidLoad()

    let addButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh(_:)))
    self.navigationItem.leftBarButtonItem = addButton
    if let split = splitViewController {
        let controllers = split.viewControllers
        self.detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? StatsViewController
    }

    TeamManager.shared.getTeams { (teams) in
      self.objects = teams
      self.tableView.reloadData()
    }

    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Teams"
    self.navigationItem.searchController = searchController
  }

  override func viewWillAppear(_ animated: Bool) {
    self.clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    super.viewWillAppear(animated)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @objc
  func refresh(_ sender: Any) {
    print("refresh")
  }
}

/*
 * Segue
 */
extension MasterViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      if let indexPath = self.tableView.indexPathForSelectedRow {
        let object = objects[indexPath.row]
        let tabVC = (segue.destination as! UINavigationController).topViewController as! UITabBarController
        tabVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        tabVC.navigationItem.leftItemsSupplementBackButton = true

        let statsVC = tabVC.childViewControllers[0] as! StatsViewController
        statsVC.teamNumber = object

        let commentsVC = tabVC.childViewControllers[1] as! CommentsViewController
        commentsVC.teamNumber = object
      }
    }
  }
}

/*
 * Search
 */
extension MasterViewController: UISearchResultsUpdating {
  func shouldFilter () -> Bool {
    if let sc = self.navigationItem.searchController {
      return sc.isActive && !((sc.searchBar.text?.isEmpty) ?? true)
    }
    return false
  }

  func filterTeams (by query: String) {
    self.filtered = self.objects.filter({ String($0).starts(with: query) })
    self.tableView.reloadData()
  }

  func updateSearchResults(for searchController: UISearchController) {
    self.filterTeams(by: searchController.searchBar.text ?? "")
  }
}

/*
 * Table view
 */
extension MasterViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.shouldFilter() ? self.filtered.count : self.objects.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let arr = self.shouldFilter() ? self.filtered : self.objects
    let object = arr[indexPath.row]
    cell.textLabel!.text = "\(object)"
    return cell
  }
}

