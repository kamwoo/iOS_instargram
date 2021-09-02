//
//  SettingsViewController.swift
//  iOS_instargram
//
//  Created by wooyeong kam on 2021/08/03.
//

import UIKit
import SafariServices

struct settingCellModel {
    let title: String
    let handler: (() -> Void)
}

class SettingsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    private var data = [[settingCellModel]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels(){
        data.append([
            settingCellModel(title: "프로필 편집"){ [weak self] in
                self?.didTapEditProfile()
            },
            settingCellModel(title: "친구 초대"){ [weak self] in
                self?.didTapInviteFriends()
            },
            settingCellModel(title: "Post 저장"){ [weak self] in
                self?.didTapSaveOriginalPost()
            }
        ])
        
        data.append([
            settingCellModel(title: "서비스 이용 기간"){ [weak self] in
                self?.openURL(type: .terms)
            },
            settingCellModel(title: "정보 보안 정책"){ [weak self] in
                self?.openURL(type: .privacy)
            },
            settingCellModel(title: "도움말 / 고객센터"){ [weak self] in
                self?.openURL(type: .help)
            }
        ])
        
        data.append([
            settingCellModel(title: "로그아웃"){ [weak self] in
                self?.didTapLogOut()
            }
        ])
    }
    enum SettingURLType {
        case terms, privacy, help
        
    }
    
    private func openURL(type: SettingURLType){
        let urlString: String
        switch type {
        case .terms:
            urlString = "https://www.instagram.com/terms/accept/"
        case .privacy:
            urlString = "https://help.instagram.com/519522125107875"
        case .help:
            urlString = "https://help.instagram.com/"
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    private func didTapSaveOriginalPost() {
        
    }
    
    private func didTapInviteFriends() {
        
    }
    
    private func didTapEditProfile() {
        let vc = EditProfileViewController()
        vc.title = "프로필 편집"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
    private func didTapLogOut() {
        let actionSheet = UIAlertController(title: "로그아웃",
                                            message: "로그아웃 하시겠습니까?",
                                            preferredStyle: .alert)
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { _ in
            AuthManager.shared.logOut{ [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        let vc = LoginViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true){
                            self?.navigationController?.popViewController(animated: false)
                            self?.tabBarController?.selectedIndex = 0
                        }
                    }
                    else {
                        let actionSheet = UIAlertController(title: "에러발생",
                                                            message: "로그아웃에 실패했습니다",
                                                            preferredStyle: .alert)
                        actionSheet.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                    }
                }
            }
        }))
        
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
        
    }

}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
    
    
}
