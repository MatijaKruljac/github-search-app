//
//  DataFetcher.swift
//  GitHubApp
//
//  Created by Matija Kruljac on 5/11/17.
//  Copyright © 2017 Matija Kruljac. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import RxCocoa

class DataFetcher {
    
    let disposeBag = DisposeBag()
    let networkHandler = NetworkHandler()
    
    func fetchRawResultAndParseIt(for query: String, with sort: Sort? = nil) -> Observable<[ResultElement]> {
        return Observable.create{ [weak self] observer in
            guard let disposeBag = self?.disposeBag else {
                return Disposables.create()
            }
            self?.networkHandler
                .fetchDataFor(query: query, with: sort)
                .asObservable()
                .subscribe(onNext: { value in
                    guard let parsedData = self?.parse(json: value) else { return }
                    observer.on(.next(parsedData))
                    observer.on(.completed)
                }, onError: { error in
                    observer.on(.error(error))
                }).disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    private func parse(json: JSON) -> [ResultElement] {
        
        var resultElements = [ResultElement]()
        
        if let items: Array<JSON> = json[JSONKeys.items.attribut].array {
            for item in items {
                let resultElement = addExistingValues(for: item)
                resultElements.append(resultElement)
            }
        } else {
            let resultElement = addExistingValues(for: json)
            resultElements.append(resultElement)
        }
        return resultElements
    }
    
    private func addExistingValues(for item: JSON) -> ResultElement {
        let repositrotyNameValue = ResultAttributeDataType.setupValue(in: item[JSONKeys.name.attribut], with: JSONKeys.name.attribut)
        let ownerLoginValue = ResultAttributeDataType.setupValue(in: item[JSONKeys.owner.attribut][JSONKeys.login.attribut], with: JSONKeys.login.attribut)
        let ownerAvatarUrlValue = ResultAttributeDataType.setupValue(in: item[JSONKeys.owner.attribut][JSONKeys.avatarUrl.attribut], with: JSONKeys.avatarUrl.attribut)
        let languageValue = ResultAttributeDataType.setupValue(in: item[JSONKeys.language.attribut], with: JSONKeys.language.attribut)
        let dateOfCreationValue = ResultAttributeDataType.setupValue(in: item[JSONKeys.dateOfCreation.attribut], with: JSONKeys.dateOfCreation.attribut)
        let dateOfUpdateValue = ResultAttributeDataType.setupValue(in: item[JSONKeys.dateOfUpdate.attribut], with: JSONKeys.dateOfUpdate.attribut)
        let watchersCountValue = ResultAttributeDataType.setupValue(in: item[JSONKeys.watchersCount.attribut], with: JSONKeys.watchersCount.attribut)
        let forksCountValue = ResultAttributeDataType.setupValue(in: item[JSONKeys.forksCount.attribut], with: JSONKeys.forksCount.attribut)
        let openIssuesCountValue = ResultAttributeDataType.setupValue(in: item[JSONKeys.openIssuesCount.attribut], with: JSONKeys.openIssuesCount.attribut)
        let descriptionValue = ResultAttributeDataType.setupValue(in: item[JSONKeys.description.attribut], with: JSONKeys.description.attribut)
        let errorMessageValue = ResultAttributeDataType.setupValue(in: item[JSONKeys.message.attribut], with: JSONKeys.message.attribut)
        
        let resultElement = ResultElement.init(repositoryName: repositrotyNameValue, authorName: ownerLoginValue,
                                               authorThumbnailUrl: ownerAvatarUrlValue, language: languageValue,
                                               dateOfCreation: dateOfCreationValue, dateOfUpdate: dateOfUpdateValue,
                                               numberOfWatchers: watchersCountValue, numberOfForks: forksCountValue,
                                               numberOfIssues: openIssuesCountValue, description: descriptionValue,
                                               errorMessage: errorMessageValue)
        return resultElement
    }
}

extension ResultAttributeDataType {
    
    static func setupValue(in item: JSON, with key: String) -> ResultAttributeDataType {
        if let stringValue = item.string {
            return .string(stringValue)
        }
        if let integerValue = item.int {
            return .integer(integerValue)
        }
        return .null(NullAttributeValue.init(with: key))
    }
}

enum JSONKeys {
    case items
    case name
    case owner
    case login
    case avatarUrl
    case language
    case dateOfCreation
    case dateOfUpdate
    case watchersCount
    case forksCount
    case openIssuesCount
    case description
    case message
    
    var attribut: String {
        switch self {
        case .items:
            return "items"
        case .name:
            return "name"
        case .owner:
            return "owner"
        case .login:
            return "login"
        case .avatarUrl:
            return "avatar_url"
        case .language:
            return "language"
        case .dateOfCreation:
            return "created_at"
        case .dateOfUpdate:
            return "updated_at"
        case .watchersCount:
            return "watchers_count"
        case .forksCount:
            return "forks_count"
        case .openIssuesCount:
            return "open_issues_count"
        case .description:
            return "description"
        case .message:
            return "message"
        }
    }
}
