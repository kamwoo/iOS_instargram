//
//  FormTableViewCell.swift
//  iOS_instargram
//
//  Created by wooyeong kam on 2021/09/02.
//

import UIKit

protocol FormTableViewCellDelegate: AnyObject {
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updateModel: EditProfileFormModel)
}

class FormTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifier = "FormTableViewCell"
    
    public weak var delegate: FormTableViewCellDelegate?
    
    private var model: EditProfileFormModel?
    
    private let formlabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let filed: UITextField = {
        let filed = UITextField()
        filed.returnKeyType = .done
        return filed
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(formlabel)
        contentView.addSubview(filed)
        filed.delegate = self
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: EditProfileFormModel){
        self.model = model
        formlabel.text = model.label
        filed.placeholder = model.placeholder
        filed.text = model.value
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        formlabel.text = nil
        filed.placeholder = nil
        filed.text = nil
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        formlabel.frame = CGRect(x: 5,
                                 y: 0,
                                 width: contentView.width/3,
                                 height: contentView.height)
        filed.frame = CGRect(x: formlabel.right + 5,
                                 y: 0,
                                 width: contentView.width - 10 - formlabel.width,
                                 height: contentView.height)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        model?.value = textField.text
        guard let model = model else {
            return true
        }
        delegate?.formTableViewCell(self, didUpdateField: model)
        textField.becomeFirstResponder()
        return true
    }
    
}
