//
//  UIViewController+Ext.swift
//  BookFinder
//
//  Created by 邱允聰 on 19/5/2025.
//

import Foundation
import UIKit

extension UIViewController{
    
    func presentErrorAlertOnMainThread(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async{
            let errorAlertViewController = ErrorAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            errorAlertViewController.modalPresentationStyle = .overFullScreen
            errorAlertViewController.modalTransitionStyle = .crossDissolve
            self.present(errorAlertViewController, animated: true)
        }
    }
}
