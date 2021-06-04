//
//  ChatMainViewModel.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/06/01.
//

import Foundation
import Firebase

class ChatMainViewModel {
  
  static let instance = ChatMainViewModel()
  
  let chatRoomRef = baseRef.child("chatRooms")
  var delegate: ChatMainViewProtocol?
  var chatRooms = [ChatRoom]() {
    didSet {
      self.delegate?.reloadTableView()
    }
  }
  
  weak var loginVM = LoginViewModel.instance
  
  func fetchChatRoomList() {
    
    chatRoomRef.observe(.childAdded) { snapshot in
      
      if let dict = snapshot.value as? [String: AnyObject] {
        
        self.chatRooms.append(ChatRoom(key: dict["key"] as! String,
                                  name: dict["name"] as! String,
                                  usersUID: (dict["usersUID"] as? [String]) ?? [String]())
        )
      }
    }
  }
  
  func saveChatRoom(_ users: [User], name: String, completionHandler: @escaping (Bool)->Void) {
    
    guard let key = chatRoomRef.childByAutoId().key else {
      return
    }
    
    var usersUID = [String]()
    users.forEach { user in
      usersUID.append(user.uid)
    }
    
    let data: [String: AnyObject] = [
      "key": chatRoomRef.childByAutoId().key as AnyObject,
      "name": name as AnyObject,
      "messages": [String: Int]() as AnyObject,
      "currentDate": Date().timeIntervalSince1970 as AnyObject,
      "usersUID": usersUID as AnyObject,
    ]
    
    chatRoomRef.updateChildValues([key: data] as [String: AnyObject]) { error, ref in
      completionHandler((error == nil))
    }
  }
}
