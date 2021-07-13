//
//  GFTextField.swift
//  GHFollowers
//
//  Created by Владислав Белов on 09.07.2021.
//

import UIKit

class GFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
   private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
    
    layer.cornerRadius          = 10
    layer.borderWidth           = 2
    layer.borderColor = UIColor.systemGray4.cgColor
    
    textColor                   = .label
    tintColor                   = .label
    textAlignment               = .center
    font = UIFont.preferredFont(forTextStyle: .title2)
    adjustsFontSizeToFitWidth   = true
    minimumFontSize             = 12
    keyboardType                = .default
    returnKeyType               = .go
    backgroundColor             = .tertiarySystemBackground
    autocorrectionType          = .no
    
    placeholder = "Enter a username"
    
    
    
    
    }

}
