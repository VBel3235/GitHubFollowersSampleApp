//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Владислав Белов on 23.07.2021.
//



import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}


class UserInfoVC: GFDataLoadingVC {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerView              = UIView()
    let itemViewOne             = UIView()
    let itemViewTwo             = UIView()
    let datelabel               = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView]     = []
    
    weak var delegate: UserInfoVCDelegate?
    var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        cnofigureScrollView()
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
                self.presentGFAlert(title: "Something went wrong", message: "\(error.rawValue)", buttonTitle: "OK")
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUIElements(with: user)
                }
               
            }
        }
    }
    
    func configureUIElements(with user: User){
        
      
        
      
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: GFFollowerItemVC(follower: user, delegate: self), to: self.itemViewTwo)
        self.datelabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    func configureViewController(){
        
         view.backgroundColor = .systemBackground
         let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
         navigationItem.rightBarButtonItem = doneButton
    }
    
    func cnofigureScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
      
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
      
    }
    
    
    
    func layoutUI(){
        let padding: CGFloat = 20
        itemViews = [headerView, itemViewOne, itemViewTwo, datelabel]
        for itemView in itemViews{
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor, constant: -padding),
            ])
        }
        let itemHeight: CGFloat = 140
        NSLayoutConstraint.activate([
      
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            datelabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            datelabel.heightAnchor.constraint(equalToConstant: 50)
            
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

extension UserInfoVC: GFFollowerItemVCDelegate{
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else { presentGFAlert(title: "No followers", message: "This user has no followers", buttonTitle: "So sad :(")
            return
        }
        delegate?.didRequestFollowers(for: user.login)
        dismissVC()
    }
    
 
    
    
}

extension UserInfoVC: GFRepoItemVCDelegate{
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlert(title: "Invalid URL", message: "URL attached to that user is invalid", buttonTitle: "OK")
            return
        }
        presentSafariVC(with: url)
    }
    
  
    
   
    
    
}

//extension UserInfoVC: ItemInfoVCDelegate{
//    func didTapGitHubProfile(for user: User) {
//        guard let url = URL(string: user.htmlUrl) else {
//            presentGFAlertOnMainThread(title: "Invalid URL", message: "URL attached to that user is invalid", buttonTitle: "OK")
//            return
//        }
//       presentSafariVC(with: url)
//    }
//    
//    func didTapGetFollowers(for user: User) {
//        guard user.followers != 0 else { presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers", buttonTitle: "So sad :(")
//            return
//        }
//        delegate?.didRequestFollowers(for: user.login)
//        dismissVC()
//    }
//    
//    
//   
//    
//   
//    
//    
//}
