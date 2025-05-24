//
//  SettingViewController.swift
//  BookFinder
//
//  Created by 邱允聰 on 24/5/2025.
//

import UIKit

class SettingViewController: UIViewController {
    let logoutButton = UIButton()
    let userImageView = UIImageView()
    let userNameLabel = UILabel()
    let userEmailLabel = UILabel()
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemGreen
        
        configureUser()
        getUserProfile()
    }
    
    func getUserProfile(){
        NetworkManager.shared.getUserInfo { [weak self] user, error in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    self?.presentErrorAlertOnMainThread(title: "Error", message: error, buttonTitle: "OK")
                }
                return
            }
            
            if let user = user {
                DispatchQueue.main.async {
                    self?.user = user
                    self?.updateUserInfo()
                }
            }
        }
    }
    
    func updateUserInfo() {
        userImageView.load(user?.imageUrl)
        userNameLabel.text = user?.name
        userEmailLabel.text = user?.email
    }
    
    func configureLogoutButton(){
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Set button title and style
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.titleLabel?.font = .preferredFont(forTextStyle: .title3)
        logoutButton.setTitleColor(.systemBlue, for: .normal)
        
        // Configure button appearance
        logoutButton.backgroundColor = .systemBackground
        logoutButton.layer.cornerRadius = 10
        logoutButton.layer.masksToBounds = false
        logoutButton.clipsToBounds = false
        logoutButton.layer.shadowColor = UIColor.black.cgColor
        logoutButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        logoutButton.layer.shadowOpacity = 0.2
        logoutButton.layer.shadowRadius = 4
        
        // Add padding
        logoutButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        view.addSubview(logoutButton)
        
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: userEmailLabel.bottomAnchor, constant: 30)
        ])
    }
    
    func configureUser(){
        view.addSubview(userImageView)
        view.addSubview(userNameLabel)
        view.addSubview(userEmailLabel)
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure user image view
        userImageView.contentMode = .scaleAspectFit
        userImageView.layer.cornerRadius = 50
        userImageView.clipsToBounds = true
        userImageView.backgroundColor = .systemGray6
        
        // Configure name label
        userNameLabel.textColor = .systemGreen
        userNameLabel.font = .preferredFont(forTextStyle: .title2)
        userNameLabel.textAlignment = .center
        
        // Configure email label
        userEmailLabel.textColor = .systemGray
        userEmailLabel.font = .preferredFont(forTextStyle: .body)
        userEmailLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            userImageView.widthAnchor.constraint(equalToConstant: 100),
            userImageView.heightAnchor.constraint(equalToConstant: 100),
            
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userEmailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            userEmailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        configureLogoutButton()
    }
    
    @objc func logout(){
        NetworkManager.shared.signOut()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = LoginViewController()
        }
    }

}
