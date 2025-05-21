//
//  UIImageView+ext.swift
//  BookFinder
//
//  Created by 邱允聰 on 21/5/2025.
//

import Foundation
import UIKit

extension UIImageView{
    func load(_ urlString: String?){
        if let urlString = urlString?.replacingOccurrences(of: "http://", with: "https://"),
            let url = URL(string: urlString){
            DispatchQueue.global().async{[weak self] in                
                if let data = try? Data(contentsOf: url){
                    if let image = UIImage(data: data){
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    } else{
                        self?.image = UIImage(systemName: "photo.fill")
                        self?.backgroundColor = .lightGray
                        self?.tintColor = .systemGray
                    }
                }
            }
        }
    }
}
