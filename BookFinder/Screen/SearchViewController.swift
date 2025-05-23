//
//  SearchViewController.swift
//  BookFinder
//
//  Created by 邱允聰 on 19/5/2025.
//

import UIKit

class SearchViewController: UIViewController {
    let searchBookField = SearchBookField()
    var collectionView: UICollectionView!
    let categories = Category.categories
    var books: [Book] = []
    
    var bookViewController: BookViewController!
    
    var isBookNameEmpty: Bool{
        return !searchBookField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshBooks))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(pushSettingViewController))
        navigationItem.rightBarButtonItem?.tintColor = .systemGreen
        navigationController?.navigationBar.tintColor = .systemGreen
        
        configureViewController()
        configureSearchBookField()
        configureBookViewController()
        configureCollectionView()
        createDismissKeyboardTapGesture()        
    }
    
    @objc func pushSettingViewController(){
        let settingViewController = SettingViewController()
        navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    @objc func refreshBooks(){
        bookViewController.getBooks()
    }

    func createDismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func searchFieldPushBookListViewController(){
        let bookListViewController = BookListViewController()
        bookListViewController.searchMethod = .ByName
        
        guard isBookNameEmpty else {
            presentErrorAlertOnMainThread(title: "Empty book name", message: "Please enter a book name. Empty book name is invalid.", buttonTitle: "OK")
            return
        }
        bookListViewController.bookName = searchBookField.text
        bookListViewController.title = searchBookField.text
        navigationController?.pushViewController(bookListViewController, animated: true)
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
    }
    
    func configureBookViewController(){
        bookViewController = BookViewController()
        addChild(bookViewController)
        view.addSubview(bookViewController.view)
        bookViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookViewController.view.topAnchor.constraint(equalTo: searchBookField.bottomAnchor, constant: 12),
            bookViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            bookViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            bookViewController.view.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        bookViewController.didMove(toParent: self)
    }
    
    private func configureSearchBookField(){
        view.addSubview(searchBookField)
        searchBookField.translatesAutoresizingMaskIntoConstraints = false
        searchBookField.delegate = self
        
        NSLayoutConstraint.activate([
            searchBookField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBookField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBookField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBookField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: twoColumnLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseID)
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: bookViewController.view.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    
    
    func twoColumnLayout() -> UICollectionViewFlowLayout{
        let width = view.bounds.width
        let padding: CGFloat = 8
        let minItemSpacing: CGFloat = 10
        let avaliableWidth = width - (padding * 2) - (minItemSpacing)
        let itemWidth = avaliableWidth / 2
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 80)        
        
        return flowLayout
    }
}

extension SearchViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchFieldPushBookListViewController()
        return true
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseID, for: indexPath) as! CategoryCollectionViewCell
        
        let category = categories[indexPath.item]
        cell.set(category: category)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCellTap(_:)))
        cell.addGestureRecognizer(tap)
        cell.tag = indexPath.item
        
        return cell
    }
    
    @objc func handleCellTap(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? CategoryCollectionViewCell else { return }
        let category = categories[cell.tag]
        cellPushBookListViewController(category: category)
    }
    
    func cellPushBookListViewController(category: String){
        let bookListViewController = BookListViewController()
        
        bookListViewController.bookName = category
        bookListViewController.title = category
        bookListViewController.searchMethod = .ByCategory
        navigationController?.pushViewController(bookListViewController, animated: true)
    }
}

