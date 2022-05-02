//
//  Models.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 4/28/22.
//

import Foundation

struct Course: Codable, Hashable {
    var number: String
    var name: String
    var rating: Double
    var distribution: [String]
    var favNumber: Int
}
