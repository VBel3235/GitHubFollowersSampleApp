//
//  Date+EXT.swift
//  GHFollowers
//
//  Created by Владислав Белов on 24.08.2021.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String{
        let dateFormatter               = DateFormatter()
        dateFormatter.dateFormat        = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
