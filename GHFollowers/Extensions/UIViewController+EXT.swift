//
//  UIViewController+EXT.swift
//  GHFollowers
//
//  Created by Владислав Белов on 12.07.2021.
//


import UIKit
import SafariServices

fileprivate var containerView: UIView!

extension UIViewController{
    
    func presentGFAlert(title: String, message: String, buttonTitle: String){
     
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            present(alertVC, animated: true)
        
    }
    
    func presentDefaultError(){
            let alertVC = GFAlertVC(title: "Something went wrong",
                                    message: "We were unable to comlete your task, please try again later",
                                    buttonTitle: "OK")
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            present(alertVC, animated: true)
        
    }
  
    func presentSafariVC(with url: URL){
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        self.present(safariVC, animated: true, completion: nil)
    }
}
