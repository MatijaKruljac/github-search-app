//
//  NavigationService.swift
//  GitHubApp
//
//  Created by Matija Kruljac on 25/03/2017.
//  Copyright © 2017 Matija Kruljac. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    
    func addRoot(viewController: UIViewController, with navigationController: UINavigationController) {
        navigationController.viewControllers = [viewController]
        rootViewController = navigationController
        makeKeyAndVisible()
    }
}

class NavigationService {
    
    var navigationController = UINavigationController()
    
    func pushInitialViewController(withResultElements resultElements: [ResultElement], in window: UIWindow? = nil) {
        let searchScreenViewModel = SearchScreenViewModel()
        let elementsData = DataStructures.elements(value: resultElements)
        let viewControllerDependencies = ViewControllerDependencies(
            withViewModel: searchScreenViewModel,
            withNavigationService: self,
            andWithData: elementsData)
        
        let searchScreenViewController = SearchScreenViewController.init(
            nibName: String(describing: SearchScreenViewController.self),
            bundle: nil,
            withViewControllerDependencies: viewControllerDependencies)
        
        guard let window = window else {
            navigationController.pushViewController(searchScreenViewController, animated: true)
            return
        }
        window.addRoot(viewController: searchScreenViewController, with: navigationController)
    }
    
    func pushDetailsScreenViewController(withResultElement resultElement: ResultElement) {
        let detailsScreenViewModel = DetailsScreenViewModel()
        let elementData = DataStructures.element(value: resultElement)
        let viewControllerDependencies = ViewControllerDependencies(
            withViewModel: detailsScreenViewModel,
            withNavigationService: self,
            andWithData: elementData)
        
        let detailsScreenViewController = DetailsScreenViewController.init(
            nibName: String(describing: DetailsScreenViewController.self),
            bundle: nil,
            withViewControllerDependencies: viewControllerDependencies)
        navigationController.pushViewController(detailsScreenViewController, animated: true)
    }
}
