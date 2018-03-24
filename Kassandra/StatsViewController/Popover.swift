//
//  Popover.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 24/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import UIKit

extension StatsViewController {
  @objc func popover (_ sender: UIBarButtonItem) {
    let settingsVC = DatasetsViewController(nibName: "DatasetsViewController", bundle: Bundle.main)

    settingsVC.teamNumber = self.teamNumber ?? -1
    settingsVC.teamManager = self.teamManager

    settingsVC.modalPresentationStyle = .popover
    settingsVC.preferredContentSize = CGSize(width: 400, height: 400)

    self.present(settingsVC, animated: true, completion: nil)
    settingsVC.popoverPresentationController?.barButtonItem = sender
  }
}
