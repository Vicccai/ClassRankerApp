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
        label.text = "Feeling lost?\nTired of swapping tabs?"
        label.textColor = .black
        label.font = UIFont(name: "Proxima Nova Bold", size: 30)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var openingText: UILabel = {
        let label = UILabel()
        label.text = "Find courses based on your interests or distribution requirements!\nSee what other Cornellians think of courses or share your own."
        label.textColor = .black
        label.font = UIFont(name: "ProximaNova-Regular", size: 14)
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
        label.text = "Sign In"
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
        label.text = "Create new account"
        label.textColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
        label.font = UIFont(name: "Proxima Nova Bold", size: 16)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        
        for subView in [openingLabel, openingText, signInButton, signInLabel, createAccountButton, createAccountLabel] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            openingLabel.bottomAnchor.constraint(equalTo: openingText.topAnchor, constant: -30),
            openingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            openingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            openingText.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -30),
            openingText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            openingText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
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
            
            createAccountLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            createAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func pushToLogin() {
        navigationController?.pushViewController(LoginController(), animated: true)
    }
    
    @objc func pushToCreateAccount() {
        navigationController?.pushViewController(CreateAccountController(), animated: true)
    }
}

