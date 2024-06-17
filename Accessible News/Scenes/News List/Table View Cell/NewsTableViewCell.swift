//
//  NewsTableViewCell.swift
//  Accessible News
//
//  Created by Luka Gujejiani on 16.06.24.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body) // Use a Dynamic Type font style
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        
        let imageViewConstraints = [
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            newsImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints + titleLabelConstraints)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentSizeCategoryDidChange),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func contentSizeCategoryDidChange() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        adjustImageViewSize()
    }
    
    private func adjustImageViewSize() {
        let contentSize = UIApplication.shared.preferredContentSizeCategory
        let screenSize = UIScreen.main.bounds.size
        let newSize: CGFloat
        
        switch contentSize {
        case .extraSmall, .small, .medium, .large:
            newSize = screenSize.width * 0.4
            print("small-medium-Large size")
        case .extraLarge, .extraExtraLarge, .extraExtraExtraLarge, .accessibilityMedium:
            newSize = screenSize.width * 0.6
            print("Extra large size")
        case .accessibilityLarge, .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            newSize = screenSize.width * 0.9
            print("Super-Duper Extra large size")
        default:
            newSize = 60
        }

        newsImageView.widthAnchor.constraint(equalToConstant: newSize).isActive = true
        newsImageView.heightAnchor.constraint(equalToConstant: newSize).isActive = true
    }
    
    func configure(with article: Article) {
        titleLabel.text = article.title
        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.newsImageView.image = UIImage(data: data)
                    }
                }
            }
        } else {
            self.newsImageView.image = nil
        }
        adjustImageViewSize()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
}
