//
//  ViewController.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 4/28/22.
//

import UIKit
import Alamofire
import iOSDropDown

class RankViewController: UIViewController {
    
    let padding: CGFloat = 15
    
    let courses = [
        Course(number: "CS 1110", name: "Intro to Python", rating: 9.7, distribution: ["MQR-AS"]),
        Course(number: "CS 2110", name: "Object Oriented Programming", rating: 8.4, distribution: ["MQR-AS"])
    ]
    
    var filteredCourses: [Course] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    lazy var coursesView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CourseCell.self, forCellReuseIdentifier: CourseCell.id)
        return tableView
    }()
    
    var majorDropDown: DropDownContainer = {
        let view = DropDownContainer(placeholder: "Select Major", optionArray: ["", "CS", "MATH"])
        return view
    }()
    
    var distrDropDown: DropDownContainer = {
        let view = DropDownContainer(placeholder: "Select Distribution", optionArray: ["", "MQR-AS", "LA-AS"])
        return view
    }()
    
    var applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("  Apply  ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1
        button.backgroundColor = UIColor.systemBlue
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(pressApply), for: .touchDown)
        button.addTarget(self, action: #selector(releaseApply), for: .touchUpInside)
        return button
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Courses"
        
        for subView in [coursesView, majorDropDown, distrDropDown, applyButton] {
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // search bar stuff
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Classes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            applyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            majorDropDown.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            majorDropDown.centerYAnchor.constraint(equalTo: applyButton.centerYAnchor),
            majorDropDown.heightAnchor.constraint(equalToConstant: 30),
            
            distrDropDown.leadingAnchor.constraint(equalTo: majorDropDown.trailingAnchor, constant: padding),
            distrDropDown.centerYAnchor.constraint(equalTo: applyButton.centerYAnchor),
            distrDropDown.heightAnchor.constraint(equalToConstant: 30),
            
            coursesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            coursesView.topAnchor.constraint(equalTo: applyButton.bottomAnchor, constant: padding),
            coursesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            coursesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredCourses = courses.filter({ course in
            course.name.lowercased().contains(searchText.lowercased()) ||
            course.number.lowercased().contains(searchText.lowercased())
        })
        coursesView.reloadData()
    }
    
    @objc func pressApply(sender: UIButton) {
        sender.backgroundColor = .white
        sender.setTitleColor(.darkGray, for: .normal)
    }
    
    @objc func releaseApply(sender: UIButton) {
        sender.backgroundColor = .systemBlue
        sender.setTitleColor(.white, for: .normal)
    }
}

extension RankViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCourses.count
        } else {
            return courses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseCell.id, for: indexPath) as! CourseCell
        let course: Course
        if isFiltering {
            course = filteredCourses[indexPath.row]
        } else {
            course = courses[indexPath.row]
        }
        cell.configure(course: course, index: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension RankViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let courseController = CourseViewController()
        if isFiltering {
            courseController.course = filteredCourses[indexPath.row]
        } else {
            courseController.course = courses[indexPath.row]
        }
        navigationController?.pushViewController(courseController, animated: true)
    }
}

extension RankViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchText: searchBar.text!)
    }
}
