//
//  LoginViewController.swift
//  iOS_instargram
//
//  Created by wooyeong kam on 2021/08/03.
//

import UIKit
import SafariServices

struct Constants {
    static let cornerRadius : CGFloat = 5.0
}

class LoginViewController: UIViewController {
    // MARK: -UI configure
    private let userNameEmailField: UITextField = {
       let field = UITextField()
        field.placeholder = "아이디 또는 이메일"
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
         field.placeholder = "비밀번호"
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
    
    private let loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
       return button
    }()
    
    private let termsButton : UIButton = {
       let button = UIButton()
        button.setTitle("서비스 기간", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    private let privacyButton : UIButton = {
        let button = UIButton()
         button.setTitle("개인정보정책", for: .normal)
         button.setTitleColor(.secondaryLabel, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
         return button
    }()
    
    private let createAccountButton : UIButton = {
       let button = UIButton()
        button.setTitle("아직 계정이 없으신가요? 계정만들기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let headerView: UIView = {
       let header = UIView()
        header.clipsToBounds = true
        let backgroundImageView = UIImageView(image: UIImage(named: "gradient"))
        header.addSubview(backgroundImageView)
        return header
    }()

    
// MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        userNameEmailField.delegate = self
        passwordField.delegate = self
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
        
    }
    
    @objc private func didTapLoginButton() {
        passwordField.resignFirstResponder()
        userNameEmailField.resignFirstResponder()
        
        guard let usernameEmail = userNameEmailField.text, !usernameEmail.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              password.count >= 8
        else {
            return
        }
        
        var username: String?
        var email: String?
        
        if usernameEmail.contains("@"), usernameEmail.contains("."){
            // email
            email = usernameEmail
        }else{
            // username
            username = usernameEmail
        }
        
        AuthManager.shared.loginUser(username: username, email: email, password: password){[weak self] result in
            DispatchQueue.main.async {
                if result {
                    //logged in
                    self?.dismiss(animated: true, completion: nil)
                }else{
                    //error
                    let alert = UIAlertController(title: "login error",
                                                  message: "로그인에 실패했습니다.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func didTapCreateAccountButton() {
        let vc = RegistrationViewController()
        vc.title = "계정 만들기"
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    @objc private func didTapTermsButton() {
        guard let url = URL(string: "https://www.facebook.com/help/instagram/termsofuse") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func didTapPrivacyButton() {
        guard let url = URL(string: "https://help.instagram.com/519522125107875") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: view.width,
                                  height: view.height)
        configureHeaderView()
        
        userNameEmailField.frame = CGRect(x: view.width/2 - (view.width - 90)/2,
                                          y: view.height/3 + 10,
                                          width: view.width - 90,
                                          height: 48)
        
        passwordField.frame = CGRect(x: view.width/2 - (view.width - 90)/2,
                                     y: userNameEmailField.bottom + 10,
                                     width: view.width - 90,
                                     height: 48)
        
        loginButton.frame = CGRect(x: view.width/2 - (view.width - 90)/2,
                                   y: passwordField.bottom + 10,
                                   width: view.width - 90,
                                   height: 43)
        
        createAccountButton.frame = CGRect(x: 25,
                                           y: view.height - view.safeAreaInsets.bottom - 100,
                                           width: view.width - 50,
                                           height: 52)
        
        termsButton.frame = CGRect(x: view.width/2 - 100,
                                   y: createAccountButton.bottom + 10,
                                   width: 100,
                                   height: 22)
        
        privacyButton.frame = CGRect(x: termsButton.right + 5,
                                   y: createAccountButton.bottom + 10,
                                   width: 100,
                                   height: 22)
        
    }
    
    private func configureHeaderView() {
        guard headerView.subviews.count == 1 else {
            return
        }
        
        guard let backgroundView = headerView.subviews.first else {
            return
        }
        
        backgroundView.frame = headerView.bounds
        
        let imageview = UIImageView(image: UIImage(named: "instargram_logo"))
        headerView.addSubview(imageview)
        imageview.contentMode = .scaleAspectFit
        imageview.backgroundColor = .none
        imageview.frame = CGRect(x: headerView.width/4,
                                 y: view.safeAreaInsets.top,
                                 width: headerView.width/2,
                                 height: view.height / 3)
    }
    
    private func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(userNameEmailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
        view.addSubview(createAccountButton)
        
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameEmailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            didTapLoginButton()
        }
        return true
    }
}
