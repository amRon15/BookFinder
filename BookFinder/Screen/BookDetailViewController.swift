//
//  BookDetailViewController.swift
//  BookFinder
//
//  Created by 邱允聰 on 21/5/2025.
//

import UIKit

class BookDetailViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    var book: Book!
    let collectionViewItems = ["Overview", "Detail", "Links"]
    var selectedIndex = 0
    
    // Scroll view
    let scrollView = UIScrollView()
    let contentView = UIView() // Container for all content
    
    // Top section
    let topSection = UIView()
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    var authorLabel = UILabel()
    var categoryLabel = UILabel()
    var languageLabel = UILabel()
    
    // Tab view
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 30
        layout.minimumLineSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    // Content sections
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
    var previewLinkLabel = UIButton()
    var infoLinkLabel = UIButton()
    var webReaderLinkLabel = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .systemGreen
        
        // Configure views in correct order
        configureScrollView()
        configureTopSection()
        configureTabView()
        configureOverview()
        configureDetail()
        configureLink()
        
        // Set initial view state
        updateContentView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateScrollViewContentSize()
    }
    
    func updateScrollViewContentSize() {
        // Force layout update
        contentView.layoutIfNeeded()
        
        // Calculate the total height needed
        var totalHeight: CGFloat = 0
        
        // Add top section height
        totalHeight += topSection.frame.height
        
        // Add collection view height and spacing
        totalHeight += collectionView.frame.height + 20
        
        // Add the height of the visible content view
        let visibleView = [overviewView, detailView, linkView].first { !$0.isHidden }
        if let visibleView = visibleView {
            totalHeight += visibleView.frame.height
        }
        
        // Add bottom padding
        totalHeight += 20
        
        // Update scroll view content size
        scrollView.contentSize = CGSize(
            width: scrollView.frame.width,
            height: totalHeight
        )
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
        
        // Update scroll view content size after view state changes
        updateScrollViewContentSize()
    }
    
    func openURL(_ urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        // Add all sections to contentView
        contentView.addSubview(topSection)
        contentView.addSubview(collectionView)
        contentView.addSubview(overviewView)
        contentView.addSubview(detailView)
        contentView.addSubview(linkView)
        
        topSection.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        overviewView.translatesAutoresizingMaskIntoConstraints = false
        detailView.translatesAutoresizingMaskIntoConstraints = false
        linkView.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalAnchor: CGFloat = 12
        NSLayoutConstraint.activate([
            topSection.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            topSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalAnchor),
            topSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topSection.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 60),
            
            overviewView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            overviewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalAnchor),
            overviewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalAnchor),
            
            detailView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            detailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalAnchor),
            detailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalAnchor),
            
            linkView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            linkView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalAnchor),
            linkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalAnchor),
            linkView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        // Initially hide detail and link views
        detailView.isHidden = true
        linkView.isHidden = true
    }

    func configureTopSection() {
        // Add subviews to topSection
        topSection.addSubview(imageView)
        topSection.addSubview(titleLabel)
        topSection.addSubview(subtitleLabel)
        topSection.addSubview(authorLabel)
        topSection.addSubview(categoryLabel)
        topSection.addSubview(languageLabel)
        
        // Configure subviews
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.load(book?.volumeInfo.imageLinks?.thumbnail)
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.text = book?.volumeInfo.title ?? "Unknown Title"
        titleLabel.numberOfLines = 0
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = .preferredFont(forTextStyle: .headline)
        subtitleLabel.text = book?.volumeInfo.subtitle
        subtitleLabel.textColor = .systemGray
        subtitleLabel.numberOfLines = 0
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = .preferredFont(forTextStyle: .headline)
        authorLabel.text = book?.volumeInfo.authors?.joined(separator: ", ") ?? "Unknown Author"
        authorLabel.textColor = .lightGray
        authorLabel.numberOfLines = 0
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.text = book?.volumeInfo.categories?.joined(separator: ", ") ?? "No Categories"
        categoryLabel.font = .preferredFont(forTextStyle: .headline)
        categoryLabel.textColor = .lightGray
        categoryLabel.numberOfLines = 0
        
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.text = book?.volumeInfo.language ?? "Unknown Language"
        languageLabel.textColor = .lightGray
        languageLabel.font = .preferredFont(forTextStyle: .headline)
        languageLabel.numberOfLines = 0
        
        let leadingAnchor: CGFloat = 12
        let trailingAnchor: CGFloat = -12
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topSection.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: topSection.leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 170),
            imageView.widthAnchor.constraint(equalToConstant: 140),
            
            titleLabel.topAnchor.constraint(equalTo: topSection.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: topSection.trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: topSection.trailingAnchor),
            
            authorLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
            authorLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: topSection.trailingAnchor),
            
            languageLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            languageLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: leadingAnchor),
            languageLabel.trailingAnchor.constraint(equalTo: topSection.trailingAnchor),
            
            categoryLabel.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: topSection.trailingAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: topSection.bottomAnchor)
        ])
    }
    
    func configureTabView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "BookDetailCollectionViewCell")
        
        collectionView.layer.cornerRadius = 10
        collectionView.layer.masksToBounds = false
        collectionView.clipsToBounds = false
        collectionView.layer.shadowColor = UIColor.black.cgColor
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        collectionView.layer.shadowOpacity = 0.2
        collectionView.layer.shadowRadius = 4
        
        configureOverview()
        configureDetail()
        configureLink()
    }
    
    func configureOverview() {
        overviewView.addSubview(descriptionLabel)
        
        descriptionLabel.text = book?.volumeInfo.description ?? "No description available"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        let attributes = NSAttributedString(string: descriptionLabel.text!, attributes: [.paragraphStyle: paragraphStyle])
        descriptionLabel.attributedText = attributes
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: overviewView.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: overviewView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: overviewView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: overviewView.bottomAnchor)
        ])
    }
    
    func configureDetail() {
        let labels = [pageCountLabel, publishedDateLabel, publisherLabel, saleAbilityLabel, saleCountryLabel, listPriceLabel, retailPriceLabel]
        
        let nilValue = "Not available"
        
        if let pageCount = book.volumeInfo.pageCount {
            pageCountLabel.attributedText = NSAttributedString().detailAttributedText("Number of pages", "\(pageCount)")
        } else {
            pageCountLabel.attributedText = NSAttributedString().detailAttributedText("Number of pages", "\(nilValue)")
        }
        
        if let publishedDate = book.volumeInfo.publishedDate {
            publishedDateLabel.attributedText = NSAttributedString().detailAttributedText("Published date", "\(publishedDate)")
        } else {
            publishedDateLabel.attributedText = NSAttributedString().detailAttributedText("Published date", "\(nilValue)")
        }
        
        if let publisher = book.volumeInfo.publisher {
            publisherLabel.attributedText = NSAttributedString().detailAttributedText("Publisher", "\(publisher)")
        } else {
            publisherLabel.attributedText = NSAttributedString().detailAttributedText("Publisher", "\(nilValue)")
        }
        
        saleAbilityLabel.attributedText = NSAttributedString().detailAttributedText("Sale ability", "\(book.saleInfo.saleability)")
        
        saleCountryLabel.attributedText = NSAttributedString().detailAttributedText("Country", "\(book.saleInfo.country)")
        
        if let listPrice = book.saleInfo.listPrice {
            listPriceLabel.attributedText = NSAttributedString().detailAttributedText("List Price", "\(listPrice.currencyCode) \(listPrice.amount)")
        } else {
            listPriceLabel.attributedText = NSAttributedString().detailAttributedText("List Price", "\(nilValue)")
        }
        
        if let retailPrice = book.saleInfo.retailPrice {
            retailPriceLabel.attributedText = NSAttributedString().detailAttributedText("Retail Price", "\(retailPrice.currencyCode) \(retailPrice.amount)")
        } else {
            retailPriceLabel.attributedText = NSAttributedString().detailAttributedText("Retail Price", "\(nilValue)")
        }
        
        let verticalAnchor: CGFloat = 22
        let horizontalAnchor: CGFloat = 12
        
        for (index, label) in labels.enumerated() {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            detailView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: detailView.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: detailView.trailingAnchor),
                label.topAnchor.constraint(equalTo: index == 0 ? detailView.topAnchor : labels[index - 1].bottomAnchor, constant: index == 0 ? 12 : verticalAnchor),
                label.bottomAnchor.constraint(equalTo: index == labels.count - 1 ? detailView.bottomAnchor : label.bottomAnchor, constant: index == labels.count - 1 ? -12 : 0)
            ])
        }
    }
    
    func configureLink() {
        let buttons = [previewLinkLabel, infoLinkLabel, webReaderLinkLabel]
        
        previewLinkLabel.setTitle("Preview link", for: .normal)
        infoLinkLabel.setTitle("Info link", for: .normal)
        webReaderLinkLabel.setTitle("Web reader link", for: .normal)
        
        previewLinkLabel.addAction(UIAction { [weak self] _ in
            self?.openURL(self?.book.volumeInfo.previewLink)
        }, for: .touchUpInside)
        
        infoLinkLabel.addAction(UIAction { [weak self] _ in
            self?.openURL(self?.book.volumeInfo.infoLink)
        }, for: .touchUpInside)
        
        webReaderLinkLabel.addAction(UIAction { [weak self] _ in
            self?.openURL(self?.book.accessInfo.webReaderLink)
        }, for: .touchUpInside)
        
        let verticalAnchor: CGFloat = 22
        let horizontalAnchor: CGFloat = 12
        
        for (index, button) in buttons.enumerated() {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.contentHorizontalAlignment = .left
            button.setTitleColor(.systemBlue, for: .normal)
            linkView.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: linkView.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: linkView.trailingAnchor),
                button.topAnchor.constraint(equalTo: index == 0 ? linkView.topAnchor : buttons[index - 1].bottomAnchor, constant: index == 0 ? 12 : verticalAnchor),
                button.bottomAnchor.constraint(equalTo: index == buttons.count - 1 ? linkView.bottomAnchor : button.bottomAnchor, constant: index == buttons.count - 1 ? -12 : 0)
            ])
        }
    }
}

extension BookDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
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
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
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
}
