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
    
    // Groups Screen
    private lazy var groupsModule: (viewModel: GroupsViewControllerViewModel, controller: GroupsViewController) = {
        let viewModel = GroupsViewControllerViewModel()
        viewModel.coordinator = self
        let viewController = GroupsViewController(viewModel: viewModel)
        viewController.tabBarItem.image = UIImage(systemName: "house.fill")
        viewController.tabBarItem.title = "Groups"
        return (viewModel, viewController)
    }()
    
    init(navigationController: UINavigationController, tabBar: UITabBarController) {
        self.navigationController = navigationController
        self.tabBar = tabBar
        
        screenNavigation.pushViewController(groupsModule.controller, animated: false)
        var controllers = tabBar.viewControllers ?? []
        controllers.append(screenNavigation)
        tabBar.viewControllers = controllers
    }
    
    func start() {
        screenNavigation.popToRootViewController(animated: true)
    }
}

extension GroupsScreenCoordinator: GroupsScreenNavigation {
    func goToGroup() {
        let viewModel = GroupViewModel(state: .edite)
        viewModel.coordinator = self
        let tasksVC = GroupViewController(viewModel: viewModel)
        screenNavigation.pushViewController(tasksVC, animated: true)
    }
    
    func goToAddGroup() {
        let viewModel = GroupViewModel(state: .add)
        viewModel.coordinator = self
        let tasksVC = GroupViewController(viewModel: viewModel)
        let nc = UINavigationController(rootViewController: tasksVC)
        screenNavigation.present(nc, animated: true)
    }
}
