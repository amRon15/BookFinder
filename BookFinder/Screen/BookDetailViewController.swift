//
//  BookDetailViewController.swift
//  BookFinder
//
//  Created by 邱允聰 on 21/5/2025.
//

import UIKit

class BookDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var book: Book!
    let collectionViewItems = ["Overview", "Detail", "Links"]
    var selectedIndex = 0
    
    // Top section
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    var authorLabel = UILabel()
    var categoryLabel = UILabel()
    var languageLabel = UILabel()
    
    let seperatorView = UIView()
    
    // Tab view
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 30
        layout.minimumLineSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    let scrollView = UIScrollView()
    let overviewView = UIView()
    let detailView = UIView()
    let linkView = UIView()
    
    // Overview section
    var descriptionLabel = UILabel()
    
    // Detail section
    var saleCountryLabel = UILabel()
    var saleAbilityLabel = UILabel()
    var retailPriceLabel = UILabel()
    var listPriceLabel = UILabel()
    var countryLabel = UILabel()
    var publisherLabel = UILabel()
    var publishedDateLabel = UILabel()
    var pageCountLabel = UILabel()
    
    // Links section
    var previewLinkLabel = UILabel()
    var infoLinkLabel = UILabel()
    var webReaderLinkLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        configureTopSection()
        configureSeperatorView()
        configureTabView()
        updateContentView()
    }
    
    func configureSeperatorView(){
        view.addSubview(seperatorView)
        
        seperatorView.backgroundColor = .separator
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seperatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            seperatorView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            seperatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            seperatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            seperatorView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            seperatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func configureTabView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "BookDetailCollectionViewCell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: seperatorView.bottomAnchor, constant: 18),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            collectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        view.addSubview(scrollView)
        scrollView.addSubview(overviewView)
        scrollView.addSubview(detailView)
        scrollView.addSubview(linkView)
        
        let topAnchor: CGFloat = 8
        let horizontalAnchor: CGFloat = 12
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        overviewView.translatesAutoresizingMaskIntoConstraints = false
        detailView.translatesAutoresizingMaskIntoConstraints = false
        linkView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            overviewView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            overviewView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: horizontalAnchor),
            overviewView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -horizontalAnchor),
            overviewView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -(horizontalAnchor * 2)),
            overviewView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            detailView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: horizontalAnchor),
            detailView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -horizontalAnchor),
            detailView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -(horizontalAnchor * 2)),
            detailView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            linkView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            linkView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: horizontalAnchor),
            linkView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -horizontalAnchor),
            linkView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -(horizontalAnchor * 2)),
            linkView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
        
        detailView.isHidden = true
        linkView.isHidden = true
        
        configureOverview()
        configureDetail()
        configureLink()
    }
    
    func configureOverview() {
        overviewView.addSubview(descriptionLabel)
        
        descriptionLabel.text = book?.volumeInfo.description ?? "No description available"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: overviewView.topAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: overviewView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: overviewView.trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(equalTo: overviewView.bottomAnchor, constant: -12)
        ])
    }
    
    func configureDetail() {
        detailView.addSubview(saleCountryLabel)
        detailView.addSubview(saleAbilityLabel)
        detailView.addSubview(retailPriceLabel)
        detailView.addSubview(listPriceLabel)
        detailView.addSubview(countryLabel)
        detailView.addSubview(publisherLabel)
        detailView.addSubview(publishedDateLabel)
        detailView.addSubview(pageCountLabel)
        
        let labels = [saleCountryLabel, saleAbilityLabel, retailPriceLabel, listPriceLabel, countryLabel, publisherLabel, publishedDateLabel, pageCountLabel]
        for (index, label) in labels.enumerated() {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Detail \(index + 1)" // 替換為實際數據
            label.numberOfLines = 0
            detailView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 12),
                label.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -12),
                label.topAnchor.constraint(equalTo: index == 0 ? detailView.topAnchor : labels[index - 1].bottomAnchor, constant: index == 0 ? 12 : 8),
                label.bottomAnchor.constraint(equalTo: index == labels.count - 1 ? detailView.bottomAnchor : labels[index + 1].topAnchor, constant: index == labels.count - 1 ? -12 : 0)
            ])
        }
    }
    
    func configureLink() {
        linkView.addSubview(previewLinkLabel)
        linkView.addSubview(infoLinkLabel)
        linkView.addSubview(webReaderLinkLabel)
        
        let labels = [previewLinkLabel, infoLinkLabel, webReaderLinkLabel]
        for (index, label) in labels.enumerated() {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Link \(index + 1)" // 替換為實際數據
            label.numberOfLines = 0
            linkView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: linkView.leadingAnchor, constant: 12),
                label.trailingAnchor.constraint(equalTo: linkView.trailingAnchor, constant: -12),
                label.topAnchor.constraint(equalTo: index == 0 ? linkView.topAnchor : labels[index - 1].bottomAnchor, constant: index == 0 ? 12 : 8),
                label.bottomAnchor.constraint(equalTo: index == labels.count - 1 ? linkView.bottomAnchor : labels[index + 1].topAnchor, constant: index == labels.count - 1 ? -12 : 0)
            ])
        }
    }
    
    func configureTopSection() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(authorLabel)
        view.addSubview(categoryLabel)
        view.addSubview(languageLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.load(book?.volumeInfo.imageLinks?.thumbnail)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.text = book?.volumeInfo.title ?? "Unknown Title"
        titleLabel.numberOfLines = 0
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = .preferredFont(forTextStyle: .headline)
        subtitleLabel.text = book?.volumeInfo.subtitle
        subtitleLabel.numberOfLines = 0
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = .preferredFont(forTextStyle: .headline)
        authorLabel.text = book?.volumeInfo.authors?.joined(separator: ", ") ?? "Unknown Author"
        authorLabel.textColor = .lightGray
        authorLabel.numberOfLines = 0
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.text = book?.volumeInfo.categories?.joined(separator: ", ")
        categoryLabel.font = .preferredFont(forTextStyle: .headline)
        categoryLabel.textColor = .lightGray
        categoryLabel.numberOfLines = 0
        
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.text = book?.volumeInfo.language
        languageLabel.textColor = .lightGray
        languageLabel.font = .preferredFont(forTextStyle: .headline)
        languageLabel.numberOfLines = 0
        
        let leadingAnchor: CGFloat = 12
        let trailingAnchor: CGFloat = -12
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 170),
            imageView.widthAnchor.constraint(equalToConstant: 140),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: trailingAnchor),
            
            authorLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
            authorLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: trailingAnchor),
            
            languageLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            languageLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: leadingAnchor),
            languageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: trailingAnchor),
            
            categoryLabel.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: trailingAnchor)
        ])
    }
}

extension BookDetailViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookDetailCollectionViewCell", for: indexPath)
                                
        let label = UILabel()
                                
        label.text = collectionViewItems[indexPath.item]
        label.textColor = (indexPath.item == selectedIndex) ? .systemGreen : .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.frame = cell.contentView.bounds        
                
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(label)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
        updateContentView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width / 3 - 30 
        return CGSize(width: width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    func updateContentView() {
        overviewView.isHidden = true
        detailView.isHidden = true
        linkView.isHidden = true
        
        switch selectedIndex {
        case 0:
            overviewView.isHidden = false
        case 1:
            detailView.isHidden = false
        case 2:
            linkView.isHidden = false
        default:
            break
        }
    }
}
