//
//  TasksScreenCoordinator.swift
//  Activities
//
//  Created by Chikinov Maxim on 17.03.2024.
//

import Foundation
import UIKit

class TasksScreenCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBar: UITabBarController
    
    init(navigationController: UINavigationController, tabBar: UITabBarController) {
        self.navigationController = navigationController
        self.tabBar = tabBar
    }
    
    func start() {
        let tasksController = UIViewController().createNavController()
        tasksController.tabBarItem.image = UIImage(systemName: "list.bullet.rectangle.portrait.fill")
        tasksController.tabBarItem.title = "Tasks"
        
        var controllers = tabBar.viewControllers ?? []
        controllers.append(tasksController)
        tabBar.viewControllers = controllers
    }
}
