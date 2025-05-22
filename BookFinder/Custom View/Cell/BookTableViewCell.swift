//
//  BookTableViewCell.swift
//  BookFinder
//
//  Created by 邱允聰 on 21/5/2025.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    static let reuseID = "BookTableViewCell"
            
    var bookImageView = UIImageView()
    var bookTitleLabel = UILabel()
    var bookAuthorsLabel = UILabel()
    var bookLanguageLabel = UILabel()
    var bookCategoryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureImageView()
        configureTitleLabel()
        configureAuthorsLabel()
        configureLanguageLabel()
        configureCategoryLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(_ book: Book){
        self.bookImageView.load(book.volumeInfo.imageLinks?.thumbnail)
        self.bookTitleLabel.text = book.volumeInfo.title
        self.bookAuthorsLabel.text = book.volumeInfo.authors?.joined(separator: ", ")
        self.bookLanguageLabel.text = "Language: \(book.volumeInfo.language)"
        if let categories = book.volumeInfo.categories{
            self.bookCategoryLabel.text = "Category: \(categories.joined(separator: ", "))"
        }
    }
    
    func configureImageView(){
        contentView.addSubview(bookImageView)
        
        bookImageView.layer.cornerRadius = 10
        bookImageView.clipsToBounds = true
        
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            bookImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 12),
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            bookImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            bookImageView.heightAnchor.constraint(equalToConstant: 120),
            bookImageView.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func configureTitleLabel() {
        contentView.addSubview(bookTitleLabel)
        
        bookTitleLabel.numberOfLines = 0
        bookTitleLabel.font = .preferredFont(forTextStyle: .title3)
        bookTitleLabel.adjustsFontSizeToFitWidth = true
        bookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            bookTitleLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 12),
            bookTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }

    
    func configureAuthorsLabel(){
        contentView.addSubview(bookAuthorsLabel)
        
        bookAuthorsLabel.numberOfLines = 1
        bookAuthorsLabel.font = .preferredFont(forTextStyle: .subheadline)
        bookAuthorsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookAuthorsLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 4),
            bookAuthorsLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 12),
            bookAuthorsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    func configureLanguageLabel(){
        contentView.addSubview(bookLanguageLabel)
        
        bookLanguageLabel.numberOfLines = 0
        bookLanguageLabel.font = .preferredFont(forTextStyle: .subheadline)
        bookLanguageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookLanguageLabel.topAnchor.constraint(equalTo: bookAuthorsLabel.bottomAnchor, constant: 4),
            bookLanguageLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 12),
            bookLanguageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    func configureCategoryLabel(){
        contentView.addSubview(bookCategoryLabel)
        
        bookCategoryLabel.numberOfLines = 0
        bookCategoryLabel.font = .preferredFont(forTextStyle: .subheadline)
        bookCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookCategoryLabel.topAnchor.constraint(equalTo: bookLanguageLabel.bottomAnchor, constant: 4),
            bookCategoryLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 12),
            bookCategoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
        ])
    }
}
