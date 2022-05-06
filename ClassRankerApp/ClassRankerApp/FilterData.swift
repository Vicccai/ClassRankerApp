//
//  FilterData.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 5/6/22.
//

import Foundation
import UIKit

struct FilterData {
    static let colleges: [String] = [
        "Arts & Sciences",
        "Art, Architecture & Planning",
        "Engineering",
        "Agriculture and Life Sciences",
        "Human Ecology"
    ]
    
    static let abbrev: [String : String] = [
        "Arts & Sciences" : "AS",
        "Art, Architecture & Planning" : "AAP",
        "Engineering" : "EN",
        "Agriculture and Life Sciences" : "AG",
        "Human Ecology" : "HE"
    ]
    
    static let levels: [String] = [
        "1000", "2000", "3000", "4000", "5000", "6000", "7000"
    ]
    
    static let sort: [String] = [
        "Rating", "Difficulty", "Workload", "Popular"
    ]
    
    static let sortNumber: [String : Int] = [
        "" : 1,
        "Rating" : 1,
        "Difficulty" : 2,
        "Workload" : 3,
        "Popular" : 4
    ]
    
    static let distributions: [String : [String]] = [
        "Arts & Sciences" : [
            "ALC","BIO","CA","ETM","GLC","HA","HST","KCM","LA","MQR","PBS","PBSS","PHS","SBA","SCD","SDS","SMR","SSC"
        ],
        "Art, Architecture & Planning" : [
            "ALC","CA","FL","HA","KCM","LA","MQR","PBS","SBA"
        ],
        "Engineering" : [
            "CE"
        ],
        "Agriculture and Life Sciences" : [
            "BIO","BIOLS","BIONLS","CA","D","HA","KCM","LA","OPHLS","SBA"
        ],
        "Human Ecology" : [
            "CA","D","HA","KCM","LAD","MQR","PBS","SBA"
        ]
    ]
    
    private static let cellHeight : CGFloat = 34
    
    static let menuHeight: [String : CGFloat] = [
        "Colleges" : cellHeight * 7,
        "Levels" : cellHeight * 8,
        "Sort" : cellHeight * 5.5,
        "Arts & Sciences" : cellHeight * 20,
        "Art, Architecture & Planning" : cellHeight * 11,
        "Engineering" : cellHeight * 8,
        "Agriculture and Life Sciences" : cellHeight * 12,
        "Human Ecology" : cellHeight * 10
    ]
}
