//
//  MainScreenCoordinator.swift
//  Activities
//
//  Created by Chikinov Maxim on 17.03.2024.
//

import Foundation
import UIKit

class MainScreenCoordinator: Coordinator {
    
    // Common
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBar: UITabBarController
    
    // Context
    let mainScreenNavigation = UINavigationController()
    
    // Main Screen
    private lazy var mainModule: (viewModel: MainViewControllerViewModel, controller: MainViewController) = {
        let viewModel = MainViewControllerViewModel()
        viewModel.coordinator = self
        let mainController = MainViewController(viewModel: viewModel)
        mainController.tabBarItem.image = UIImage(systemName: "house.fill")
        mainController.tabBarItem.title = "Main"
        return (viewModel, mainController)
    }()
    
    init(navigationController: UINavigationController, tabBar: UITabBarController) {
        self.navigationController = navigationController
        self.tabBar = tabBar
        
        mainScreenNavigation.pushViewController(mainModule.controller, animated: false)
        var controllers = tabBar.viewControllers ?? []
        controllers.append(mainScreenNavigation)
        tabBar.viewControllers = controllers
    }
    
    func start() {
        mainScreenNavigation.popToRootViewController(animated: true)
    }
}

extension MainScreenCoordinator: MainScreenNavigation {
    func goToTasks() {
        let tasksVC = UIViewController()
        tasksVC.view.backgroundColor = .white
        mainScreenNavigation.pushViewController(tasksVC, animated: true)
    }
    
    func goToChangeTask() {
        let changeVC = UIViewController()
        changeVC.view.backgroundColor = .white
        mainScreenNavigation.present(changeVC, animated: true)
    }
}
