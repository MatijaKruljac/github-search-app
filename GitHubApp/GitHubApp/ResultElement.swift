//
//  ResultElement.swift
//  GitHubApp
//
//  Created by Matija Kruljac on 26/03/2017.
//  Copyright © 2017 Matija Kruljac. All rights reserved.
//

import Foundation

struct ResultElement {
    
    var repositoryName: ResultAttributeDataType
    var authorName: ResultAttributeDataType
    var authorThumbnailUrl: ResultAttributeDataType
    var language: ResultAttributeDataType
    var dateOfCreation: ResultAttributeDataType
    var dateOfUpdate: ResultAttributeDataType
    var numberOfWatchers: ResultAttributeDataType
    var numberOfForks: ResultAttributeDataType
    var numberOfIssues: ResultAttributeDataType
    var description: ResultAttributeDataType
    var errorMessage: ResultAttributeDataType
    
    init(repositoryName: ResultAttributeDataType, authorName: ResultAttributeDataType, authorThumbnailUrl: ResultAttributeDataType, language: ResultAttributeDataType,
         dateOfCreation: ResultAttributeDataType, dateOfUpdate: ResultAttributeDataType, numberOfWatchers: ResultAttributeDataType, numberOfForks: ResultAttributeDataType,
         numberOfIssues: ResultAttributeDataType, description: ResultAttributeDataType, errorMessage: ResultAttributeDataType) {
        self.repositoryName = repositoryName
        self.authorName = authorName
        self.authorThumbnailUrl = authorThumbnailUrl
        self.language = language
        self.dateOfCreation = dateOfCreation
        self.dateOfUpdate = dateOfUpdate
        self.numberOfWatchers = numberOfWatchers
        self.numberOfForks = numberOfForks
        self.numberOfIssues = numberOfIssues
        self.description = description
        self.errorMessage = errorMessage
    }
}

enum ResultAttributeDataType {
    case integer(Int)
    case string(String)
    case null(NullAttributeValue)
    
    var integerValue: Int? {
        switch self {
        case .integer(let value):
            return value
        default:
            return nil
        }
    }
    
    var stringValue: String {
        switch self {
        case .string(let value):
            return value
        default:
            return ""
        }
    }
}
