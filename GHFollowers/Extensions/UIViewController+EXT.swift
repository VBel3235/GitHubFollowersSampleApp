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
    
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
  
    func presentSafariVC(with url: URL){
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        self.present(safariVC, animated: true, completion: nil)
    }
}
