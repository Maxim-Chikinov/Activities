//
//  AppCoordinator.swift
//  Activities
//
//  Created by Chikinov Maxim on 17.03.2024.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBar: UITabBarController
    
    init(navigationController: UINavigationController, tabBar: UITabBarController) {
        self.navigationController = navigationController
        self.tabBar = tabBar
    }
    
    func start() {
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabBar, animated: false)
        
        let mainCoordinator = MainScreenCoordinator(navigationController: navigationController, tabBar: tabBar)
        children.append(mainCoordinator)
        mainCoordinator.start()
        
        let tasksCoordinator = TasksScreenCoordinator(navigationController: navigationController, tabBar: tabBar)
        children.append(tasksCoordinator)
        tasksCoordinator.start()
    }
}
