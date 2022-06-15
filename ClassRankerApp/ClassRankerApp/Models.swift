//
//  Models.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 4/28/22.
//

import Foundation
import UIKit

struct Globals {
    static var courses: [Course] = []
    static var favCourses: [Course] = []
    static var user: User = User(username: "", session_token: "")
    static var guest: DarwinBoolean = false
    static var keyboardHeight: CGFloat = 0
}

struct CourseWrapper: Codable {
    var courses: [Course]
}

struct Course: Codable, Equatable {
    static func == (lhs: Course, rhs: Course) -> Bool {
        lhs.id == rhs.id
    }
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

struct CommentWrapper: Codable {
    var comments: [Comment]
}

struct Comment: Codable, Equatable {
    var id: Int
    var course_id: Int
    var username: String
    var description: String
}

struct User: Codable {
    var username: String
    var session_token: String
}

struct Favorites: Codable {
    var favorites: [Course]
}
