//
//  SearchMemberViewController.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/06/01.
//

import UIKit

class SearchMemberViewController: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  let VM = LoginViewModel.instance
  
  var users = [User]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    VM.getUsers("") { result in
      self.users = result
    }
  }
  
  @IBAction func addChatRoom(_ sender: UIBarButtonItem) {
    
    var message = ""
    
    if tableView.indexPathsForSelectedRows?.isEmpty == false {
      message = "사용자를 선택해주시기 바랍니다."
    }
    if (tableView.indexPathsForSelectedRows?.count ?? 0) >= 2 {
      message = "채팅방 사용자는 두 명 이상 선택해주시기 바랍니다."
    }
    
    guard message.isEmpty == false else {
      
      let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: nil))
      present(alert, animated: true, completion: nil)
      return
    }
    
    if let vc = storyboard?.instantiateViewController(withIdentifier: "CreateChatRoomViewController") as? CreateChatRoomViewController {
      
      var param = [User]()
      
      tableView.indexPathsForSelectedRows?.forEach({ indexPath in
        param.append(users[indexPath.row])
      })
      
      vc.modalPresentationStyle = .overFullScreen
      vc.modalTransitionStyle = .crossDissolve
      vc.users = param
//      vc.sender = self
//      vc.show()
      present(vc, animated: true, completion: nil)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  }
}

extension SearchMemberViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    users.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMemberTableViewCell", for: indexPath) as! SearchMemberTableViewCell
    let data = users[indexPath.row]
    cell.nameLabel.text = data.username
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let cell = tableView.cellForRow(at: indexPath) {
      cell.contentView.backgroundColor = cell.isSelected ? .systemGray5 : .systemBackground
    }
  }
}

//extension SearchMemberViewController: UIViewControllerTransitioningDelegate {
//  func presentationController(forPresented presented: UIViewController,
//                              presenting: UIViewController?,
//                              source: UIViewController) -> UIPresentationController? {
//    let modalViewRect = CGRect(x: (self.view.frame.width - 330) / 2,
//                               y: (self.view.frame.height - 300) / 2,
//                               width: 330,
//                               height: 300)
//  }
//}
