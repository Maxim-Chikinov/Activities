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
    
    // Tasks Screen
    private lazy var tasksModule: (viewModel: TasksViewControllerViewModel, controller: TasksViewController) = {
        let viewModel = TasksViewControllerViewModel(state: .allTasks)
        viewModel.coordinator = self
        let viewController = TasksViewController(viewModel: viewModel)
        viewController.tabBarItem.image = UIImage(systemName: "list.bullet.rectangle.fill")
        viewController.tabBarItem.title = "Tasks"
        return (viewModel, viewController)
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
    func addTask(completion: (() -> ())?) {
        let vm = TaskViewControllerViewModel(state: .add, completion: completion)
        vm.coordinator = self
        let taskVC = TaskViewController(viewModel: vm)
        let nc = UINavigationController(rootViewController: taskVC)
        screenNavigation.present(nc, animated: true)
    }
    
    func goToTask(task: Task, completion: (() -> ())?) {
        let vm = TaskViewControllerViewModel(state: .update(task: task), completion: completion)
        vm.coordinator = self
        let taskVC = TaskViewController(viewModel: vm)
        screenNavigation.pushViewController(taskVC, animated: true)
    }
    
    func goToFilters() {
        
    }
}

extension TasksScreenCoordinator: TaskScreenNavigation {

}
