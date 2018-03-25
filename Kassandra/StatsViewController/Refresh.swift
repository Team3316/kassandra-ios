//
//  Refresh.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 24/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import Foundation
import MBProgressHUD

extension StatsViewController {
  @objc func refreshData () {
    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    hud.label.text = "Loading matches..."
    self.teamManager?.getRemoteData(of: self.teamNumber!)
  }
}
