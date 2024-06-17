//
//  NewsDetailViewController.swift
//  Accessible News
//
//  Created by Luka Gujejiani on 17.06.24.
//

import UIKit

final class NewsDetailViewController: UIViewController {
    // MARK: - Properties
    var viewModel: NewsDetailViewModel?
    
    // MARK: - Views
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = true
        return label
    }()
    
    let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        imageView.isAccessibilityElement = true
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = true
        return label
    }()
    
    let publishedAtLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = true
        label.textColor = .gray
        return label
    }()
    
    let sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = true
        label.textColor = .gray
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.isAccessibilityElement = true
        label.textColor = .label
        return label
    }()
    
    let openLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Read Full Article", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    private var imageViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(newsImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(publishedAtLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(openLinkButton)
        
        imageViewHeightConstraint = newsImageView.heightAnchor.constraint(equalToConstant: 200)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            newsImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageViewHeightConstraint,
            
            descriptionLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            publishedAtLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            publishedAtLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            publishedAtLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            sourceLabel.topAnchor.constraint(equalTo: publishedAtLabel.bottomAnchor, constant: 16),
            sourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sourceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            authorLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            openLinkButton.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 40),
            openLinkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            openLinkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            openLinkButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            openLinkButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        adjustImageViewSize()
    }
    
    // MARK: - Functions (Adjusting size based on accessibility and binding viewModel)
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
            newSize = 60
        }

        imageViewHeightConstraint.constant = newSize
    }

    private func bindViewModel() {
        viewModel?.updateTitle = { [weak self] text in
            self?.titleLabel.text = text
            self?.titleLabel.accessibilityLabel = text
        }
        
        viewModel?.updateDescription = { [weak self] text in
            self?.descriptionLabel.text = text
            self?.descriptionLabel.accessibilityLabel = text
        }
        
        viewModel?.updatePublishedAt = { [weak self] text in
            self?.publishedAtLabel.text = text
            self?.publishedAtLabel.accessibilityLabel = text
        }
        
        viewModel?.updateSource = { [weak self] text in
            self?.sourceLabel.text = text
            self?.sourceLabel.accessibilityLabel = text
        }
        
        viewModel?.updateAuthor = { [weak self] text in
            self?.authorLabel.text = text
            self?.authorLabel.accessibilityLabel = text
        }
        
        viewModel?.updateImageData = { [weak self] data in
            self?.newsImageView.image = UIImage(data: data)
            self?.newsImageView.accessibilityLabel = "News Image"
        }
        
        openLinkButton.addAction(UIAction(handler: { [weak self] _ in
            self?.openLinkButtonTapped()
        }), for: .touchUpInside)
        
        viewModel?.updateUI()
    }
    
    private func openLinkButtonTapped() {
        guard let urlString = viewModel?.article.url, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
