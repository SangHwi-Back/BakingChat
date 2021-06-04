//
//  UIView+Extension.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/05/31.
//

import UIKit

public extension UIView {
  
  // MARK: - Border
  @IBInspectable
  var cornerRadius: CGFloat {
    
    get {
      
      return layer.cornerRadius
    }
    
    set {
      
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
  
  @IBInspectable
  var borderWidth: CGFloat {
    
    get {
      
      return layer.borderWidth
    }
    
    set {
      
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable
  var borderColor: UIColor? {
    
    get {
      
      return UIColor(cgColor: layer.borderColor!)
    }
    
    set {
      
      layer.borderColor = newValue?.cgColor
    }
  }
  
}
