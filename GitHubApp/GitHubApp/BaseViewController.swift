//
//  BaseViewController.swift
//  GitHubApp
//
//  Created by Matija Kruljac on 27/03/2017.
//  Copyright © 2017 Matija Kruljac. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    var viewControllerDependencies: ViewControllerDependencies!
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?,
         withViewControllerDependencies viewControllerDependencies: ViewControllerDependencies) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.viewControllerDependencies = viewControllerDependencies
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
