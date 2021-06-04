//
//  ChatRoom.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/05/31.
//

import Foundation

struct ChatRoom {
  
  var key: String
  var name: String
  var messages: [String: Int]
  var currentDate = "No Data"
  var usersUID: [String]
  
  init(key: String, name: String, usersUID: [String]) {
    self.key = key
    self.name = name
    self.messages = [:]
    self.usersUID = usersUID
  }
  
  init(key: String, data: [String: AnyObject]) {
    self.key = key
    self.name = (data["name"] as? String) ?? "Error Occured!"
    self.messages = (data["messages"] as? [String: Int]) ?? [:]
    self.usersUID = (data["usersUID"] as? [String]) ?? []
  }
}
