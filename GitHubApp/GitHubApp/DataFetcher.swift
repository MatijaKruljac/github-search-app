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
                    observer.onCompleted()
                    
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
        
        var repositrotyNameValue: ResultAttributeDataType
        if let repositrotyName = item[JSONKeys.name.attribut].string {
            repositrotyNameValue = ResultAttributeDataType.string(repositrotyName)
        } else {
            repositrotyNameValue = ResultAttributeDataType.null(NullAttributeValue.init(with: JSONKeys.name.attribut))
        }
        
        var ownerLoginValue: ResultAttributeDataType
        if let ownerLogin = item[JSONKeys.owner.attribut][JSONKeys.login.attribut].string {
            ownerLoginValue = ResultAttributeDataType.string(ownerLogin)
        } else {
            ownerLoginValue = ResultAttributeDataType.null(NullAttributeValue.init(with: JSONKeys.login.attribut))
        }
        
        var ownerAvatarUrlValue: ResultAttributeDataType
        if let ownerAvatarUrl = item[JSONKeys.owner.attribut][JSONKeys.avatarUrl.attribut].string {
            ownerAvatarUrlValue = ResultAttributeDataType.string(ownerAvatarUrl)
        } else {
            ownerAvatarUrlValue = ResultAttributeDataType.null(NullAttributeValue.init(with: JSONKeys.avatarUrl.attribut))
        }
        
        var languageValue: ResultAttributeDataType
        if let language = item[JSONKeys.language.attribut].string {
            languageValue = ResultAttributeDataType.string(language)
        } else {
            languageValue = ResultAttributeDataType.null(NullAttributeValue.init(with: JSONKeys.language.attribut))
        }
        
        var dateOfCreationValue: ResultAttributeDataType
        if let dateOfCreation = item[JSONKeys.dateOfCreation.attribut].string {
            dateOfCreationValue = ResultAttributeDataType.string(dateOfCreation)
        } else {
            dateOfCreationValue = ResultAttributeDataType.null(NullAttributeValue.init(with: JSONKeys.dateOfCreation.attribut))
        }
        
        var dateOfUpdateValue: ResultAttributeDataType
        if let dateOfUpdate = item[JSONKeys.dateOfUpdate.attribut].string {
            dateOfUpdateValue = ResultAttributeDataType.string(dateOfUpdate)
        } else {
            dateOfUpdateValue = ResultAttributeDataType.null(NullAttributeValue.init(with: JSONKeys.dateOfUpdate.attribut))
        }
        
        var watchersCountValue: ResultAttributeDataType
        if let watchersCount = item[JSONKeys.watchersCount.attribut].int {
            watchersCountValue = ResultAttributeDataType.integer(watchersCount)
        } else {
            watchersCountValue = ResultAttributeDataType.null(NullAttributeValue.init(with: JSONKeys.watchersCount.attribut))
        }
        
        var forksCountValue: ResultAttributeDataType
        if let forksCount = item[JSONKeys.forksCount.attribut].int {
            forksCountValue = ResultAttributeDataType.integer(forksCount)
        } else {
            forksCountValue = ResultAttributeDataType.null(NullAttributeValue.init(with: JSONKeys.forksCount.attribut))
        }
        
        var openIssuesCountValue: ResultAttributeDataType
        if let openIssuesCount = item[JSONKeys.openIssuesCount.attribut].int {
            openIssuesCountValue = ResultAttributeDataType.integer(openIssuesCount)
        } else {
            openIssuesCountValue = ResultAttributeDataType.null(NullAttributeValue.init(with: JSONKeys.openIssuesCount.attribut))
        }
        
        var descriptionValue: ResultAttributeDataType
        if let description = item[JSONKeys.description.attribut].string {
            descriptionValue = ResultAttributeDataType.string(description)
        } else {
            descriptionValue = ResultAttributeDataType.null(NullAttributeValue.init(with: JSONKeys.description.attribut))
        }
        
        let errorMessageValue: ResultAttributeDataType
        if let errorMessage = item[JSONKeys.message.attribut].string {
            errorMessageValue = ResultAttributeDataType.string(errorMessage)
        } else {
            errorMessageValue = ResultAttributeDataType.null(NullAttributeValue.init(with: JSONKeys.message.attribut))
        }
        
        let resultElement = ResultElement.init(repositoryName: repositrotyNameValue, authorName: ownerLoginValue,
                                               authorThumbnailUrl: ownerAvatarUrlValue, language: languageValue,
                                               dateOfCreation: dateOfCreationValue, dateOfUpdate: dateOfUpdateValue,
                                               numberOfWatchers: watchersCountValue, numberOfForks: forksCountValue,
                                               numberOfIssues: openIssuesCountValue, description: descriptionValue,
                                               errorMessage: errorMessageValue)
        return resultElement
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
