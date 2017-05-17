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
    
    func callFetchRawResultAndParseIt(for query: String, with sort: Sort? = nil) -> Observable<Response> {
        return Observable.create{ [weak self] observer in
            guard
                let disposeBag = self?.disposeBag,
                let dataFetcher = self?.dataFetcher
            else { return Disposables.create() }
            
            dataFetcher
                .fetchRawResultAndParseIt(for: query, with: sort)
                .asObservable()
                .subscribe(onNext: { response in
                    observer.on(.next(response))
                    observer.on(.completed)
                }, onError: { error in
                    observer.on(.error(error))
                }).disposed(by: disposeBag)
            return Disposables.create()
        }
    }
}
