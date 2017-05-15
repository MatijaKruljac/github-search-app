//
//  ViewControllerDependencies.swift
//  GitHubApp
//
//  Created by Matija Kruljac on 04/04/2017.
//  Copyright © 2017 Matija Kruljac. All rights reserved.
//

import Foundation

protocol ViewControllerDependenciesProtocol {
    
    var data: DataStructures<ResultElement>? { get set }
    var navigationService: NavigationService! { get set }
    var viewModel: BaseViewModelProtocol! { get set }
}

struct ViewControllerDependencies: ViewControllerDependenciesProtocol {
    
    var viewModel: BaseViewModelProtocol!
    var navigationService: NavigationService!
    var data: DataStructures<ResultElement>?
    
    init(withViewModel viewModel: BaseViewModelProtocol,
         withNavigationService navigationService: NavigationService,
         andWithData data: DataStructures<ResultElement>? = nil) {
        self.viewModel = viewModel
        self.navigationService = navigationService
        self.data = data
    }
}

enum DataStructures<T> {
    case element(value: T)
    case elements(value: [T])
}
