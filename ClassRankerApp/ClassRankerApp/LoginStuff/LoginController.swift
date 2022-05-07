//
//  LoginController.swift
//  ClassRankerApp
//
//  Created by Mariana Meriles on 5/2/22.
//
 
import Foundation
import UIKit
 
class LoginController: UIViewController {
    
    lazy var delegate = UIViewController()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Log In"
        label.font = UIFont(name: "Proxima Nova Bold", size: 30)
        label.textColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
        return label
    }()
    
    var signInLabel: UILabel = {
        let label = UILabel()
        label.text = "Please sign in to continue."
        label.font = UIFont(name: "Proxima Nova Bold", size: 20)
        label.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00)
        return label
    }()
    
    var usernameBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username:"
        label.font = UIFont(name: "ProximaNova-Regular", size: 14)
        label.textColor = .black
        return label
    }()
    
    var usernameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.backgroundColor = .clear
        field.placeholder = "username"
        field.font = UIFont(name: "Proxima Nova Bold", size: 14)
        return field
    }()
    
    var usernameImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Group 18")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var passwordBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password:"
        label.font = UIFont(name: "ProximaNova-Regular", size: 14)
        label.textColor = .black
        return label
    }()
    
    var passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.backgroundColor = .clear
        field.placeholder = "password"
        field.font = UIFont(name: "Proxima Nova Bold", size: 14)
        field.isSecureTextEntry = true
        return field
    }()
    
    var passwordImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Group 19")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var logInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        return button
    }()
    
    var logInLabel: UILabel = {
        let label = UILabel()
        label.text = "Log In"
        label.font = UIFont(name: "Proxima Nova Bold", size: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    var createAccountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        return button
    }()
    
    var createAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?\nCreate a new one!"
        label.font = UIFont(name: "ProximaNova-Regular", size: 14)
        label.textColor = UIColor(red: 0.76, green: 0.00, blue: 0.18, alpha: 1.00)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var roosterImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Roosting")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        
        for subView in [titleLabel, signInLabel, usernameBackView, usernameLabel, usernameField, usernameImageView, passwordBackView, passwordLabel, passwordField, passwordImageView, logInButton, logInLabel, createAccountButton, createAccountLabel, roosterImageView] {
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
        }
        
        navigationItem.hidesBackButton = true
            
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            signInLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            signInLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            usernameBackView.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 50),
            usernameBackView.bottomAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10),
            usernameBackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            usernameBackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            usernameLabel.topAnchor.constraint(equalTo: usernameBackView.topAnchor, constant: 10),
            usernameLabel.leadingAnchor.constraint(equalTo: usernameImageView.trailingAnchor, constant: 20),
            
            usernameField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor),
            usernameField.leadingAnchor.constraint(equalTo: usernameImageView.trailingAnchor, constant: 20),
            usernameField.trailingAnchor.constraint(equalTo: usernameBackView.trailingAnchor, constant: -10),
            
            usernameImageView.centerYAnchor.constraint(equalTo: usernameBackView.centerYAnchor),
            usernameImageView.heightAnchor.constraint(equalToConstant: 20),
            usernameImageView.widthAnchor.constraint(equalToConstant: 20),
            usernameImageView.leadingAnchor.constraint(equalTo: usernameBackView.leadingAnchor, constant: 20),
            
            passwordBackView.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20),
            passwordBackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            passwordBackView.trailingAnchor.constraint(equalTo: usernameBackView.trailingAnchor),
            passwordBackView.bottomAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 10),
            
            passwordLabel.topAnchor.constraint(equalTo: passwordBackView.topAnchor, constant: 10),
            passwordLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor),
            passwordField.leadingAnchor.constraint(equalTo: passwordLabel.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: passwordBackView.trailingAnchor, constant: -10),
            
            passwordImageView.centerYAnchor.constraint(equalTo: passwordBackView.centerYAnchor),
            passwordImageView.heightAnchor.constraint(equalToConstant: 20),
            passwordImageView.widthAnchor.constraint(equalToConstant: 20),
            passwordImageView.leadingAnchor.constraint(equalTo: passwordBackView.leadingAnchor, constant: 20),
            
            logInButton.topAnchor.constraint(equalTo: passwordBackView.bottomAnchor, constant: 50),
            logInButton.heightAnchor.constraint(equalToConstant: 40),
            logInButton.widthAnchor.constraint(equalToConstant: 150),
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logInLabel.centerYAnchor.constraint(equalTo: logInButton.centerYAnchor),
            logInLabel.centerXAnchor.constraint(equalTo: logInButton.centerXAnchor),
            
            createAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createAccountButton.heightAnchor.constraint(equalTo: createAccountLabel.heightAnchor, constant: 10),
            createAccountButton.widthAnchor.constraint(equalToConstant: 200),
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            createAccountLabel.centerXAnchor.constraint(equalTo: createAccountButton.centerXAnchor),
            createAccountLabel.centerYAnchor.constraint(equalTo: createAccountButton.centerYAnchor),
            
            roosterImageView.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 15),
            roosterImageView.heightAnchor.constraint(equalToConstant: 200),
            roosterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            roosterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
        NetworkManager.login(username: usernameField.text!, password: passwordField.text!) { user in
            Globals.user = User(username: user.username, session_token: user.session_token)
            self.navigationController?.pushViewController(RankViewController(), animated: true)
        } failureCompletion: {
            let alert = UIAlertController(title: "Invalid Username or Password", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func createAccount() {
        navigationController?.pushViewController(CreateAccountController(), animated: true)
    }
    
    func configure(username: String) {
        usernameField.text = username
    }
}

