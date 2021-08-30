//
//  FavouriteListVC.swift
//  GHFollowers
//
//  Created by Владислав Белов on 09.07.2021.
//

import UIKit

class FavouriteListVC: UIViewController {
    
    let tableView = UITableView()
    var favourites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavourites()
    }
    
    func getFavourites(){
        PersistanceManager.retrieveFavourites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favourites):
                if favourites.isEmpty{
                    self.showEmptyStateView(with: "There are no favourite users", in: self.view)
                } else {
                    self.favourites = favourites
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "SOmething went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        tableView.frame             = view.bounds
        tableView.rowHeight         = 80
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.register(FavouriteCell.self, forCellReuseIdentifier: FavouriteCell.resuseID)
    }
    

}

extension FavouriteListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.resuseID, for: indexPath) as! FavouriteCell
        let favourite = favourites[indexPath.row]
        cell.set(favourite: favourite)
        return cell
    }
    
    
}
