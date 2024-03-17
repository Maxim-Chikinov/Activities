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
    
    // Context
    let screenNavigation = UINavigationController()
    
    // Main Screen
    private lazy var tasksModule: (viewModel: TasksViewControllerViewModel, controller: TasksViewController) = {
        let viewModel = TasksViewControllerViewModel()
        viewModel.coordinator = self
        let mainController = TasksViewController(viewModel: viewModel)
        mainController.tabBarItem.image = UIImage(systemName: "list.bullet.rectangle.fill")
        mainController.tabBarItem.title = "Tasks"
        return (viewModel, mainController)
    }()
    
    init(navigationController: UINavigationController, tabBar: UITabBarController) {
        self.navigationController = navigationController
        self.tabBar = tabBar
        
        screenNavigation.pushViewController(tasksModule.controller, animated: false)
        var controllers = tabBar.viewControllers ?? []
        controllers.append(screenNavigation)
        tabBar.viewControllers = controllers
    }
    
    func start() {
        screenNavigation.popToRootViewController(animated: true)
    }
}

extension TasksScreenCoordinator: TasksScreenNavigation {
    func addTask() {
        let taskVC = UIViewController()
        taskVC.view.backgroundColor = .white
        screenNavigation.present(taskVC, animated: true)
    }
    
    func goToTask() {
        let taskVC = UIViewController()
        taskVC.view.backgroundColor = .white
        screenNavigation.present(taskVC, animated: true)
    }
    
    func goToFilters() {
        
    }
}
