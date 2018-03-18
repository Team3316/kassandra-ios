//
//  CommentCell.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 18/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
  @IBOutlet weak var matchIdLabel: UILabel!
  @IBOutlet weak var commentLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    // Nothing here
  }
}
