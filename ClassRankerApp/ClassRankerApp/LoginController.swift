//
//  LoginController.swift
//  ClassRankerApp
//
//  Created by Mariana Meriles on 5/2/22.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    
    var padding = CGFloat(20)
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Log In"
        label.font = .boldSystemFont(ofSize: 50)
        label.textColor = .white
        return label
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username:"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    var usernameField: TextFieldWithPadding = {
        let field = TextFieldWithPadding()
        field.autocapitalizationType = .none
        field.backgroundColor = .white
        field.layer.cornerRadius = 20
        field.tintColor = .lightGray
        field.placeholder = "username"
        return field
    }()
    
    var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password:"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    var passwordField: TextFieldWithPadding = {
        let field = TextFieldWithPadding()
        field.autocapitalizationType = .none
        field.backgroundColor = .white
        field.layer.cornerRadius = 20
        field.tintColor = .lightGray
        field.placeholder = "password"
        return field
    }()
    
    var logInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor(red: 0.5, green: 0, blue: 0, alpha: 1.0), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        return button
    }()
    
    var createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 1.0)
        
        for subView in [titleLabel, usernameLabel, usernameField, passwordLabel, passwordField, logInButton, createAccountButton] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        navigationItem.hidesBackButton = true
            
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 125),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            
            usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            
            usernameField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            usernameField.heightAnchor.constraint(equalToConstant: 40),
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            passwordLabel.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: padding),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            logInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 40),
            logInButton.heightAnchor.constraint(equalToConstant: 40),
            logInButton.widthAnchor.constraint(equalToConstant: 80),
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            createAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            createAccountButton.heightAnchor.constraint(equalToConstant: 40),
            createAccountButton.widthAnchor.constraint(equalToConstant: 200),
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func logIn() {
        if usernameField.text == "" {
            let alert = UIAlertController(title: "Invalid Login", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Input Username", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        else if passwordField.text == "" {
            let alert = UIAlertController(title: "Invalid Login", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Input Password", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        navigationController?.pushViewController(RankViewController(), animated: true)
    }
    
    @objc func createAccount() {
        navigationController?.pushViewController(CreateAccountController(), animated: true)
    }
    
}
