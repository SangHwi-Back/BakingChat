//
//  CreateChatRoomTableViewCell.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/06/01.
//

import UIKit

class CreateChatRoomTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  var user: User?
  var delegate: CreateChatRoomDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func deleteButtonTouchUpInside(_ sender: UIButton) {
    if let uid = user?.uid {
      delegate?.updateUsers(uid: uid)
    }
  }
}
