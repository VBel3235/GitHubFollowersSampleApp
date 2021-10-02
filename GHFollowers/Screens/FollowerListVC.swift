//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Владислав Белов on 10.07.2021.
//

import UIKit



class FollowerListVC: GFDataLoadingVC {
    
    enum Section {
        case main
    }
    
    
    var collectionView: UICollectionView!
    var userName: String!
    var page                                    = 1
    var hasMoreFollowers                        = true
    
    var filteredFollowers: [Follower]           = []
    var followers: [Follower]                   = []
    var isSearching                             = false
    var isLoadingMoreFollower                   = false
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(user: String) {
        super.init(nibName: nil, bundle: nil)
        self.userName                           = user
        self.title                              = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(username: userName, page: page)
        configureDataSource()
        configureSearchController()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowlayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.resuseID)
    }
    
    func configureViewController(){
        view.backgroundColor                                   = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureSearchController(){
        let searchController                    = UISearchController()
        searchController.searchResultsUpdater   = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder  = "Search for a username"
        navigationItem.searchController         = searchController
        
    }
    
    func getFollowers(username: String, page: Int){
        showLoadingView()
        isLoadingMoreFollower = true
        Task{
            do {
                let followers = try await NetworkManager.shared.getFollowers(username: username, page: page)
                updateUI(with: followers)
                dismissLoadingView()
            } catch  {
                if let gfError = error as? GFError{
                    self.presentGFAlert(title: "Bad stuff happened", message: gfError.rawValue, buttonTitle: "OK")
                } else {
                    self.presentDefaultError()
                }
                dismissLoadingView()
            }
            // Simplier way
//            guard let followers = try? await NetworkManager.shared.getFollowers(username: username, page: page) else {
//                presentDefaultError()
//                dismissLoadingView()
//                return
//            }
//            updateUI(with: followers)
//            dismissLoadingView()
//
        }
     
        
//        NetworkManager.shared.getFollowers(username: username, page: page) { [weak self] result in
//
//            guard let self = self else { return }
//            self.dismissLoadingView()
//            switch result {
//            case .success(let followers):
//                self.updateUI(with: followers)
//            case .failure(let error):
//                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "OK")
//            }
//            self.isLoadingMoreFollower = false
//
//        }
    }
    
    func updateUI(with followers: [Follower]){
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
            let message = "This user doesnt have any followers. Go follow him 😀"
            DispatchQueue.main.async {
                self.showEmptyStateView(with: message, in: self.view)
            }
            return
        }
        self.updateData(on: self.followers)
    }
    
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.resuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]){
        var snapShot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapShot.appendSections([.main])
        snapShot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
    
    }
    
    @objc func addButtonTapped(){
        showLoadingView()
        NetworkManager.shared.getUserName(for: userName) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result{
            case .success(let user):
                self.addUserToFavourites(user: user)
                
            case .failure(let error):
                self.presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }

    func addUserToFavourites(user: User){
        let favourite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistanceManager.update(favourite: favourite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.presentGFAlert(title: "Success!", message: "You have successfully favourited this user 🎉", buttonTitle: "Hooray!")
                return
            }
            self.presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
        }
    }
}

extension FollowerListVC: UICollectionViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY              = scrollView.contentOffset.y
        let contentHeight        = scrollView.contentSize.height
        let height               = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollower else {
                return
            }
            page += 1
            getFollowers(username: userName, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower                = activeArray[indexPath.item]
        let destVC                  = UserInfoVC()
        destVC.userName             = follower.login
        destVC.delegate             = self
        let navController           = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
        
    }
}

extension FollowerListVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        filteredFollowers = followers.filter{ $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
    
   
    
}
extension FollowerListVC: UserInfoVCDelegate{
    func didRequestFollowers(for username: String) {
        self.userName   = username
        title           = username
        page            = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
        
    }
    
    
}
