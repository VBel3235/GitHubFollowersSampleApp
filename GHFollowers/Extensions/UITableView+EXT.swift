//
//  UITableView+EXT.swift
//  GHFollowers
//
//  Created by Владислав Белов on 31.08.2021.
//

import UIKit

extension UITableView{
    
    func removeExcessCells(){
        tableFooterView = UIView.init(frame: .zero)
    }
}
