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
    
    var logoImageViewTopConstraint: NSLayoutConstraint!
    
    var isUserNameEntered: Bool {return !userNameTextField.text!.isEmpty}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubViews(logoImageView, userNameTextField, callFunctionButton)
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        
        createDismisskeyboardTapGesture()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    func createDismisskeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushFollowerListVC(){
        
        guard isUserNameEntered else {
            self.presentGFAlertOnMainThread(title: "No username", message: "Please enter a username, we need to know who to look for 😄", buttonTitle: "OK")
            return
            
        }
        
        userNameTextField.resignFirstResponder()
        
        
        let followerListVC = FollowerListVC(user: userNameTextField.text!)
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    func configureLogoImageView(){
       
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.GHLogo
        
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant)
        logoImageViewTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField(){
       
        userNameTextField.delegate = self
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
        
        
        ])
        
    }
    
    func configureCallToActionButton(){
        
        callFunctionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            callFunctionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callFunctionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callFunctionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callFunctionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }

}

extension SearchVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      pushFollowerListVC()
        return true
    }
}
