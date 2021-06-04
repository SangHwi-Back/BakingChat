//
//  ChatRoomTableViewCell.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/06/01.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var titleLabelLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var titleLabelTrailingConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var timestamp: UILabel!
  @IBOutlet weak var timestampLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var timestampTrailingConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
