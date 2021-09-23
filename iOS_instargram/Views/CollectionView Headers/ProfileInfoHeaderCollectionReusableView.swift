//
//  ProfileInfoHeaderCollectionReusableView.swift
//  iOS_instargram
//
//  Created by wooyeong kam on 2021/09/23.
//

import UIKit

protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderDidTapPostButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapfollowersButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapfollowingButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapEditProfileButton(_ header: ProfileInfoHeaderCollectionReusableView)
}

class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    
    public weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate?
    
    private var profilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private var postButton: UIButton = {
        let button = UIButton()
        button.setTitle("posts", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private var followersButton: UIButton = {
        let button = UIButton()
        button.setTitle("followers", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private var followingButton: UIButton = {
        let button = UIButton()
        button.setTitle("following", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private var editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("edit", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private var nameLabel: UILabel = {
       let label = UILabel()
        label.text = "woo yeong"
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private var bioLabel: UILabel = {
       let label = UILabel()
        label.text = "this is first account"
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBlue
        clipsToBounds = true
        addSubviews()
        addButtonActions()
    }
    
    private func addButtonActions(){
        postButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapfollowingButton), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(didTapfollowersButton), for: .touchUpInside)
        editProfileButton.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
    }
    
    @objc private func didTapPostButton(){
        delegate?.profileHeaderDidTapPostButton(self)
    }
    @objc private func didTapfollowingButton(){
        delegate?.profileHeaderDidTapfollowingButton(self)
    }
    @objc private func didTapfollowersButton(){
        delegate?.profileHeaderDidTapfollowersButton(self)
    }
    @objc private func didTapEditProfileButton(){
        delegate?.profileHeaderDidTapEditProfileButton(self)
    }
    
    private func addSubviews(){
        addSubview(profilePhotoImageView)
        addSubview(postButton)
        addSubview(followersButton)
        addSubview(followingButton)
        addSubview(editProfileButton)
        addSubview(nameLabel)
        addSubview(bioLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let photoSize = width/4
        profilePhotoImageView.frame = CGRect( x: 5,
                                              y: 5,
                                              width: photoSize,
                                              height: photoSize).integral
        profilePhotoImageView.layer.cornerRadius = photoSize/2
        
        let buttonHeight = photoSize/2
        let countButtonWidth = (width-10-photoSize)/3
        
        postButton.frame = CGRect(x: profilePhotoImageView.right,
                                  y: 5,
                                  width: countButtonWidth,
                                  height: buttonHeight)
        
        followingButton.frame = CGRect(x: postButton.right,
                                  y: 5,
                                  width: countButtonWidth,
                                  height: buttonHeight)
        
        followersButton.frame = CGRect(x: followingButton.right,
                                  y: 5,
                                  width: countButtonWidth,
                                  height: buttonHeight)
        editProfileButton.frame = CGRect(x: profilePhotoImageView.right,
                                  y: 5 + buttonHeight,
                                  width: countButtonWidth*3,
                                  height: buttonHeight)
    }
}
