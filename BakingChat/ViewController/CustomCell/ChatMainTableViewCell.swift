//
//  ChatMainTableViewCell.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/06/01.
//

import UIKit

class ChatMainTableViewCell: UITableViewCell {
  
  @IBOutlet weak var currentDate: UILabel!
  @IBOutlet weak var chatRoomName: UILabel!
  
  @IBOutlet weak var currentName: UILabel!
  @IBOutlet weak var currentContent: UILabel!
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var chatRoom: ChatRoom!
  var key: String!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    collectionView.delegate = self
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

extension ChatMainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    let cnt = chatRoom.messages.count
    return (cnt > 5 ? 5 : cnt)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatMainCollectionViewCell", for: indexPath) as! ChatMainCollectionViewCell
    let data = chatRoom.messages.first
    
    cell.userName.setTitle(data?.key, for: .normal)
    
    return cell
  }
}
