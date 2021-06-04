//
//  ChatMainViewController.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/06/01.
//

import UIKit

protocol ChatMainViewProtocol {
  func reloadTableView()
  func showModal(_ vc: UIViewController)
}

class ChatMainViewController: UIViewController {
  
  @IBOutlet weak var profileShowButton: UIButton!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var currentRoomButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  var VM: ChatMainViewModel!
  var loginVM: LoginViewModel = LoginViewModel.instance
  
  override func loadView() {
    super.loadView()
    
    let chatRoomViewModel = ChatMainViewModel()
    chatRoomViewModel.delegate = self
    VM = chatRoomViewModel
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.setNavigationBarHidden(false, animated: false)
    navigationController?.navigationItem.hidesBackButton = true
    
    profileShowButton.setTitle(loginVM.currentUser.email, for: .normal)
    nameLabel.text = loginVM.currentUser.username
    
    profileShowButton.titleLabel?.lineBreakMode = .byTruncatingTail
    currentRoomButton.titleLabel?.lineBreakMode = .byTruncatingTail
    
    VM.fetchChatRoomList()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    currentRoomButton.setTitle(UserDefaults.standard.string(forKey: "ChatRoomName"), for: .normal)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    navigationController?.navigationItem.hidesBackButton = false
  }
  
  @IBAction func currentRoomButtonTouchUpInside(_ sender: UIButton) {
    if let chatRoomKey = UserDefaults.standard.string(forKey: "ChatRoomKey") {
      performSegue(withIdentifier: "ChatRoomViewController", sender: chatRoomKey)
    } else {
      let alert = UIAlertController(title: nil, message: "저장된 채팅방이 없습니다.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: nil))
      present(alert, animated: true, completion: nil)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let dest = segue.destination as? ChatRoomViewController {
      
      if let cell = sender as? ChatMainTableViewCell {
        UserDefaults.standard.setValue(cell.chatRoomName.text, forKey: "ChatRoomName")
        UserDefaults.standard.setValue(cell.chatRoom.key, forKey: "ChatRoomKey")
        dest.groupKey = cell.chatRoom.key
        
      } else {
        
        dest.groupKey = sender as? String
      }
    }
  }
}

extension ChatMainViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    VM.chatRooms.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMainTableViewCell", for: indexPath) as! ChatMainTableViewCell
    let data = VM.chatRooms[indexPath.row]
    
    cell.currentDate.text = data.currentDate
    cell.chatRoomName.text = data.name
    
    if let currentData = data.messages.first {
      cell.currentName.text = String(currentData.value)
      cell.currentContent.text = currentData.key
    }
    
    cell.key = data.key
    cell.chatRoom = data
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! ChatMainTableViewCell
    cell.setSelected(false, animated: true)
    performSegue(withIdentifier: "ChatRoomViewController", sender: cell)
  }
}

extension ChatMainViewController: ChatMainViewProtocol {
  
  func reloadTableView() {
    self.tableView.reloadData()
  }
  
  func showModal(_ vc: UIViewController) {
    self.present(vc, animated: true, completion: nil)
  }
}
