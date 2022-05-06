//
//  Models.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 4/28/22.
//

import Foundation

struct Course: Codable, Hashable {
    // info for the table cell
    var number: String
    var name: String
    var rating: Double
    var distribution: String
    var favorite: Bool
    
    // info the the description
    var descr: String
    var credits: Double
    var reqs: String
    var overallRating: Double
    var workloadRating: Double
    var difficultyRating: Double
    var professors: String
}

struct User: Codable {
    var username: String
    var password: String
}

struct Comment: Codable {
    var username: String
    var comment: String
}

var username = String()
