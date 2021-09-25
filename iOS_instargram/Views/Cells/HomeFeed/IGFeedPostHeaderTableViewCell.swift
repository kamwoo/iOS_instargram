//
//  IGFeedPostHeaderTableViewCell.swift
//  iOS_instargram
//
//  Created by wooyeong kam on 2021/09/02.
//

import UIKit
import SDWebImage

protocol IGFeedPostHeaderTableViewCellDelegate: AnyObject {
    func didTapbutton()
}

class IGFeedPostHeaderTableViewCell: UITableViewCell {

    static let identifier = "IGFeedPostHeaderTableViewCell"
    
    public weak var delegate: IGFeedPostHeaderTableViewCellDelegate?
    
    private let profilePhotoImgeView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let moreButton: UIButton = {
       let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profilePhotoImgeView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(moreButton)
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
    }
    
    @objc private func didTapMoreButton(){
        delegate?.didTapbutton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: User) {
        nameLabel.text = model.username
        profilePhotoImgeView.image = UIImage(systemName: "person.circle")
//        profilePhotoImgeView.sd_setImage(with: model.profilePhoto, completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = contentView.height - 4
        profilePhotoImgeView.frame = CGRect(x: 2, y: 2, width: size, height: size)
        profilePhotoImgeView.layer.cornerRadius = size/2
        
        nameLabel.frame = CGRect(x: profilePhotoImgeView.right+10,
                                 y: 2,
                                 width: contentView.width-(size*2)-15,
                                 height: contentView.height-4)
        
        moreButton.frame = CGRect(x: contentView.width-size, y: 2, width: size, height: size)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePhotoImgeView.image = nil
        nameLabel.text = nil
    }
}
