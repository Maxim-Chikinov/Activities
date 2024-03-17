//
//  Coordinator.swift
//  Activities
//
//  Created by Chikinov Maxim on 17.03.2024.
//

import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var tabBar: UITabBarController { get set }
    
    func start()
}
