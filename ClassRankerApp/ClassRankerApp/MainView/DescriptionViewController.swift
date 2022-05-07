//  DescriptionViewController.swift
//  ClassRankerApp
//
//  Created by Mariana Meriles on 5/4/22.
//
import Foundation
import UIKit
 
class DescriptionViewController: UIViewController {
    
    var course: Course?
    var delegate: RankViewController?
    var comments : [Comment] = []
    
    lazy var descriptionTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: DescriptionTableViewCell.id)
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let discussionStackView: DiscussionView = {
        let stackview = DiscussionView(frame: .zero)
        stackview.backgroundColor = .clear
        stackview.alignment = .center
        stackview.axis = .vertical
        stackview.isBaselineRelativeArrangement = true
        stackview.distribution = .fillProportionally
        stackview.isLayoutMarginsRelativeArrangement = true
        stackview.spacing = 0
        stackview.layer.cornerRadius = 5
        stackview.layer.borderWidth = 1
        stackview.layer.borderColor = UIColor.black.cgColor
        return stackview
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        navigationItem.largeTitleDisplayMode = .never
        for subView in [descriptionTableView, discussionStackView] {
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        discussionStackView.course = course
        discussionStackView.comments = comments
        descriptionTableView.delegate = self
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            descriptionTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            descriptionTableView.bottomAnchor.constraint(equalTo: discussionStackView.topAnchor),
            descriptionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
            discussionStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            discussionStackView.leadingAnchor.constraint(equalTo: descriptionTableView.leadingAnchor, constant: 15),
            discussionStackView.trailingAnchor.constraint(equalTo: descriptionTableView.trailingAnchor, constant: -15)
        ])
    }
    
    func configure(course: Course) {
        self.course = course
    }
    
}
 
extension DescriptionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.id) as? DescriptionTableViewCell else { return UITableViewCell() }
        cell.configure(course: course!)
        cell.doubleDel = delegate
        cell.delegate = self
        return cell
    }
}
 
extension DescriptionViewController: UITableViewDelegate {
}
