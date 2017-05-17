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
    
    func fetchDataFor(query: String, with sort: Sort? = nil) -> Observable<Response> {
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
                    DispatchQueue.main.async { [weak self] _ in
                        guard let sSelf = self else { return }
                        if let value = response.value {
                            let json = JSON(value)
                            let responseType = sSelf.getResponseType(for: json)
                            observer.on(.next(responseType))
                        }
                        
                        if let error = response.error {
                            observer.on(.error(ResponseError.networkFailure(content: error)))
                        }
                        observer.on(.completed)
                    }
                })
            return Disposables.create()
        }
    }
    
    private func getResponseType(for json: JSON) -> Response {
        if Response.itemsExist(with: json) {
            return Response.ok(content: json)
        }
        return Response.apiRateLimit(content: "API rate limit exceeded.")
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

enum Response {
    case ok(content: JSON)
    case success(content: [ResultElement])
    case apiRateLimit(content: String)
    
    static func itemsExist(with json: JSON) -> Bool {
        return json[JSONKeys.items.attribut] != JSON.null
    }
}

enum ResponseError: Error {
    case networkFailure(content: Error)
}
