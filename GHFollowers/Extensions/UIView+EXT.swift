//
//  UIView+EXT.swift
//  GHFollowers
//
//  Created by Владислав Белов on 31.08.2021.
//

import UIKit

extension UIView{
    
    func addSubViews(_ views: UIView...){
        for view in views { addSubview(view)}
    }
}
