//
//  CoursesTableViewCell.swift
//  ClassRankerApp
//
//  Created by Mariana Meriles on 5/1/22.
//

import UIKit

class CoursesTableViewCell: UITableViewCell {
    
    static let id = "CourseCellId"
    
    let cellPadding: CGFloat = 30
    
//    var rankingLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = .systemFont(ofSize: 30)
//        return label
//    }()
    
    var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 50
        return view
    }()
    
    var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 40)
        label.textAlignment = .right
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 25)
        label.textAlignment = .right
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    var favButton: UIButton = {
        let button = UIButton()
        // will be changed to a star image with button.setImage()
        button.setTitle("X", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    var favNumber: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1.0)
    
        for subView in [backView, numberLabel, nameLabel, ratingLabel, favButton, favNumber] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subView)
        }
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellPadding),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -cellPadding),
            
            ratingLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: cellPadding),
            ratingLabel.bottomAnchor.constraint(equalTo: numberLabel.bottomAnchor),
            
            favButton.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: cellPadding),
            favButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: cellPadding),
            favButton.widthAnchor.constraint(equalToConstant: 30),
            favButton.heightAnchor.constraint(equalToConstant: 30),
            
            favNumber.topAnchor.constraint(equalTo: favButton.bottomAnchor),
            favNumber.centerXAnchor.constraint(equalTo: favButton.centerXAnchor),
            favNumber.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -cellPadding),
            
            numberLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: cellPadding),
            numberLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -cellPadding),
            numberLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: cellPadding),
            
            nameLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: cellPadding),
            nameLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -cellPadding),
            nameLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -cellPadding)
        ])
    }
    
    func configure(course: Course, index: Int) {
        numberLabel.text = course.number
        nameLabel.text = course.name
        ratingLabel.text = String(course.rating)
        favNumber.text = String(course.favNumber)
//        rankingLabel.text = String(index) + "."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

