//
//  SimpleAlertViewController.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/06/04.
//

import UIKit

class SimpleAlertViewController: UIAlertController {
  
  var confirmMessage: String?
  var action: UIAlertAction?
  var sender: UIViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // Do any additional setup after loading the view.
  }
  
  convenience init(message: String, confirmMessage: String, sender: UIViewController) {
    self.init()
    
    self.message = message
    self.confirmMessage = confirmMessage
    self.action = UIAlertAction(title: confirmMessage, style: .destructive, handler: nil)
    self.sender = sender
  }
  
  func show(style: UIAlertAction.Style = .destructive, completionHandler: (()->Void)?) {
    
    guard let sender = sender, let action = action else {
      return
    }
    
    self.addAction(action)
    sender.present(self, animated: true, completion: completionHandler)
  }
  
}
