//
//  Models.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 4/28/22.
//

import Foundation

struct CourseWrapper: Codable {
    var courses: [Course]
}

struct Course: Codable {
    // info for the table cell
    var id: Int
    var number: Int
    var title: String
    var subject: String
    var favorite: Bool?
    
    // info the the description
    var description: String
    var creditsMin: Double
    //var reqs: String
    var rating: Double
    var workload: Double
    var difficulty: Double
    var professors: [Professor]
    var comments: [Comment]
    var distributions: [Distribution]
}

struct Professor: Codable {
    var first_name: String
    var last_name: String
}

struct Distribution: Codable {
    var name: String
}

struct Comment: Codable {
}
