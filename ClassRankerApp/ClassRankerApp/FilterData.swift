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
        "Agriculture & Life Sciences",
        "Human Ecology",
        "Charles H. Dyson",
    ]
    
    static let abbrev: [String : String] = [
        "Arts & Sciences" : "AS",
        "Art, Architecture & Planning" : "AS",
        "Engineering" : "AS",
        "Agriculture & Life Sciences" : "AG",
        "Human Ecology" : "HE",
        "Charles H. Dyson" : "AG",
    ]
    
    static let levels: [String] = [
        "1000", "2000", "3000", "4000", "5000", "6000", "7000"
    ]
    
    static let sort: [String] = [
        "Overall", "Difficulty", "Workload"
    ]
    
    static let sortNumber: [String : Int] = [
        "" : 1,
        "Overall" : 1,
        "Difficulty" : 2,
        "Workload" : 3,
    ]
    
    static let distributions: [String : [String]] = [
        "Arts & Sciences" : [
            "Arts, Literature, & Culture", "ALC", "Biological Sciences", "BIO", "Ethics & the Mind", "ETM", "Global Citizenship", "GLC", "Historical Analysis", "HST", "Physical Sciences", "PHS","Social Difference", "SCD", "Social Sciences", "SSC", "Statistics & Data Science", "SDS", "Symbolic & Mathematical Reasoning", "SMR" /*"-- Pre 2020 -- Mathematics and Quantitative Reasoning: MQR", "Cultural Analysis: CA", "Historial Analysis: HA", "Knowledge, Cognition, and Moral Reasoning: KCM", "Literature and the Arts: LA", "Social and Behavorial Analysis: SBA", "Physical and Biological Sciences: PBS", "Physical and Biological Sciences: PBSS",*/
        ],
        "Art, Architecture & Planning" : [
            "Math/Quantitative Reasoning", "MQR", "SDS", "SMR", "Physical/Biological Sciences", "PBS", "BIO", "PHS", "Humanities (Architecture)", "CA", "HA", "KCM", "LA", "SBA", "Humanities (Architecture/Planning)", "ALC", "ETM", "GLC", "HST", "SCD", "SSC"
        ],
        "Engineering" : [
            "Cultural Analysis, Literature & the Arts", "CA", "LA", "LAD", "ALC", "SCD", "Historical Analysis", "HA", "HST", "Ethics, Cognition, & Moral Reasoning", "KCM", "ETM", "Social Science & Global Citizenship", "SBA", "SSC", "GLC", "Communications in Engineering", "CE"
        ],
        "Agriculture & Life Sciences" : [
            "Cultural Analysis", "CA", "Human Diversity", "D", "Historical Analysis", "HA", "Knowledge, Cognition, & Moral Reasoning", "KCM", "Literature & the Arts", "LA", "Social & Behavorial Analysis", "SBA"
        ],
        "Human Ecology" : [
            "Physical & Biological Sciences", "PBS","Mathematics & Quantitative Reasoning", "MQR","Human Diversity", "D","Cultural Analysis", "CA","Historical Analysis", "HA","Knowledge, Cognition, & Moral Reasoning", "KCM","Literature, the Arts & Design", "LAD","Social & Behavorial Analysis", "SBA"
        ],
        "Charles H. Dyson" : [
            "Human Diversity", "D", "Cultural Analysis", "CA", "Historical Analysis", "HA", "Knowledge, Cognition & Moral Reasoning", "KCM", "Literature & the Arts", "LA"
        ]
    ]
    
    private static let cellHeight : CGFloat = 34
    
    static let menuHeight: [String : CGFloat] = [
        "Colleges" : cellHeight * 8,
        "Levels" : cellHeight * 8.75,
        "Sort" : cellHeight * 5,
        "Arts & Sciences" : cellHeight * 20.75,
        "Art, Architecture & Planning" : cellHeight * 22.5,
        "Engineering" : cellHeight * 19.5,
        "Agriculture & Life Sciences" : cellHeight * 14,
        "Human Ecology" : cellHeight * 17.25,
        "Charles H. Dyson": cellHeight * 12.5,
    ]
}
