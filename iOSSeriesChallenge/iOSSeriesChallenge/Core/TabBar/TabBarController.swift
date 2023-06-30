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
        
        let seriesListNavigationController = setupNavigationController(image: UIImage(systemName: "popcorn.fill"), viewController: seriesListViewController)
        
        viewControllers = [seriesListNavigationController]
    }
    
    func setupNavigationController(image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = image
        return navigationController
    }
    
    func customizeTabBarAppearance() {
        let selectedColor = UIColor.blue
        let tabBarItemAppearance = UITabBarItem.appearance()
        tabBarItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barTintColor = .darkGray
        tabBarAppearance.tintColor = selectedColor
    }
}
