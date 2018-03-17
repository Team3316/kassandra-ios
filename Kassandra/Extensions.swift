//
//  Extensions.swift
//  Kassandra
//
//  Created by Jonathan Ohayon on 17/03/2018.
//  Copyright © 2018 Jonathan Ohayon. All rights reserved.
//

import Foundation

extension String {
  func substring (from: Int, len: Int) -> String {
    let iFrom = self.index(self.startIndex, offsetBy: from)
    let iTo = self.index(iFrom, offsetBy: len)
    return String(self[iFrom ..< iTo])
  }

  func substring (from range: NSRange) -> String {
    return self.substring(from: range.location, len: range.length)
  }
}
