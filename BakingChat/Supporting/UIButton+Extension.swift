//
//  UIButton+Extension.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/05/31.
//

import UIKit

public extension UIButton {
  
  func isChecked(_ checked: Bool) {
    self.setImage(UIImage(named: checked ? "checkbox-checked" : "checkbox-checked-disabled"), for: .normal)
  }
  
  func activateButton(_ activate: Bool = true) {
    self.isEnabled = activate
    self.backgroundColor = (UIColor(named: "buttonBackgroundColor-\(activate ? "" : "de")activate"))
    self.setTitleColor(UIColor(named: "buttonTitleColor-\(activate ? "" : "de")activate"), for: .normal)
  }
}
