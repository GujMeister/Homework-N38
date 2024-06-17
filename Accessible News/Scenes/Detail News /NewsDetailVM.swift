//
//  NewsDetailViewModel.swift
//  Accessible News
//
//  Created by Luka Gujejiani on 17.06.24.
//

import Foundation

final class NewsDetailViewModel {
    // MARK: - Properties
    var article: Article
    
    var updateTitle: ((String) -> Void)?
    var updateDescription: ((String) -> Void)?
    var updatePublishedAt: ((String) -> Void)?
    var updateSource: ((String) -> Void)?
    var updateAuthor: ((String) -> Void)?
    var updateImageData: ((Data) -> Void)?
    var updateButtonInfo: ((String) -> Void)?
    
    // MARK: - Lifecycle
    init(article: Article) {
        self.article = article
    }
    
    // MARK: - Functions
    func updateUI() {
        let formattedDate = convertDateString(article.publishedAt)
        
        updateTitle?(article.title)
        updateDescription?(article.content ?? "No description available")
        updatePublishedAt?("Published at: \(formattedDate)")
        updateSource?("Source: \(article.source.name)")
        updateAuthor?("Author: \(article.author ?? "Unknown author")")
        updateButtonInfo?(article.url)
        
        if let urlString = article.urlToImage, let url = URL(string: urlString) {
            fetchImageData(from: url)
        } else {
            if let defaultImageURL = URL(string: "https://t4.ftcdn.net/jpg/04/70/29/97/360_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg") {
                fetchImageData(from: defaultImageURL)
            }
        }
    }
    
    private func fetchImageData(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self.updateImageData?(data)
                }
            }
        }
        task.resume()
    }
    
    private func convertDateString(_ dateString: String) -> String {
        // Ensure the dateString is at least 10 characters long to avoid crashes
        guard dateString.count >= 10 else {
            return dateString
        }
        return String(dateString.prefix(10))
    }
}
