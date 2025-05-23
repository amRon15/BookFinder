//
//  LoginViewController.swift
//  BookFinder
//
//  Created by 邱允聰 on 23/5/2025.
//

import UIKit

class LoginViewController: UIViewController {
    let labelView = UILabel()
    let loginButton =  UIButton()

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        super.viewDidLoad()
        configureLabelView()
        configureLoginButton()
    }
    
    func configureLabelView(){
        labelView.text = "Welcome to Book Finder"
        labelView.font = .preferredFont(forTextStyle: .title1)
        labelView.textColor = .systemGreen
        labelView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelView)        
        
        NSLayoutConstraint.activate([
            labelView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            labelView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    

    func configureLoginButton(){
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Set button title and style
        loginButton.setTitle("Login with Google", for: .normal)
        loginButton.titleLabel?.font = .preferredFont(forTextStyle: .title3)
        loginButton.setTitleColor(.systemBlue, for: .normal)
        
        // Configure button appearance
        loginButton.backgroundColor = .systemBackground
        loginButton.layer.cornerRadius = 10
        loginButton.layer.masksToBounds = false
        loginButton.clipsToBounds = false
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        loginButton.layer.shadowOpacity = 0.2
        loginButton.layer.shadowRadius = 4
        
        // Add padding
        loginButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        loginButton.addTarget(self, action: #selector(tapToLogin), for: .touchUpInside)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func tapToLogin(){
        print("Login button tapped")
        NetworkManager.shared.signInWithGoogle(self) { [weak self] isSuccess, error in
            if isSuccess {
                print("Login successful, transitioning to main interface")
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let sceneDelegate = windowScene.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = sceneDelegate.tabbar()
                }
            } else {
                print("Login failed: \(error ?? "Unknown error")")
                DispatchQueue.main.async {
                    self?.presentErrorAlertOnMainThread(
                        title: "Login Failed",
                        message: error ?? "An unknown error occurred",
                        buttonTitle: "OK"
                    )
                }
            }
        }
    }
}
