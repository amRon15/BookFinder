//
//  CategoryCollectionViewCell.swift
//  BookFinder
//
//  Created by 邱允聰 on 20/5/2025.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let reuseID = "CategoryCollectionViewCell"
    let categoryLabel = PaddedLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(category: String){
        categoryLabel.text = category
        categoryLabel.backgroundColor = .systemGreen
        categoryLabel.textColor = .white
        categoryLabel.layer.cornerRadius = 10
        categoryLabel.layer.masksToBounds = true
        
    }
        
    
    private func configure(){
        addSubview(categoryLabel)
        
        categoryLabel.numberOfLines = 0
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.textAlignment = .center
        categoryLabel.isUserInteractionEnabled = true
        
        let padding: CGFloat = 4
        isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
}
