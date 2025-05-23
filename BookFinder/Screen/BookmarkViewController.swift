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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    func getBooks(){
        
    }
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createThreeColLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.reuseID)
        collectionView.backgroundColor = .systemBackground
        let verticalAnchor: CGFloat = 12
        let horizontalAnchor: CGFloat = 12
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: verticalAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -verticalAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
        
        
        view.addSubview(collectionView)
    }
    
    func createThreeColLayout() -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        let width = view.bounds.width
        let minItemSpacing: CGFloat = 10
        let padding: CGFloat = 8
        let avaliableWidth = width - (padding * 3) - (minItemSpacing)
        let itemWidth = avaliableWidth / 3
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.itemSize = CGSize(width: itemWidth, height: 80)
            
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
