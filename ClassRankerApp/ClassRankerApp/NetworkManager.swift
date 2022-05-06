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
                    print("Failed to decode createPost")
                }
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
