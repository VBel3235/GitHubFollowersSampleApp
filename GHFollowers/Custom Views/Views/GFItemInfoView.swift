//
//  GFItemInfoView.swift
//  GHFollowers
//
//  Created by Владислав Белов on 23.08.2021.
//

import UIKit

enum itemInfoType{
    case repos
    case gists
    case following
    case followers
}

class GFItemInfoView: UIView {
    
    let symbolImageView = UIImageView()
    let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 14)
    let countLabel  =  GFTitleLabel(textAlignment: .center, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(){
        addSubview(symbolImageView)
        addSubview(titleLabel)
        addSubview(countLabel)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .label
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    func set(itemInfoType: itemInfoType, with count: Int){
        switch itemInfoType {
        case .repos:
            symbolImageView.image = UIImage(named: SFSymbols.repos)
            titleLabel.text = "Public repos"
           
        case.gists:
            symbolImageView.image = UIImage(named: SFSymbols.gists)
            titleLabel.text = "Public gists"
       
        case .followers:
            symbolImageView.image = UIImage(named: SFSymbols.followers)
            titleLabel.text = "Followers"
            
        case .following:
            symbolImageView.image = UIImage(named: SFSymbols.following)
            titleLabel.text = "Following"
        }
        countLabel.text = String(count)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
