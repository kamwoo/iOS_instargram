//
//  PhotoCollectionViewCell.swift
//  iOS_instargram
//
//  Created by wooyeong kam on 2021/09/23.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    
    private let photoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(photoImageView)
        contentView.clipsToBounds = true
        accessibilityLabel = "User post image"
        accessibilityHint = "Double tab to open post"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserPost){
        let url = model.thumbnailImage
        photoImageView.sd_setImage(with: url, completed: nil)
    }
    
    public func configure(debug imageName: String){
        photoImageView.image = UIImage(named: imageName)
    }
    
    
    
}
