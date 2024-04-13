//
//  NewsCoordinator.swift
//  Activities
//
//  Created by Chikinov Maxim on 11.04.2024.
//

import Foundation
import UIKit

class NewsCoordinator: Coordinator {
    
    // Common
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBar: UITabBarController
    
    // Context
    let screenNavigation = UINavigationController()
    
    init(navigationController: UINavigationController, tabBar: UITabBarController) {
        self.navigationController = navigationController
        self.tabBar = tabBar
        
        let viewModel = NewsViewModel()
        viewModel.coordinator = self
        let viewController = NewsViewController(viewModel: viewModel)
        viewController.tabBarItem.image = UIImage(systemName: "newspaper.fill")
        viewController.tabBarItem.title = "News"
        
        screenNavigation.pushViewController(viewController, animated: false)
        var controllers = tabBar.viewControllers ?? []
        controllers.append(screenNavigation)
        tabBar.viewControllers = controllers
    }
    
    func start() {
        screenNavigation.popToRootViewController(animated: true)
    }
}

extension NewsCoordinator: NewsViewModelNavigation {
    
}
