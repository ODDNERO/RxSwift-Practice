//
//  TapBarController.swift
//  RxSwiftPractice
//
//  Created by NERO on 8/9/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shoppingVC = UINavigationController(rootViewController: ShoppingViewController())
        shoppingVC.tabBarItem = UITabBarItem(title: "", 
                                             image: UIImage(systemName: "cart.badge.plus"),
                                             selectedImage: UIImage(systemName: "cart.fill.badge.plus"))
        
        let boxOfficeVC = UINavigationController(rootViewController: BoxOfficeViewController())
        boxOfficeVC.tabBarItem = UITabBarItem(title: "",
                                              image: UIImage(systemName: "movieclapper"),
                                              selectedImage: UIImage(systemName: "movieclapper.fill"))
        
        setViewControllers([shoppingVC, boxOfficeVC], animated: true)
        tabBar.tintColor = .black
        selectedIndex = 0
    }
}
