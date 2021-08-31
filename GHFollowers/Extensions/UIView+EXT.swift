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
    
    func pinToEdges(of superView: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
    }
}
