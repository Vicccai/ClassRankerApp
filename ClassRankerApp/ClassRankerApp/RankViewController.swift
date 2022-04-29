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
    
    let courses = [
        Course(number: "CS1110", name: "Intro to Python", rating: 9.7),
        Course(number: "CS2110", name: "Object Oriented Programming", rating: 8.4)
    ]
    
    lazy var classesView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CourseCell.self, forCellReuseIdentifier: CourseCell.id)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Courses"
        
        for subView in [classesView] {
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            classesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            classesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            classesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            classesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }
}

extension RankViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseCell.id, for: indexPath) as! CourseCell
        cell.configure(course: courses[indexPath.row], index: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension RankViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let courseController = CourseViewController()
        courseController.course = courses[indexPath.row]
        navigationController?.pushViewController(courseController, animated: true)
    }
}
