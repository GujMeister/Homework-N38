//
//  NewsTableViewCell.swift
//  Accessible News
//
//  Created by Luka Gujejiani on 16.06.24.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {
    // MARK: - Properties
    private var imageViewWidthConstraint: NSLayoutConstraint!
    private var imageViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Views
    let backgroundContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 10.0
        view.layer.masksToBounds = true
        return view
    }()
    
    let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5.0
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(newsImageView)
        backgroundContainerView.addSubview(titleLabel)
        
        imageViewWidthConstraint = newsImageView.widthAnchor.constraint(equalToConstant: 160)
        imageViewHeightConstraint = newsImageView.heightAnchor.constraint(equalToConstant: 160)
        
        NSLayoutConstraint.activate([
            backgroundContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            backgroundContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            newsImageView.topAnchor.constraint(equalTo: backgroundContainerView.topAnchor, constant: 10),
            newsImageView.centerXAnchor.constraint(equalTo: backgroundContainerView.centerXAnchor),
            imageViewWidthConstraint,
            imageViewHeightConstraint,
            
            titleLabel.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: backgroundContainerView.bottomAnchor, constant: -10)
        ])
        
        isAccessibilityElement = true
        accessibilityTraits = .button
        
        adjustImageViewSize()
        
        NotificationCenter.default.addObserver(self, selector: #selector(contentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper functions
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
        case .extraLarge, .extraExtraLarge, .extraExtraExtraLarge, .accessibilityMedium:
            newSize = screenSize.width * 0.6
        case .accessibilityLarge, .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            newSize = screenSize.width * 0.9
        default:
            newSize = screenSize.width * 0.4
        }

        imageViewWidthConstraint.constant = newSize
        imageViewHeightConstraint.constant = newSize
    }
    
    func configure(with article: Article) {
        titleLabel.text = article.title
        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            fetchImage(from: url) { [weak self] data in
                if let data = data {
                    self?.newsImageView.image = UIImage(data: data)
                } else {
                    self?.newsImageView.image = nil
                }
            }
        } else {
            self.newsImageView.image = nil
        }
        
        accessibilityLabel = article.title
        accessibilityHint = "Double tap to read more"
    }
    
    private func fetchImage(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    completion(data)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
}
