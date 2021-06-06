//
//  CreateChatRoomViewController.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/06/01.
//

import UIKit

protocol CreateChatRoomDelegate {
  func updateUsers(uid: String)
}

class CreateChatRoomViewController: UIViewController {
  
  @IBOutlet weak var visualEffectView: UIVisualEffectView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var customView: UIView!
  @IBOutlet weak var customViewBottomConstraint: NSLayoutConstraint!
  
  let VM = ChatMainViewModel.instance
  
  var users: [User]?
  var sender: UIViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSelector(_:))))
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow(_:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    
    if users != nil {
      tableView.reloadData()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
  }
  
  @IBAction func addChatRoomTouchUpInside(_ sender: UIButton) {
    
    guard let users = users, users.count >= 2 else {
      SimpleConfirmAlertController(title: "채팅방 생성 오류", alertMessage: "참여자 수를 다시 확인해주시기 바랍니다.", sender: self).show()
      return
    }
    
    VM.saveChatRoom(users, name: nameTextField.text ?? "") { [self] result in
      
      if result {
        
        let alert = UIAlertController(title: nil, message: "등록 완료하였습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
          if navigationController != nil {
            navigationController?.popViewController(animated: true)
          } else {
            dismiss(animated: true, completion: nil)
          }
        }))
        present(alert, animated: true, completion: nil)
        
      } else {
        
        let alert = UIAlertController(title: nil, message: "에러가 발생하였습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
      }
    }
  }
  
  @objc func dismissSelector(_ sender: Any?) {
    
    let textFieldDismiss = nameTextField.isFirstResponder
    self.view.endEditing(true)
    
    if textFieldDismiss {
      return
    }
    
    if navigationController != nil {
      navigationController?.popViewController(animated: true)
    } else {
      self.dismiss(animated: true, completion: nil)
    }
  }
}

extension CreateChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    users?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CreateChatRoomTableViewCell", for: indexPath) as! CreateChatRoomTableViewCell
    let data = users?[indexPath.row]
    cell.titleLabel.text = data?.username
    cell.user = data
    
    return cell
  }
}

extension CreateChatRoomViewController: UITextFieldDelegate {
  
  @objc func keyboardWillShow(_ notification: Notification) {
    
    guard let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
      return
    }
    
    if self.view.frame.height - customView.frame.maxY < keyboardRect.cgRectValue.height {
      DispatchQueue.main.async { UIView.animate(withDuration: 0.3) {
        self.customViewBottomConstraint.constant = keyboardRect.cgRectValue.height
      }}
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    DispatchQueue.main.async { UIView.animate(withDuration: 0.3) {
      self.customViewBottomConstraint.constant = 0
    }}
  }
}
extension CreateChatRoomViewController: CreateChatRoomDelegate {
  func updateUsers(uid: String) {
    if let inx = users?.firstIndex(where: {$0.uid == uid}), let _ = users?.remove(at: inx) {
      tableView.reloadData()
    }
  }
}
