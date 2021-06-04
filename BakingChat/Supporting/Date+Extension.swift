//
//  Date+Extensions.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/06/02.
//

import Foundation

public extension Date {
  
  func formattedString(format: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = format
    
    return dateFormatter.string(from: self)
  }
}
