//
//  ChatRoomViewController.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/06/01.
//

import UIKit

protocol ChatRoomProtocol {
    func reloadCollectionView()
}

class ChatRoomViewController: UIViewController {
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let VM = ChatRoomViewModel.instance
    var groupKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSelector(_:))))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //    tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        VM.messages.removeAll()
        VM.fetchMessages(groupKey) {
            self.tableView.reloadData()
        }
        VM.getRoomTitle(groupKey) { title in
            self.navigationItem.title = title
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    @IBAction func sendButtonTouchUpInside(_ sender: UIButton) {
        VM.sendMessage(message: contentTextView.text, groupKey: self.groupKey) { result in
            self.contentTextView.text = nil
            self.tableView.reloadData()
        }
    }
}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        VM.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomTableViewCell", for: indexPath) as! ChatRoomTableViewCell
        
        //    cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        let data = VM.messages[indexPath.row]
        let isMine = (data.fromUID == LoginViewModel.instance.currentUserUid)
        
        cell.titleLabel.textAlignment = isMine ? .right : .left
        cell.timestamp.textAlignment = isMine ? .right : .left
        
        cell.titleLabelLeadingConstraint.constant = isMine ? 16 : 0
        cell.titleLabelTrailingConstraint.constant = isMine ? 0 : 16
        cell.timestampLeadingConstraint.constant = isMine ? 16 : 0
        cell.timestampTrailingConstraint.constant = isMine ? 0 : 16
        
        cell.titleLabel.text = data.text
        cell.timestamp.text = Date(timeIntervalSince1970: data.timestamp.doubleValue).formattedString(format: "yyyy-MM-dd hh:mm")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ChatRoomTableViewCell
        cell.setSelected(false, animated: false)
    }
}

extension ChatRoomViewController {
    
    @objc func dismissSelector(_ sender: Any?) {
        self.view.endEditing(true)
        DispatchQueue.main.async { UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }}
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            DispatchQueue.main.async { UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y -= keyboardRectangle.height
            }}
        }
    }
}

extension ChatRoomViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        dismissSelector(nil)
        return true
    }
}
