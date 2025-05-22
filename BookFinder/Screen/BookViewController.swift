//
//  BookViewController.swift
//  BookFinder
//
//  Created by 邱允聰 on 23/5/2025.
//

import UIKit

class BookViewController: UIViewController {
    var bookCollectionView: UICollectionView!
    var books: [Book] = []
    let spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSpinner()
        configureBookCollectionView()
        getBooks()
    }
    
    func getBooks(){
        books = []
        bookCollectionView.reloadData()
        spinner.startAnimating()
        
        RandomWordManager.shared.getRandomWord { name, error in
            NetworkManager.shared.getBooks(name) { resultItem, error in
                guard let resultItem = resultItem else { return }
                self.books = resultItem.items
                DispatchQueue.main.async {
                    self.updateBooks(resultItem.items)
                    self.spinner.stopAnimating()
                }
            }
        }
    }
    
    func configureSpinner(){
        view.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .systemGreen
        spinner.style = .large
        
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureBookCollectionView(){
        bookCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createRowLayout())
        bookCollectionView.delegate = self
        bookCollectionView.dataSource = self
        bookCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bookCollectionView.backgroundColor = .clear
        bookCollectionView.showsHorizontalScrollIndicator = false
        bookCollectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.reuseID)
                
        bookCollectionView.layer.masksToBounds = false
        bookCollectionView.clipsToBounds = false
        bookCollectionView.layer.shadowColor = UIColor.black.cgColor
        bookCollectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bookCollectionView.layer.shadowOpacity = 0.2        
        
        view.addSubview(bookCollectionView)
        NSLayoutConstraint.activate([
            bookCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            bookCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bookCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bookCollectionView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func createRowLayout() -> UICollectionViewFlowLayout{        
        let padding: CGFloat = 8
        let itemWidth: CGFloat = 230
        let itemHeight: CGFloat = 300
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        return flowLayout
    }
    
    func updateBooks(_ books: [Book]){
        self.books = books
        bookCollectionView.reloadData()
    }
}
    
extension BookViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.reuseID, for: indexPath) as! BookCollectionViewCell
        
        let book = books[indexPath.item]
        cell.set(book)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCellTap(_:)))
        cell.addGestureRecognizer(tap)
        cell.tag = indexPath.item
        
        return cell
    }
    
    @objc func handleCellTap(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? BookCollectionViewCell else { return }
        let book = books[cell.tag]
        cellPushBookDetailViewController(book: book)
    }
    
    func cellPushBookDetailViewController(book: Book){
        let bookDetailViewController = BookDetailViewController()
        bookDetailViewController.book = book
        
        navigationController?.pushViewController(bookDetailViewController, animated: true)
    }
}
