//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Владислав Белов on 24.08.2021.
//

import Foundation
import UIKit

class GFFollowerItemVC: GFItemInfoVC{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, with: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
}
