//
//  BookmarkViewController.swift
//  BookFinder
//
//  Created by 邱允聰 on 19/5/2025.
//

import UIKit

class BookmarkViewController: UIViewController {
    var collectionView: UICollectionView!
    var books: [Book] = []
    let spinner = UIActivityIndicatorView()
    let messageLabelView = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshBookShelf))
        navigationController?.navigationBar.tintColor = .systemGreen
        
        configureCollectionView()
        configureSpinner()
        configureMessageLabelView()
        getBooks()
    }
    
    @objc func refreshBookShelf(){
        getBooks()
    }
    
    func getBooks(){
        books = []
        self.collectionView.reloadData()
        spinner.startAnimating()
        
        NetworkManager.shared.getBookshelf { resultItem, error in
            if let error = error{
                DispatchQueue.main.async {
                    self.presentErrorAlertOnMainThread(title: "Load failed", message: error.localizedDescription, buttonTitle: "OK")
                    self.messageLabelView.isHidden = false
                    self.messageLabelView.text = "No book shelf or book have been saved"
                }
            }
            
            if let resultItem = resultItem{
                DispatchQueue.main.async {
                    guard let books = resultItem.items else { return }
                    self.updateBooks(books)
                    self.messageLabelView.isHidden = true
                }
            }
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
        }
    }
    
    func updateBooks(_ books: [Book]){
        self.books = books
        self.collectionView.reloadData()
    }
    
    func configureMessageLabelView(){
        messageLabelView.textColor = .systemGreen
        messageLabelView.font = .preferredFont(forTextStyle: .title3)
        messageLabelView.numberOfLines = 0
        messageLabelView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(messageLabelView)
        
        NSLayoutConstraint.activate([
            messageLabelView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            messageLabelView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }
    
    func configureSpinner(){
        spinner.color = .systemGreen
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ])
    }
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createTwoColLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.reuseID)
        collectionView.backgroundColor = .systemBackground
        let verticalAnchor: CGFloat = 12
        let horizontalAnchor: CGFloat = 12
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: verticalAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -verticalAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }
    
    func createTwoColLayout() -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        let width = view.bounds.width
        let minItemSpacing: CGFloat = 22
        let horizontalPadding: CGFloat = 12
        let verticalPadding: CGFloat = 22
        let avaliableWidth = width - (horizontalPadding * 2) - (minItemSpacing * 2)
        let itemWidth = avaliableWidth / 2 - horizontalPadding * 2
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumLineSpacing = minItemSpacing
        layout.minimumInteritemSpacing = minItemSpacing
            
        return layout
    }
}

extension BookmarkViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.reuseID, for: indexPath) as! BookCollectionViewCell
        
        let book = books[indexPath.item]
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCellTap(_:)))
        
        cell.set(book)
        cell.addGestureRecognizer(tap)
        cell.tag = indexPath.item
        
        return cell
    }
    
    @objc func handleCellTap(_ sender: UITapGestureRecognizer){
        guard let cell = sender.view as? BookCollectionViewCell else { return }
        let book = books[cell.tag]
        cellPushBookDetailViewController(book)
    }
    
    func cellPushBookDetailViewController(_ book: Book){
        let bookDetailViewController = BookDetailViewController()
        bookDetailViewController.book = book
        navigationController?.pushViewController(bookDetailViewController, animated: true)
    }
}
