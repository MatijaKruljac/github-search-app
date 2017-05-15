//
//  NullAttributeValue.swift
//  GitHubApp
//
//  Created by Matija Kruljac on 5/3/17.
//  Copyright © 2017 Matija Kruljac. All rights reserved.
//

import Foundation

struct NullAttributeValue {
    
    init(with jsonKey: String) {
        print("Value not found for key \(jsonKey)")
    }
}
