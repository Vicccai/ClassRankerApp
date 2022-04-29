//
//  ClassCell.swift
//  ClassRankerApp
//
//  Created by Victor Cai on 4/28/22.
//

import UIKit

class CourseCell: UITableViewCell {
    
    static let id = "CourseCellId"
    
    let cellPadding: CGFloat = 10
    
    var rankingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        for subView in [rankingLabel, numberLabel, nameLabel, ratingLabel] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subView)
        }
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            rankingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: cellPadding),
            rankingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            numberLabel.leadingAnchor.constraint(equalTo: rankingLabel.trailingAnchor, constant: cellPadding),
            numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: cellPadding),
            
            nameLabel.leadingAnchor.constraint(equalTo: rankingLabel.trailingAnchor, constant: cellPadding),
            nameLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: cellPadding),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -cellPadding),
            
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -cellPadding),
            ratingLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: cellPadding)
        ])
    }
    
    func configure(course: Course, index: Int) {
        numberLabel.text = course.number
        nameLabel.text = course.name
        ratingLabel.text = String(course.rating!)
        rankingLabel.text = String(index) + "."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
