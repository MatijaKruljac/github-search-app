//
//  SearchScreenViewModel.swift
//  GitHubApp
//
//  Created by Matija Kruljac on 25/03/2017.
//  Copyright © 2017 Matija Kruljac. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class SearchScreenViewModel: BaseViewModel {
    
    override init() {
        super.init()
        self.dataFetcher = DataFetcher()
    }
    
    func callFetchRawResultAndParseIt(for query: String, with sort: Sort? = nil) -> Observable<[ResultElement]> {
        return Observable.create{ [weak self] observer in
            guard
                let disposeBag = self?.disposeBag,
                let dataFetcher = self?.dataFetcher
            else { return Disposables.create() }
            
            dataFetcher
                .fetchRawResultAndParseIt(for: query, with: sort)
                .asObservable()
                .subscribe(onNext: { elements in
                    observer.on(.next(elements))
                    observer.onCompleted()
                    
                }).disposed(by: disposeBag)
            return Disposables.create()
        }
    }
}
