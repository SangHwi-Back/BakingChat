//
//  ChatRoomViewModel.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/06/01.
//

import Foundation

class ChatRoomViewModel {
  
  static let instance = ChatRoomViewModel()
  
  let messageRef = baseRef.child("message")
  
  var messages = [Message]()
  
  func fetchMessages(_ key: String?, completionHandler: @escaping ()->Void) {
    
    if let groupId = key {
      messageRef.observe(.childAdded) { snapshot in
        
        print("\((snapshot.value as! [String: AnyObject])["groupKey"] as! String) == \(groupId)")
        if let dict = snapshot.value as? [String: AnyObject], (dict["groupKey"] as! String) == groupId {
          
          let message = Message(fromUID: dict["fromUserId"] as! String,
                                text: dict["text"] as! String,
                                timestamp: dict["timestamp"] as! NSNumber,
                                groupKey: dict["groupKey"] as! String)
          self.messages.insert(message, at: 0)
        }
        
        completionHandler()
      }
    }
  }
  
  func getRoomTitle(_ key: String?, completionHandler: @escaping (String?) -> Void) {
    
    if let key = key {
      
      ChatMainViewModel.instance.chatRoomRef.child(key).observeSingleEvent(of: .value) { snapshot in
        
        if let data = snapshot.value as? [String: AnyObject],
           let title = data["name"] as? String {
          completionHandler(title)
        } else {
          completionHandler(nil)
        }
      }
    } else {
      completionHandler(nil)
    }
  }
  
  func sendMessage(message: String, groupKey: String?, completionHandler: @escaping (Bool)->Void) {
    
    guard let fromUID = LoginViewModel.instance.currentUserUid, let groupKey = groupKey else {
      completionHandler(false)
      return
    }
    
    let data: [String: AnyObject] = [
      "fromUserId": fromUID as AnyObject,
      "text": NSString(string: message),
      "timestamp": NSNumber(value: Date().timeIntervalSince1970),
      "groupKey": groupKey as AnyObject
    ]
    
    messageRef.updateChildValues([messageRef.childByAutoId().key!:data]) { (error, ref) in
      
      completionHandler(error==nil)
      self.messageRef.child(groupKey).child("messages").updateChildValues([ref.key: 1])
    }
  }
}
