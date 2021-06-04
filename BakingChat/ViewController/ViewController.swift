//
//  ViewController.swift
//  BakingChat
//
//  Created by 백상휘 on 2021/05/31.
//

import UIKit
import FirebaseAuth

enum LoginResult: String {
  case success = "로그인 되셨습니다."
  case fail = "이메일과 비밀번호를 다시 확인해주세요."
}

class ViewController: UIViewController {
  
  // IBOUTLETS
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passWordTextField: UITextField!
  @IBOutlet weak var autoLoginButton: UIButton!
  @IBOutlet weak var idSaveButton: UIButton!
  @IBOutlet weak var logInButton: UIButton!
  
  @IBOutlet var editingViews: [UIView]!
  // PROPERTIES
  /** LoginViewModel.swift */
  let VM = LoginViewModel.instance
  var idSaveChecked: Bool! {
    didSet {
      idSaveButton.isChecked(idSaveChecked)
    }
  }
  var autoLoginChecked: Bool! {
    didSet {
      autoLoginButton.isChecked(autoLoginChecked)
    }
  }
  
  // VIEW LIFE CYCLE
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSelector(_:))))
    
    logInButton.activateButton(false)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    idSaveChecked = VM.getIDSavedChekced()
    if idSaveChecked {
      emailTextField.text = VM.getSavedID()
    }
    autoLoginChecked = VM.getAutoLoginChecked()
    if autoLoginChecked {
      passWordTextField.text = VM.getSavedPassword()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    VM.saveIDToUserDefaults(value: idSaveChecked)
    VM.saveAutoLoginToUserDefaults(value: autoLoginChecked)
    
    if autoLoginChecked {
      VM.saveLoginInfo(email: emailTextField.text, password: passWordTextField.text)
    } else if idSaveChecked {
      VM.saveLoginInfo(email: emailTextField.text, password: nil)
    }
    
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
  }
  
  @IBAction func idSaveButtonTouchUpInside(_ sender: UIButton) {
    
    idSaveChecked.toggle()
    VM.saveIDToUserDefaults(value: idSaveChecked)
  }
  
  @IBAction func autoLoginButtonTouchUpInside(_ sender: UIButton) {
    
    autoLoginChecked.toggle()
    VM.saveAutoLoginToUserDefaults(value: autoLoginChecked)
    
    let alert = UIAlertController(title: nil, message: "missing Parts!", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Confirmed", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func logInButtonTouchUpInside(_ sender: UIButton) {
    
    guard let email = emailTextField.text, let password = passWordTextField.text else {
      return
    }
    
    dismissSelector(nil)
    VM.signIn(email: email, pw: password) { userSignIn in
      
      var result: LoginResult = .fail
      
      if userSignIn != nil {
        result = .success
      }
      
      let alert = UIAlertController(title: result.rawValue,
                                    message: (result == .success ? "반갑습니다. \("")" : ""),
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "닫기",
                                    style: (result == .success ? .default : .destructive),
                                    handler: { _ in
                                      if result == .success {
                                        DispatchQueue.main.async {
                                          self.performSegue(withIdentifier: "ChatMainViewController", sender: self)
                                        }
                                      }
                                    }))
      
      DispatchQueue.main.async {
        self.present(alert, animated: true, completion: nil)
      }
    }
  }
}

extension ViewController {
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

extension ViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let result = !(emailTextField.text?.isEmpty ?? true) && !(passWordTextField.text?.isEmpty ?? true)
    logInButton.activateButton(result)
    return true
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    DispatchQueue.main.async { UIView.animate(withDuration: 0.3) {
      self.view.frame.origin.y -= AppDelegate.keyboardHeight
    }}
    
    return true
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    DispatchQueue.main.async { UIView.animate(withDuration: 0.3) {
      self.view.frame.origin.y = 0
    }}
    
    return true
  }
}
