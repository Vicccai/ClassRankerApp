//
//  CoursesTableViewCell.swift
//  ClassRankerApp
//
//  Created by Mariana Meriles on 5/1/22.
//

import UIKit

class CoursesTableViewCell: UITableViewCell {
    
    static let id = "CourseCellId"
    
    let cellPadding: CGFloat = 40
    
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
        view.layer.cornerRadius = 40
        return view
    }()
    
    var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Proxima Nova Bold", size: 22.5)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "ProximaNova-Regular", size: 20)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Proxima Nova Bold", size: 30)
        label.textAlignment = .right
        return label
    }()
    
    var favButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Star 1"), for: .normal)
        return button
    }()
    
//    var favNumber: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = .systemFont(ofSize: 15)
//        return label
//    }()
    
    var favorite = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    
        for subView in [backView, numberLabel, nameLabel, ratingLabel, favButton] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subView)
        }
        
        favButton.addTarget(self, action: #selector(isFavorite), for: .touchUpInside)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7.5),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7.5),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            
            favButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 30),
            favButton.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            favButton.widthAnchor.constraint(equalToConstant: 20),
            favButton.heightAnchor.constraint(equalToConstant: 20),
            
            numberLabel.bottomAnchor.constraint(equalTo: ratingLabel.bottomAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: favButton.trailingAnchor, constant: 10),
            numberLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -20),
            
            nameLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 5),
            nameLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -25),
            nameLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 30),
            nameLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -30),
            
            ratingLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 15),
            ratingLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -35)
            
//            favNumber.topAnchor.constraint(equalTo: favButton.bottomAnchor, constant: 5),
//            favNumber.centerXAnchor.constraint(equalTo: favButton.centerXAnchor),
        ])
    }
    
    @objc func isFavorite() {
        if favorite == false {
            favButton.setImage(UIImage(named: "Star 2"), for: .normal)
            favorite = true
        }
        else if favorite == true {
            favButton.setImage(UIImage(named: "Star 1"), for: .normal)
            favorite = false
        }
    }
    
    func configure(course: Course, index: Int) {
        numberLabel.text = course.number
        nameLabel.text = course.name
        ratingLabel.text = String(course.rating)
//        favNumber.text = String(course.favNumber)
//        rankingLabel.text = String(index) + "."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

