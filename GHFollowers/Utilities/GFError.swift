//
//  GFError.swift
//  GHFollowers
//
//  Created by Владислав Белов on 24.07.2021.
//

import Foundation

enum GFError: String, Error {
    
    case invalidUsername = "This username created invalid request. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "Data received from the server was invalid, please try again"
    case unableToFavourite = "There was an error favouriting this user. Please try again "
    case alreadyInFavourite = "You've already liked this user. You must have really liked it"
}
