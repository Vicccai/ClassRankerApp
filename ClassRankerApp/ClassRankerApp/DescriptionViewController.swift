//
//  DescriptionViewController.swift
//  ClassRankerApp
//
//  Created by Mariana Meriles on 5/4/22.
//

import Foundation
import UIKit

class DescriptionViewController: UIViewController {
    
    let cellPadding = CGFloat(30)
    lazy var delegate = UIViewController()
    
    // basic info
    var nameBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 50
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
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(favorite), for: .touchUpInside)
        return button
    }()
    
    var favCourse = false
    
    // added info
    var restBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    var descrLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = .white
        label.font = UIFont(name: "Proxima Nova Bold", size: 17.5)
        return label
    }()
    
    var descrBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    var descrText: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var creditsLabel: UILabel = {
        let label = UILabel()
        label.text = "Credits:"
        label.textColor = .white
        label.font = UIFont(name: "Proxima Nova Bold", size: 17.5)
        return label
    }()
    
    var credits: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.00)
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        return label
    }()
    
    var reqLabel: UILabel = {
        let label = UILabel()
        label.text = "Prerequisites / Corequisites:"
        label.textColor = .white
        label.font = UIFont(name: "Proxima Nova Bold", size: 17.5)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var reqs: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.00)
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var distrLabel: UILabel = {
        let label = UILabel()
        label.text = "Distributions:"
        label.textColor = .white
        label.font = UIFont(name: "Proxima Nova Bold", size: 17.5)
        return label
    }()
    
    var distrs: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.00)
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        return label
    }()
    
    var semsLabel: UILabel = {
        let label = UILabel()
        label.text = "Semesters Offered:"
        label.textColor = .white
        label.font = UIFont(name: "Proxima Nova Bold", size: 17.5)
        return label
    }()
    
    var sems: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.00)
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var overallLabel: UILabel = {
        let label = UILabel()
        label.text = "Overall Rating:"
        label.textColor = .white
        label.font = UIFont(name: "Proxima Nova Bold", size: 17.5)
        return label
    }()
    
    var overallRating: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Proxima Nova Bold", size: 17.5)
        return label
    }()
    
    var workloadLabel: UILabel = {
        let label = UILabel()
        label.text = "Workload Rating:"
        label.textColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.00)
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        return label
    }()
    
    var workloadRating: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.00)
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        return label
    }()
    
    var difficultyLabel: UILabel = {
        let label = UILabel()
        label.text = "Difficulty Rating:"
        label.textColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.00)
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        return label
    }()
    
    var difficultyRating: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.00)
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        return label
    }()
    
    var profLabel: UILabel = {
        let label = UILabel()
        label.text = "Professors:"
        label.textColor = .white
        label.font = UIFont(name: "Proxima Nova Bold", size: 17.5)
        return label
    }()
    
    var profs: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.00)
        label.font = UIFont(name: "ProximaNova-Regular", size: 17.5)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    // discussion button
    var disButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.backgroundColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(pushToDiscussion), for: .touchUpInside)
        return button
    }()
    
    var disLabel: UILabel = {
        let label = UILabel()
        label.text = "Discussions"
        label.textColor = .black
        label.font = UIFont(name: "Proxima Nova Bold", size: 30)
        return label
    }()
    
    var commentsBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1.00, green: 0.44, blue: 0.57, alpha: 1.00)
        view.clipsToBounds = true
        view.layer.cornerRadius = 17.5
        return view
    }()
    
    var commentsNumber: UILabel = {
        let label = UILabel()
        label.text = "12"
        label.textColor = .black
        label.font = UIFont(name: "Proxima Nova Bold", size: 30)
        return label
    }()
    
    var expandLeft: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Vector")
        return image
    }()
    
    var expandRight: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Vector (1)")
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        navigationItem.largeTitleDisplayMode = .never
        for subView in [nameBackView, numberLabel, nameLabel, ratingLabel, favButton, restBackView, descrLabel, descrBackView, descrText, creditsLabel, credits, reqLabel, reqs, distrLabel, distrs, semsLabel, sems, overallLabel, overallRating, workloadLabel, workloadRating, difficultyLabel, difficultyRating, profLabel, profs, disButton, disLabel, commentsBackView, commentsNumber, expandLeft, expandRight] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            nameBackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameBackView.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 100),
            nameBackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            nameBackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            favButton.leadingAnchor.constraint(equalTo: nameBackView.leadingAnchor, constant: 30),
            favButton.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            favButton.widthAnchor.constraint(equalToConstant: 20),
            favButton.heightAnchor.constraint(equalToConstant: 20),
            
            numberLabel.bottomAnchor.constraint(equalTo: ratingLabel.bottomAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: favButton.trailingAnchor, constant: 10),
            numberLabel.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -30),
            
            nameLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: nameBackView.leadingAnchor, constant: 30),
            nameLabel.trailingAnchor.constraint(equalTo: nameBackView.trailingAnchor, constant: -30),
            
            ratingLabel.topAnchor.constraint(equalTo: nameBackView.topAnchor, constant: 15),
            ratingLabel.trailingAnchor.constraint(equalTo: nameBackView.trailingAnchor, constant: -35),
            
            restBackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            restBackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            restBackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-15),
            restBackView.bottomAnchor.constraint(equalTo: distrs.bottomAnchor, constant: 15),
            
            descrLabel.topAnchor.constraint(equalTo: restBackView.topAnchor, constant: 15),
            descrLabel.leadingAnchor.constraint(equalTo: restBackView.leadingAnchor, constant: 15),
            
            descrBackView.topAnchor.constraint(equalTo: descrLabel.bottomAnchor, constant: 5),
            descrBackView.bottomAnchor.constraint(equalTo: descrText.bottomAnchor, constant: 10),
            descrBackView.leadingAnchor.constraint(equalTo: restBackView.leadingAnchor, constant: 10),
            descrBackView.trailingAnchor.constraint(equalTo: restBackView.trailingAnchor, constant: -10),
            
            descrText.topAnchor.constraint(equalTo: descrBackView.topAnchor, constant: 10),
            descrText.leadingAnchor.constraint(equalTo: descrBackView.leadingAnchor, constant: 10),
            descrText.trailingAnchor.constraint(equalTo: descrBackView.trailingAnchor, constant: -10),
            
            creditsLabel.topAnchor.constraint(equalTo: descrBackView.bottomAnchor, constant: 15),
            creditsLabel.leadingAnchor.constraint(equalTo: descrLabel.leadingAnchor),
            
            credits.topAnchor.constraint(equalTo: creditsLabel.topAnchor),
            credits.leadingAnchor.constraint(equalTo: creditsLabel.trailingAnchor, constant: 10),
            
            reqLabel.topAnchor.constraint(equalTo: creditsLabel.bottomAnchor, constant: 15),
            reqLabel.leadingAnchor.constraint(equalTo: descrLabel.leadingAnchor),
            reqLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width/2-10),
            
            reqs.topAnchor.constraint(equalTo: reqLabel.bottomAnchor),
            reqs.leadingAnchor.constraint(equalTo: reqLabel.leadingAnchor),
            reqs.trailingAnchor.constraint(equalTo: reqLabel.trailingAnchor),
            
            distrLabel.topAnchor.constraint(equalTo: reqs.bottomAnchor, constant: 15),
            distrLabel.leadingAnchor.constraint(equalTo: descrLabel.leadingAnchor),
            
            distrs.topAnchor.constraint(equalTo: distrLabel.bottomAnchor),
            distrs.leadingAnchor.constraint(equalTo: distrLabel.leadingAnchor),
            distrs.trailingAnchor.constraint(equalTo: reqLabel.trailingAnchor),
            
            semsLabel.topAnchor.constraint(equalTo: sems.bottomAnchor, constant: 10),
            semsLabel.leadingAnchor.constraint(equalTo: descrLabel.leadingAnchor),
            
            sems.topAnchor.constraint(equalTo: semsLabel.bottomAnchor, constant: 5),
            sems.leadingAnchor.constraint(equalTo: semsLabel.leadingAnchor),
            sems.trailingAnchor.constraint(equalTo: reqs.trailingAnchor),
            
            overallLabel.topAnchor.constraint(equalTo: creditsLabel.topAnchor),
            overallLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width/2),
            
            overallRating.topAnchor.constraint(equalTo: overallLabel.topAnchor),
            overallRating.trailingAnchor.constraint(equalTo: restBackView.trailingAnchor, constant: -20),
            
            workloadLabel.topAnchor.constraint(equalTo: overallLabel.bottomAnchor),
            workloadLabel.leadingAnchor.constraint(equalTo: overallLabel.leadingAnchor),
            
            workloadRating.topAnchor.constraint(equalTo: workloadLabel.topAnchor),
            workloadRating.trailingAnchor.constraint(equalTo: restBackView.trailingAnchor, constant: -20),
            
            difficultyLabel.topAnchor.constraint(equalTo: workloadLabel.bottomAnchor),
            difficultyLabel.leadingAnchor.constraint(equalTo: overallLabel.leadingAnchor),
            
            difficultyRating.topAnchor.constraint(equalTo: difficultyLabel.topAnchor),
            difficultyRating.trailingAnchor.constraint(equalTo: restBackView.trailingAnchor, constant: -20),
            
            profLabel.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: 15),
            profLabel.leadingAnchor.constraint(equalTo: overallLabel.leadingAnchor),
            
            profs.topAnchor.constraint(equalTo: profLabel.bottomAnchor),
            profs.leadingAnchor.constraint(equalTo: profLabel.leadingAnchor),
            profs.trailingAnchor.constraint(equalTo: restBackView.trailingAnchor, constant: -10),
            
            disButton.topAnchor.constraint(equalTo: restBackView.bottomAnchor, constant: 15),
            disButton.leadingAnchor.constraint(equalTo: nameBackView.leadingAnchor),
            disButton.trailingAnchor.constraint(equalTo: nameBackView.trailingAnchor),
            disButton.heightAnchor.constraint(equalToConstant: 50),
            
            disLabel.centerYAnchor.constraint(equalTo: disButton.centerYAnchor),
            disLabel.leadingAnchor.constraint(equalTo: disButton.leadingAnchor, constant: 15),
            
            commentsBackView.topAnchor.constraint(equalTo: disButton.topAnchor, constant: 7.5),
            commentsBackView.bottomAnchor.constraint(equalTo: disButton.bottomAnchor, constant: -7.5),
            commentsBackView.leadingAnchor.constraint(equalTo: disLabel.trailingAnchor, constant: 20),
            commentsBackView.trailingAnchor.constraint(equalTo: commentsNumber.trailingAnchor, constant: 15),
            
            commentsNumber.centerYAnchor.constraint(equalTo: commentsBackView.centerYAnchor),
            commentsNumber.leadingAnchor.constraint(equalTo: commentsBackView.leadingAnchor, constant: 15),
            
            // will probably get rid of this
            expandRight.bottomAnchor.constraint(equalTo: disButton.centerYAnchor, constant: -1),
            expandRight.trailingAnchor.constraint(equalTo: disButton.trailingAnchor, constant: -15),
            expandRight.widthAnchor.constraint(equalToConstant: 10),
            expandRight.heightAnchor.constraint(equalToConstant: 10),
            
            expandLeft.topAnchor.constraint(equalTo: disButton.centerYAnchor, constant: 1),
            expandLeft.trailingAnchor.constraint(equalTo: expandRight.leadingAnchor, constant: -2),
            expandLeft.widthAnchor.constraint(equalToConstant: 10),
            expandLeft.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    @objc func favorite() {
        if favCourse == false {
            favButton.setImage(UIImage(named: "Star 2"), for: .normal)
            favCourse = true
        }
        else if favCourse == true {
            favButton.setImage(UIImage(named: "Star 1"), for: .normal)
            favCourse = false
        }
    }
    
    @objc func pushToDiscussion() {
//        navigationController?.pushViewController(DiscussionViewController, animated: true)
    }
    
    func configure(courseNumber: String, courseName: String, courseRating: Double, descr: String, credits: Double, reqs: String, distrs: String, overall: Double, workload: Double, difficulty: Double, profs: String) {
        numberLabel.text = courseNumber
        nameLabel.text = courseName
        ratingLabel.text = String(courseRating)
        self.descrText.text = descr
        self.credits.text = String(credits)
        self.reqs.text = reqs
        self.distrs.text = distrs
        overallRating.text = String(overall)
        workloadRating.text = String(workload)
        difficultyRating.text = String(difficulty)
        self.profs.text = profs
    }
}
