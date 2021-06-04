//
//  User.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/05/31.
//

import Foundation

struct User {
  
  var uid: String
  var email: String
  var username: String
  var group: [String: String]
  
  init(uid: String, email: String, username: String) {
    self.uid = uid
    self.email = email
    self.username = username
    self.group = [:]
  }
}
