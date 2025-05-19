//
//  ErrorAlertViewController.swift
//  BookFinder
//
//  Created by 邱允聰 on 19/5/2025.
//

import UIKit

class ErrorAlertViewController: UIViewController {
    let containerView = UIView()
    let titleLabel = ErrorTitleLabel(textAlignment: .center, fontSize: 20)
    let bodyLabel = ErrorBodyLabel(textAlignment: .center)
    let actionBtn = CustomButton(backgroundColor: .systemPink, title: "OK")
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    init(title: String, message: String, buttonTitle: String){
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        configureContainerView()
        configureTitleLabel()
        configureActionBtn()
        configureBodyLabel()
    }

    func configureContainerView(){
        view.addSubview(containerView)
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.backgroundColor = UIColor.systemBackground.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            containerView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func configureTitleLabel(){
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    func configureActionBtn(){
        containerView.addSubview(actionBtn)
        actionBtn.setTitle(buttonTitle ?? "OK", for: .normal)
        actionBtn.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionBtn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            actionBtn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            actionBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            actionBtn.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configureBodyLabel(){
        containerView.addSubview(bodyLabel)
        bodyLabel.text = message ?? "Unable to complete request"
        bodyLabel.numberOfLines = 3
        
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            bodyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            bodyLabel.bottomAnchor.constraint(equalTo: actionBtn.topAnchor, constant: -12)
        ])
    }
    
    @objc func dismissViewController(){
        dismiss(animated: true)
    }
}
