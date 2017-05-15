//
//  ViewModel.swift
//  GitHubApp
//
//  Created by Matija Kruljac on 26/03/2017.
//  Copyright © 2017 Matija Kruljac. All rights reserved.
//

import Foundation
import RxSwift

protocol BaseViewModelProtocol {
    
    var disposeBag: DisposeBag! { get set }
    var dataFetcher: DataFetcher? { get set }
}

class BaseViewModel: BaseViewModelProtocol {
    
    var disposeBag: DisposeBag!
    var dataFetcher: DataFetcher?
    
    init() {
        self.disposeBag = DisposeBag()
    }
}
