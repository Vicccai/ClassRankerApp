//
//  NetworkManager.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 5/5/22.
//

import Foundation
import Alamofire

class NetworkManager {
    static let host = "http://34.130.42.245"
    
    static func getAllCourses(completion: @escaping (CourseWrapper) -> Void) {
        let endpoint = "\(host)/courses/"
//        let header: [String : String] = [
//            "session_token": "value"
//        ]
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch (response.result) {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(CourseWrapper.self, from: data) {
                    completion(userResponse)
                } else {
                    print("Failed to decode getAllPosts")
                }
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getCourseByAttributes(level: Int, distributions: [String], matchAll: Bool, sort: Int, completion: @escaping (CourseWrapper) -> Void) {
        let endpoint = "\(host)/courses/attributes/"
        let params: [String : Any] = [
            "subject": "",
            "level": level,
            "breadth": [],
            "distribution": distributions,
            "all": matchAll,
            "sort": sort
        ]
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData { response in
            switch (response.result) {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(CourseWrapper.self, from: data) {
                    completion(userResponse)
                } else {
                    print("Failed to decode getCourseByAttributes")
                }
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getCommentsByCourse(course: Course, completion: @escaping (CommentWrapper) -> Void) {
        let endpoint = "\(host)/courses/comments/\(course.id)"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch (response.result) {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(CommentWrapper.self, from: data) {
                    completion(userResponse)
                } else {
                    print("Failed to decode getCommentsByCourse")
                }
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func postCommentByUser(course: Course, username: String, description: String, completion: @escaping (Comment) -> Void) {
        let endpoint = "\(host)/comments/"
        let params: [String : Any] = [
            "course_id": course.id,
            "description": description,
            "username": username
        ]
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData { response in
            switch (response.result) {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(Comment.self, from: data) {
                    completion(userResponse)
                } else {
                    print("Failed to decode postCommentByUser")
                }
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func deleteComment(comment: Comment, completion: @escaping (Comment) -> Void) {
        let endpoint = "\(host)/comments/\(comment.id)"
        AF.request(endpoint, method: .delete).validate().responseData { response in
            switch (response.result) {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(Comment.self, from: data) {
                    completion(userResponse)
                } else {
                    print("Failed to decode deleteComment")
                }
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func registerAccount(username: String, password: String, completion: @escaping (User) -> Void) {
        let endpoint = "\(host)/register/"
        let params: [String : String] = [
            "username": username,
            "password": password
        ]
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData { response in
            switch (response.result) {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(User.self, from: data) {
                    completion(userResponse)
                } else {
                    print("Failed to decode registerAccount")
                }
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func login(username: String, password: String, completion: @escaping (User) -> Void) {
        let endpoint = "\(host)/login/"
        let params: [String : String] = [
            "username": username,
            "password": password
        ]
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData { response in
            switch (response.result) {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(User.self, from: data) {
                    completion(userResponse)
                } else {
                    print("Failed to decode login")
                }
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getFavoritesByUser(username: String, completion: @escaping (Favorites) -> Void) {
        let endpoint = "\(host)/favorites/username/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch (response.result) {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(Favorites.self, from: data) {
                    completion(userResponse)
                } else {
                    print("Failed to decode getFavoritesByUser")
                }
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func addToFavoritesForUser(username: String, course: Course, completion: @escaping (Course) -> Void) {
        let endpoint = "\(host)/add/favorites/username/"
        let params: [String : Int] = [
            "course_id": course.id
        ]
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData { response in
            switch (response.result) {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(Course.self, from: data) {
                    completion(userResponse)
                } else {
                    print("Failed to decode addToFavoritesForUser")
                }
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func removeFromFavoritesForUser(username: String, course: Course, completion: @escaping (Course) -> Void) {
        let endpoint = "\(host)/delete/favorites/username/"
        let params: [String : Int] = [
            "course_id": course.id
        ]
        AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseData { response in
            switch (response.result) {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let userResponse = try? jsonDecoder.decode(Course.self, from: data) {
                    completion(userResponse)
                } else {
                    print("Failed to decode removeFromFavoritesForUser")
                }
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
