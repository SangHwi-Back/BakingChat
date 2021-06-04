//
//  CustomView.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/06/03.
//

import UIKit

class CustomView: UIPresentationController {
  var customViewRect: CGRect
  var coordinator: UIViewController
  
  required init(customViewRect: CGRect,
                coordinator: UIViewController,
                presentedViewController: UIViewController,
                presenting: UIViewController) {
    self.customViewRect = customViewRect
    self.coordinator = coordinator
    super.init(presentedViewController: presentedViewController, presenting: presenting)
  }
  
  override var frameOfPresentedViewInContainerView: CGRect {
    get {
      return customViewRect
    }
  }
}
