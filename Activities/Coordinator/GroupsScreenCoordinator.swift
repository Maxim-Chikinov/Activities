//
//  GroupsScreenCoordinator.swift
//  Activities
//
//  Created by Chikinov Maxim on 17.03.2024.
//

import Foundation
import UIKit

class GroupsScreenCoordinator: Coordinator {
    
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
        
        let viewModel = GroupsViewControllerViewModel()
        viewModel.coordinator = self
        let viewController = GroupsViewController(viewModel: viewModel)
        viewController.tabBarItem.image = UIImage(systemName: "house.fill")
        viewController.tabBarItem.title = "Groups"
        
        screenNavigation.pushViewController(viewController, animated: false)
        var controllers = tabBar.viewControllers ?? []
        controllers.append(screenNavigation)
        tabBar.viewControllers = controllers
    }
    
    func start() {
        screenNavigation.popToRootViewController(animated: true)
    }
}

extension GroupsScreenCoordinator: GroupsScreenNavigation, GroupScreenNavigation {
    func goToAddTasks(onAddTaskCompletion: ((Task) -> Void)?) {
        let viewModel = TasksViewControllerViewModel(state: .select(completion: onAddTaskCompletion))
        let viewController = TasksViewController(viewModel: viewModel)
        let nc = UINavigationController(rootViewController: viewController)
        screenNavigation.present(nc, animated: true)
    }
    
    func goToGroup(group: Group, completion: (() -> ())?) {
        let viewModel = GroupViewControllerViewModel(state: .edite(group: group), completion: completion)
        viewModel.coordinator = self
        let tasksVC = GroupViewController(viewModel: viewModel)
        screenNavigation.pushViewController(tasksVC, animated: true)
    }
    
    func goToAddGroup(completion: (() -> ())?) {
        let viewModel = GroupViewControllerViewModel(state: .add, completion: completion)
        viewModel.coordinator = self
        let tasksVC = GroupViewController(viewModel: viewModel)
        let nc = UINavigationController(rootViewController: tasksVC)
        screenNavigation.present(nc, animated: true)
    }
}
