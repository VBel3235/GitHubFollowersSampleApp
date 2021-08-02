//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Владислав Белов on 23.07.2021.
//

import UIKit

class UserInfoVC: UIViewController {
    
    let headerView              = UIView()
    let itemViewOne             = UIView()
    let itemViewTwo             = UIView()
    
    var itemViews: [UIView]     = []
    
    
    var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfo()
   
        
    }
    
    func getUserInfo(){
        NetworkManager.shared.getUserName(for: userName!) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result{
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: "\(error.rawValue)", buttonTitle: "OK")
            case .success(let user):
                DispatchQueue.main.async {
                    self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
                }
               
            }
        }
    }
    
    func configureViewController(){
        
         view.backgroundColor = .systemBackground
         let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
         navigationItem.rightBarButtonItem = doneButton
    }
    
    
    
    func layoutUI(){
        let padding: CGFloat = 20
        itemViews = [headerView, itemViewOne, itemViewTwo]
        for itemView in itemViews{
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo:  view.trailingAnchor, constant: -padding),
            ])
            
        }
      
        
        itemViewOne.backgroundColor = .systemPink
        itemViewTwo.backgroundColor = .systemBlue
        
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        itemViewOne.translatesAutoresizingMaskIntoConstraints = false
        itemViewTwo.translatesAutoresizingMaskIntoConstraints = false
       
        let itemHeight: CGFloat = 140
        NSLayoutConstraint.activate([
      
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            
            
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }


}
