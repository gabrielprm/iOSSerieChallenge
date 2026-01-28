//
//  TabBarController.swift
//  iOSSeriesChallenge
//
//  Created by Gabriel do Prado Moreira on 29/06/23.
//

import UIKit

final class CustomTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        customizeTabBarAppearance()
    }
    
    // MARK: - Private Methods
    
    private func setupTabBar() {
        let seriesListViewController = SeriesListFactory.make()
        let seriesListNavigationController = createNavigationController(
            title: "Series",
            image: UIImage(systemName: "popcorn.fill"),
            viewController: seriesListViewController
        )
        viewControllers = [seriesListNavigationController]
    }
    
    private func createNavigationController(
        title: String,
        image: UIImage?,
        viewController: UIViewController
    ) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = image
        navigationController.tabBarItem.title = title
        return navigationController
    }
    
    private func customizeTabBarAppearance() {
        let selectedColor = UIColor(named: "Cream")
        UITabBar.appearance().tintColor = selectedColor
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor(named: "DarkBlue")
    }
}
