//
//  TabBarController.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        customizeTabBarAppearance()
    }
    
    func setupTabBar() {
        let seriesListViewController = SeriesListFactory.make()
        
        let seriesListNavigationController = setupNavigationController(title: "Series", image: UIImage(systemName: "popcorn.fill"), viewController: seriesListViewController)
        
        viewControllers = [seriesListNavigationController]
    }
    
    func setupNavigationController(title: String, image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = image
        navigationController.tabBarItem.title = title
        return navigationController
    }
    
    func customizeTabBarAppearance() {
        let selectedColor = UIColor(named: "Cream")
    
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = selectedColor
        
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor(named: "DarkBlue")
        
    }
}
