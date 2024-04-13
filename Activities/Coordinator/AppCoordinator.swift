//
//  AppCoordinator.swift
//  Activities
//
//  Created by Chikinov Maxim on 17.03.2024.
//

import Foundation
import UIKit
import SwiftUI

class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBar: UITabBarController
    
    init(navigationController: UINavigationController, tabBar: UITabBarController) {
        self.navigationController = navigationController
        self.tabBar = tabBar
    }
    
    init() {
        tabBar = UITabBarController()
        tabBar.tabBar.addShadow()
        
        navigationController = UINavigationController()
    }
    
    func start() {
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabBar, animated: false)
        
        // Add Tasks Screen
        let tasksCoordinator = TasksScreenCoordinator(navigationController: navigationController, tabBar: tabBar)
        children.append(tasksCoordinator)
        tasksCoordinator.start()
        
        // Add Groups Screen
        let groupsCoordinator = GroupsScreenCoordinator(navigationController: navigationController, tabBar: tabBar)
        children.append(groupsCoordinator)
        groupsCoordinator.start()
        
        // Add News Screen
        let newsCoordinator = NewsCoordinator(navigationController: navigationController, tabBar: tabBar)
        children.append(newsCoordinator)
        newsCoordinator.start()
    }
}

// MARK: - PreviewProvider
struct AppCoordinatorPreview: PreviewProvider {
    static var previews: some View {
        let coordinator = AppCoordinator()
        coordinator.start()
        
        return coordinator.navigationController
            .toPreview()
            .ignoresSafeArea()
    }
}
