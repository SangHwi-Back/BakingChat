//
//  UIAlertController+Extension.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/06/06.
//

import UIKit

class SimpleConfirmAlertController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var confirmActionButton: UIButton!
    
    var completionHandler: (()->Void)?
    var contents: String?
    var sender: UIViewController?
    var titleMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentsLabel.text = contents
        titleLabel.text = self.title
    }
    
    init() {
        super.init(nibName: "SimpleConfirmAlertController", bundle: Bundle.main)
    }
    
    convenience init(title: String?, alertMessage: String?, sender: UIViewController) {
        self.init()
        contents = alertMessage
        titleMessage = title
        self.sender = sender
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ confirmMessage: String? = "확인", confirmStyle: UIAlertAction.Style? = .destructive, completionHandler: (()->Void)? = nil) {
        DispatchQueue.main.async {
            self.completionHandler = completionHandler
            self.sender?.present(self, animated: true, completion: nil)
        }
    }
    
    @IBAction func confirmActionButtonTouchUpInside(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.dismiss(animated: true) {
                self.completionHandler?()
            }
        }
    }
}
