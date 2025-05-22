//
//  BookListViewController.swift
//  BookFinder
//
//  Created by 邱允聰 on 19/5/2025.
//

import UIKit

class BookListViewController: UIViewController {
    var bookName: String!
    var resultItem: ResultItem?
    var books: [Book]?
    var searchMethod: SearchMethod!        
    
    var tableView = UITableView()
    var spinner = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .systemGreen
        navigationItem.backButtonTitle = "Back"
        configureTableView()
        configureProgressView()
        getBooks()
    }
    
    func getBooks(){
        switch searchMethod {
        case .ByName:
            NetworkManager.shared.getBooksByName(bookName) { resultItem, errorMessage in
                guard let resultItem = resultItem else {
                    self.presentErrorAlertOnMainThread(title: "Failed", message: errorMessage!, buttonTitle: "Ok")
                    return
                }
                
                self.resultItem = resultItem
                self.books = self.resultItem?.items
                
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        case .ByCategory:
            NetworkManager.shared.getBooksByCategory(bookName) { resultItem, errorMessage in
                guard let resultItem = resultItem else {
                    self.presentErrorAlertOnMainThread(title: "Failed", message: errorMessage!, buttonTitle: "Ok")
                    return
                }
                
                self.resultItem = resultItem
                self.books = self.resultItem?.items
                
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        case .none:
            return
        }
        
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        setTableViewDelegate()
        
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.reuseID)
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setTableViewDelegate(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureProgressView(){
        view.addSubview(spinner)
        
        spinner.color = .systemGreen
        spinner.style = .large
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
    
}

extension BookListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.reuseID) as! BookTableViewCell
        guard let book = books?[indexPath.row] else { return UITableViewCell()}
        cell.set(book)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = books![indexPath.row]
        let bookDetailViewController = BookDetailViewController()
        bookDetailViewController.book = selectedBook
        navigationController?.pushViewController(bookDetailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
