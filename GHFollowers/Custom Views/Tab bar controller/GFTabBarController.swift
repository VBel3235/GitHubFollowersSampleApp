//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Владислав Белов on 31.08.2021.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNC(), createFavouriteNC()]
         // Do any additional setup after loading the view.
    }
    
    func createSearchNC() -> UINavigationController{
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavouriteNC() -> UINavigationController{
        let favouriteVC = FavouriteListVC()
        favouriteVC.title = "Favourites"
        favouriteVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favouriteVC)
    }
    
  

}
