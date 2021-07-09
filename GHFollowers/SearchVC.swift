//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Владислав Белов on 09.07.2021.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView       = UIImageView()
    let userNameTextField   = GFTextField()
    let callFunctionButton  = GFButton(backgroundColor: .systemGreen, title: "Get Followers")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    func configureLogoImageView(){
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")!
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField(){
        view.addSubview(userNameTextField)
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
        
        
        ])
        
    }
    
    func configureCallToActionButton(){
        view.addSubview(callFunctionButton)
        NSLayoutConstraint.activate([
            callFunctionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callFunctionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callFunctionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callFunctionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }

}
