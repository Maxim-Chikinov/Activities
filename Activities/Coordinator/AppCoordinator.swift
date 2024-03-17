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
        
        // Add Main Screen
        let mainCoordinator = MainScreenCoordinator(navigationController: navigationController, tabBar: tabBar)
        children.append(mainCoordinator)
        mainCoordinator.start()
        
        // Add Tasks Screen
        let tasksCoordinator = TasksScreenCoordinator(navigationController: navigationController, tabBar: tabBar)
        children.append(tasksCoordinator)
        tasksCoordinator.start()
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
