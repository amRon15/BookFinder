//
//  BookCollectionViewCell.swift
//  BookFinder
//
//  Created by 邱允聰 on 23/5/2025.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    static let reuseID = "BookCollectionCellView"
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(_ book: Book){
        imageView.load(book.volumeInfo?.imageLinks?.thumbnail)
    }
    
    func configureImageView(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
