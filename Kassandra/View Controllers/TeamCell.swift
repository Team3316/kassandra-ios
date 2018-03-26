//
//  TeamCell.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 25/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell {
  @IBOutlet weak var rankLabel: UILabel!
  @IBOutlet weak var teamLabel: UILabel!
  @IBOutlet weak var pickLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
