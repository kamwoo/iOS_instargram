//
//  RegistrationViewController.swift
//  iOS_instargram
//
//  Created by wooyeong kam on 2021/08/03.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    private let logoView : UIView = {
       let view = UIView()
        view.clipsToBounds = true
        let backgroundImage = UIImageView(image: UIImage(named: "instargram_logo"))
        backgroundImage.contentMode = .scaleAspectFit
        backgroundImage.backgroundColor = .none
        backgroundImage.frame = CGRect(x: 20, y: view.safeAreaInsets.top, width: 300, height: 50)
        view.addSubview(backgroundImage)
        return view
    }()
    
    private let userNameField: UITextField = {
       let field = UITextField()
        field.placeholder = "아이디를 입력해주세요"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let EmailField: UITextField = {
       let field = UITextField()
        field.placeholder = "이메일을 입력해주세요"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
         field.placeholder = "비밀번호를 입력해주세요"
         field.returnKeyType = .continue
         field.leftViewMode = .always
         field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
         field.autocorrectionType = .no
         field.autocapitalizationType = .none
         field.layer.masksToBounds = true
         field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
         return field
    }()
    
    private let registerButton : UIButton = {
        let button = UIButton()
        button.setTitle("계정 만들기", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
       return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(logoView)
        view.addSubview(userNameField)
        view.addSubview(EmailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logoView.frame = CGRect(x: 20, y: view.safeAreaInsets.top+30, width: view.width-40, height: 52)
        userNameField.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 100, width: view.width-40, height: 52)
        EmailField.frame = CGRect(x: 20, y: userNameField.bottom + 10, width: view.width-40, height: 52)
        passwordField.frame = CGRect(x: 20, y: EmailField.bottom + 10, width: view.width-40, height: 52)
        registerButton.frame = CGRect(x: 20, y: passwordField.bottom + 10, width: view.width-40, height: 52)
        
        registerButton.addTarget(self, action: #selector(didTapRegister), for:.touchUpInside )
        userNameField.delegate = self
        EmailField.delegate = self
        passwordField.delegate = self
    }
    
    @objc private func didTapRegister() {
        EmailField.resignFirstResponder()
        userNameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = EmailField.text, !email.isEmpty,
              let username = userNameField.text, !username.isEmpty,
              let password = passwordField.text, !password.isEmpty
        else {
            return
        }
        
        AuthManager.shared.registerNewUser(username: username, email: email, password: password){[weak self] success in
            DispatchQueue.main.async {
                if success {
                    print("success")
                }
                else {
                    print("fail")
                }
            }
        }
        
    }
    

}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameField {
            EmailField.becomeFirstResponder()
        }
        else if textField == EmailField {
            passwordField.becomeFirstResponder()
        }
        else{
            didTapRegister()
        }
        return true
    }
}
