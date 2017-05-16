//
//  NetworkHandler.swift
//  GitHubApp
//
//  Created by Matija Kruljac on 25/03/2017.
//  Copyright © 2017 Matija Kruljac. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON

class NetworkHandler {
    
    func fetchDataFor(query: String, with sort: Sort? = nil) -> Observable<JSON> {
        return Observable.create { observer in
            
            let responseQueue = DispatchQueue(
                label: "com.response_queue",
                qos: .userInitiated,
                attributes: .concurrent)
            
            var parameters: Parameters = [GitHubParameters.q.name: query]
            if let sortCondition = sort {
                parameters[GitHubParameters.sort.name] = [sortCondition.condition]
            }
            Alamofire
                .request(GitHubUrls.apiRepositories, parameters: parameters)
                .responseJSON(queue: responseQueue, completionHandler: { response in
                    DispatchQueue.main.async {
                        if let value = response.value {
                            let json = JSON(value)
                            observer.onNext(json)
                        }
                        if let error = response.error {
                            observer.onError(ResponseError.networkFailure(content: error))
                        }
                        observer.onCompleted()
                    }
                })
            return Disposables.create()
        }
    }
}

struct GitHubUrls {
    static let base = "https://github.com"
    static let apiRepositories = "https://api.github.com/search/repositories"
}

enum GitHubParameters {
    case q
    case sort
    
    var name: String {
        switch self {
        case .q:
            return "q"
        case .sort:
            return "sort"
        }
    }
}

enum Sort {
    case stars
    case forks
    case updated
    
    var condition: String {
        switch self {
        case .stars:
            return "stars"
        case .forks:
            return "forks"
        case .updated:
            return "updated"
        }
    }
}

enum ResponseError: Error {
    case networkFailure(content: Error)
}
