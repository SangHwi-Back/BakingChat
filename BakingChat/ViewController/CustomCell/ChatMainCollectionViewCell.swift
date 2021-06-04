//
//  ChatMainCollectionViewCell.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/06/01.
//

import UIKit

class ChatMainCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var userName: UIButton!
  
  var delegate: ChatMainViewProtocol?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  @IBAction func userNameButtonTouchUpInsdie(_ sender: UIButton) {
    if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController {
      
    }
  }
  
}
