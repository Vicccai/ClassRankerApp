//
//  OpeningViewController.swift
//  ClassRankerApp
//
//  Created by Mariana Meriles on 5/5/22.
//
 
import Foundation
import UIKit
 
class OpeningViewController: UIViewController {
    var openingLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't wing it! Find courses based on user ratings and your distribution codes!"
        label.textColor = .black
        label.font = UIFont(name: "ProximaNova-Regular", size: 16)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    var guestLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(pushToLoginGuest), for: .touchUpInside)
        return button
    }()
    
    var guestLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "Continue As Guest"
        label.textColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
        label.font = UIFont(name: "Proxima Nova Bold", size: 16)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(pushToLogin), for: .touchUpInside)
        return button
    }()
    
    var signInLabel: UILabel = {
        let label = UILabel()
        label.text = "Log In"
        label.textColor = .white
        label.font = UIFont(name: "Proxima Nova Bold", size: 20)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var createAccountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(pushToCreateAccount), for: .touchUpInside)
        return button
    }()
    
    var createAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Create New Account"
        label.textColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
        label.font = UIFont(name: "Proxima Nova Bold", size: 16)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "class rooster")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        view.isMultipleTouchEnabled = false
        
        for subView in [openingLabel, guestLoginButton, guestLoginLabel, signInButton, signInLabel, createAccountButton, createAccountLabel, imageView] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        //prefetch data
        NetworkManager.getAllCourses() { courses in
            Globals.courses = courses.courses
            NotificationCenter.default.post(name: Notification.Name("CoursesLoaded"), object: nil)
        }
        navigationItem.backButtonTitle = ""
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, constant: 90),
            imageView.bottomAnchor.constraint(equalTo: openingLabel.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            openingLabel.bottomAnchor.constraint(equalTo: guestLoginLabel.topAnchor, constant: -20),
            openingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            openingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            guestLoginButton.topAnchor.constraint(equalTo: guestLoginLabel.topAnchor, constant: -10),
            guestLoginButton.bottomAnchor.constraint(equalTo: guestLoginLabel.bottomAnchor, constant: 10),
            guestLoginButton.leadingAnchor.constraint(equalTo: guestLoginLabel.leadingAnchor, constant: -10),
            guestLoginButton.trailingAnchor.constraint(equalTo: guestLoginLabel.trailingAnchor, constant: 10),
            
            guestLoginLabel.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -15),
            guestLoginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            signInButton.bottomAnchor.constraint(equalTo: createAccountButton.topAnchor, constant: -5),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: 250),
            
            signInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInLabel.centerYAnchor.constraint(equalTo: signInButton.centerYAnchor),
            
            createAccountButton.topAnchor.constraint(equalTo: createAccountLabel.topAnchor, constant: -10),
            createAccountButton.bottomAnchor.constraint(equalTo: createAccountLabel.bottomAnchor, constant: 10),
            createAccountButton.leadingAnchor.constraint(equalTo: createAccountLabel.leadingAnchor, constant: -10),
            createAccountButton.trailingAnchor.constraint(equalTo: createAccountLabel.trailingAnchor, constant: 10),
            
            createAccountLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            createAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    
    @objc func pushToLogin() {
        navigationController?.pushViewController(LoginController(), animated: true)
    }
    
    @objc func pushToCreateAccount() {
        navigationController?.pushViewController(CreateAccountController(), animated: true)
    }
    
    @objc func pushToLoginGuest(){
        Globals.guest = true
        navigationController?.pushViewController(RankViewController(), animated: true)
    }
}

