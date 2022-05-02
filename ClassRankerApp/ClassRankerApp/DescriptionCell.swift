//
//  DescriptionCell.swift
//  ClassRankerApp
//
//  Created by Mariana Meriles on 5/1/22.
//

import Foundation
import UIKit

class DescriptionCell: UITableViewCell {
    
    static let id = "DescriptionCellId"
    let cellPadding = CGFloat(20)
    
    var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 50
        return view
    }()
    
    var courseName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 40)
        return label
    }()
    
    var descriptionView: UIView = {
        let background = UIView()
        background.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 0.2)
        background.layer.cornerRadius = 40
        return background
    }()
    
    var descriptionTitle: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    var descriptionText: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var ratingView: UIView = {
        let background = UIView()
        background.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 0.2)
        background.layer.cornerRadius = 40
        return background
    }()
    
    var overallRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "Overall Rating:"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    var overallRating: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    var difficultyRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "Difficulty Rating:"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    var difficultyRating: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    var workloadRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "Workload Rating:"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    var workloadRating: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    var fulfillsView: UIView = {
        let background = UIView()
        background.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 0.2)
        background.layer.cornerRadius = 40
        return background
    }()
    
    var fulfillsLabel: UILabel = {
        let label = UILabel()
        label.text = "Fulfills:"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    var fulfillsText: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1.0)
        for subView in [backView, courseName, descriptionView, descriptionTitle, descriptionText, ratingView, overallRatingLabel, overallRating, difficultyRatingLabel, difficultyRating, workloadRatingLabel, workloadRating, fulfillsView, fulfillsLabel, fulfillsText] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subView)
        }
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellPadding),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -cellPadding),
            
            courseName.topAnchor.constraint(equalTo: backView.topAnchor, constant: cellPadding),
            courseName.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: cellPadding),
            
            descriptionView.topAnchor.constraint(equalTo: courseName.bottomAnchor, constant: cellPadding),
            descriptionView.bottomAnchor.constraint(equalTo: ratingView.topAnchor, constant: -cellPadding),
            descriptionView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: cellPadding),
            descriptionView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -cellPadding),
            
            descriptionTitle.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: cellPadding),
            descriptionTitle.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: cellPadding),
            
            descriptionText.topAnchor.constraint(equalTo: descriptionTitle.topAnchor, constant: cellPadding),
            descriptionText.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: cellPadding),
            descriptionText.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -cellPadding),
            
            ratingView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: cellPadding),
            ratingView.bottomAnchor.constraint(equalTo: fulfillsView.topAnchor, constant: -cellPadding),
            ratingView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: cellPadding),
            ratingView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -cellPadding),
            
            overallRatingLabel.topAnchor.constraint(equalTo: ratingView.topAnchor, constant: cellPadding),
            overallRatingLabel.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: cellPadding),
            
            overallRating.topAnchor.constraint(equalTo: ratingView.topAnchor, constant: cellPadding),
            overallRating.leadingAnchor.constraint(equalTo: overallRatingLabel.trailingAnchor, constant: cellPadding),
            
            difficultyRatingLabel.topAnchor.constraint(equalTo: overallRatingLabel.bottomAnchor, constant: cellPadding),
            difficultyRatingLabel.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: cellPadding),
            
            difficultyRating.topAnchor.constraint(equalTo: overallRatingLabel.bottomAnchor, constant: cellPadding),
            difficultyRating.leadingAnchor.constraint(equalTo: difficultyRatingLabel.trailingAnchor, constant: cellPadding),
            
            workloadRatingLabel.topAnchor.constraint(equalTo: difficultyRatingLabel.topAnchor, constant: cellPadding),
            workloadRatingLabel.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: cellPadding),

            workloadRating.topAnchor.constraint(equalTo: difficultyRatingLabel.topAnchor, constant: cellPadding),
            workloadRating.leadingAnchor.constraint(equalTo: workloadRatingLabel.trailingAnchor, constant: cellPadding),
            
            fulfillsView.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: cellPadding),
            fulfillsView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -cellPadding),
            fulfillsView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: cellPadding),
            fulfillsView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -cellPadding),
            
            fulfillsLabel.topAnchor.constraint(equalTo: fulfillsView.topAnchor, constant: cellPadding),
            fulfillsLabel.leadingAnchor.constraint(equalTo: fulfillsView.leadingAnchor, constant: cellPadding),

            fulfillsText.topAnchor.constraint(equalTo: fulfillsLabel.bottomAnchor, constant: cellPadding),
            fulfillsText.bottomAnchor.constraint(equalTo: fulfillsView.bottomAnchor, constant: -cellPadding),
            fulfillsText.leadingAnchor.constraint(equalTo: fulfillsView.leadingAnchor, constant: cellPadding),
            fulfillsText.trailingAnchor.constraint(equalTo: fulfillsView.trailingAnchor, constant: -cellPadding)
        ])
    }
    
    func configure(courseName: String, descriptionText: String, overallRating: Int, difficultyRating: Int, workloadRating: Int, fulfillsText: String) {
        self.courseName.text = courseName
        self.descriptionText.text = descriptionText
        self.overallRating.text = String(overallRating)
        self.difficultyRating.text = String(difficultyRating)
        self.workloadRating.text = String(workloadRating)
        self.fulfillsText.text = fulfillsText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
