//
//  CategoryCollectionViewCell.swift
//  BookFinder
//
//  Created by 邱允聰 on 20/5/2025.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let reuseID = "CategoryCollectionViewCell"
    let categoryButton = CustomButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(category: String){
        categoryButton.setTitle(category, for: .normal)
        categoryButton.backgroundColor = .systemGreen
    }
        
    
    private func configure(){
        addSubview(categoryButton)
        
        categoryButton.titleLabel?.numberOfLines = 0
        
        let padding: CGFloat = 4
                
        NSLayoutConstraint.activate([
            categoryButton.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            categoryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            categoryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            categoryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
}
