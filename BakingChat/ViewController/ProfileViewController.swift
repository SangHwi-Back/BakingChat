//
//  ProfileViewController.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/06/01.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    let VM = LoginViewModel.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func logoutButtonTouchUpInside(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: String(describing: ViewController.self))
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = UINavigationController(rootViewController: vc)
        VM.signOut()
    }
}
