//
//  PostViewController.swift
//  iOS_instargram
//
//  Created by wooyeong kam on 2021/08/03.
//

import UIKit

enum PostRenderType {
    case header(provider: User)
    case primaryContent(provider: UserPost)
    case actions(provider: String)
    case comments(provider: [PostComment])
}

struct PostRenderViewModel {
    let renderType: PostRenderType
}

class PostViewController: UIViewController {
    
    private var model: UserPost?
    
    private var renderModels = [PostRenderViewModel]()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(IGFeedPostTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostActionsTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self,
                           forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        
        return tableView
    }()
    
    init(model: UserPost?){
        self.model = model
        super.init(nibName: nil, bundle: nil)
        configureModels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureModels(){
        guard let userPostModel = self.model else {
            return
        }
        // Header
        renderModels.append(PostRenderViewModel(renderType: .header(provider: userPostModel.owner)))
        // Post
        renderModels.append(PostRenderViewModel(renderType: .primaryContent(provider: userPostModel)))
        // Actions
        renderModels.append(PostRenderViewModel(renderType: .actions(provider: "")))
        // Comments
        var comments = [PostComment]()
        for x in 0...4 {
            comments.append(PostComment(identifier: "123_\(x)",
                                        userName: "@kam",
                                        text: "hello",
                                        createdDate: Date(),
                                        likeCount: []))
        }
        renderModels.append(PostRenderViewModel(renderType: .comments(provider: comments)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderModels.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch renderModels[section].renderType {
        case .actions(_):
            return 1
        case .comments(let comments):
            return comments.count > 4 ? 4 : comments.count
        case .primaryContent(_):
            return 1
        case .header(_):
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = renderModels[indexPath.section]
        switch model.renderType {
        case .actions(let actions):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier,
                                                     for: indexPath) as! IGFeedPostActionsTableViewCell
            cell.delegate = self
            return cell
        case .comments(let comments):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier,
                                                     for: indexPath) as! IGFeedPostGeneralTableViewCell
            return cell
        case .primaryContent(let post):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier,
                                                     for: indexPath) as! IGFeedPostTableViewCell
            cell.configure(with: post)
            return cell
        case .header(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier,
                                                     for: indexPath) as! IGFeedPostHeaderTableViewCell
            cell.configure(with: user)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = renderModels[indexPath.section]
        switch model.renderType {
        case .actions(_):
            return 60
        case .comments(_):
            return 50
        case .primaryContent(_):
            return tableView.width
        case .header(_):
            return 70
        }
    }
}

extension PostViewController: IGFeedPostHeaderTableViewCellDelegate {
    func didTapbutton() {
        let actionSheet = UIAlertController(title: "Post options",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report Post",
                                            style: .destructive){ [weak self] _ in
            self?.reportPost()
        })
        actionSheet.addAction(UIAlertAction(title: "Cancle",
                                            style: .cancel,
                                            handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func reportPost(){
        
    }
}

extension PostViewController: IGFeedPostActionsTableViewCellDelegate {
    func didTapLikeButtonTap() {
        print("like")
    }
    
    func didTapCommentButtonTap() {
        print("comment")
    }
    
    func didTapSendButtonTap() {
        print("send")
    }
}
