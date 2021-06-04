//
//  ChatViewModel.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/05/31.
//

import Foundation
import Firebase

public let baseRef = Database.database().reference() // GoogleService-Info.plist의 정보에 따른 파이어베이스 프로젝트의 데이터베이스를 참조.

class LoginViewModel {
  // SIGNLETON
  static let instance = LoginViewModel()
  
  // REFERENCE - FIREBASE DATABASE
  let userRef = baseRef.child("user")
  
  var currentUserUid: String? {
    get {
      guard let uid = Auth.auth().currentUser?.uid else {
        return nil
      }
      
      return uid
    }
  }
  var currentUser: User!
  
  func authCreateUserInfo(uid: String, userData: [String: String]) {
    userRef.child(uid).updateChildValues(userData)
  }
  
  func signIn(email: String, pw: String, completion: @escaping (AuthDataResult?) -> Void) {
    Auth.auth().signIn(withEmail: email, password: pw) { (user, error) in
      guard error == nil, let uid = user?.user.uid else {
        print("Error occured during SIGN UP.")
        return
      }
      
      self.userRef.child(uid).getData { error, snapshot in
        if let dict = snapshot.value as? [String: AnyObject] {
          self.currentUser = User(uid: dict["uid"] as! String,
                                  email: dict["email"] as! String,
                                  username: dict["name"] as! String)
        }
        completion(user)
      }
    }
  }
  
  func getUsers(_ name: String, completionHandler: @escaping ([User])->Void) {
    userRef.observeSingleEvent(of: .value) { snapshot in
      if let result = snapshot.value as? [String: AnyObject] {
        
        var users = [User]()
        for (_, value) in result {
          //value = superuser
          users.append(User(uid: value["uid"] as! String,
                            email: value["email"] as! String,
                            username: value["name"] as! String)
          )
        }
        
        if users.isEmpty == false {
          completionHandler(users)
        }
      }
    }
  }
  
  func saveIDToUserDefaults(value: Bool) {
    UserDefaults.standard.setValue(value, forKeyPath: "idSaveChecked")
  }
  
  func saveAutoLoginToUserDefaults(value: Bool) {
    
    UserDefaults.standard.setValue(value, forKeyPath: "autoLoginChecked")
    
    if value {
      UserDefaults.standard.setValue(true, forKeyPath: "idSaveChecked")
    }
  }
  
  func saveLoginInfo(email: String?, password: String?) {
    
    if let email = email {
      UserDefaults.standard.setValue(
        Data(email.utf8).base64EncodedString(),
        forKeyPath: "IDSaved"
      )
    }
    
    if let password = password {
      UserDefaults.standard.setValue(
        Data(password.utf8).base64EncodedString(),
        forKeyPath: "PWSaved"
      )
    }
  }
  
  func getIDSavedChekced() -> Bool {
    if UserDefaults.standard.object(forKey: "idSaveChecked") != nil {
      return UserDefaults.standard.bool(forKey: "idSaveChecked")
    }
    return false
  }
  
  func getAutoLoginChecked() -> Bool {
    if UserDefaults.standard.object(forKey: "autoLoginChecked") != nil {
      UserDefaults.standard.bool(forKey: "autoLoginChecked")
    }
    return false
  }
  func getSavedID() -> String? {
    if let base64String = UserDefaults.standard.string(forKey: "IDSaved"), let data = Data(base64Encoded: base64String) {
      return String(data: data, encoding: .utf8)
    } else {
      return nil
    }
  }
  
  func getSavedPassword() -> String? {
    if let base64String = UserDefaults.standard.string(forKey: "PWSaved"), let data = Data(base64Encoded: base64String) {
      return String(data: data, encoding: .utf8)
    } else {
      return nil
    }
  }
}
