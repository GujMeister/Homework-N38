//
//  NewsListViewModel.swift
//  Accessible News
//
//  Created by Luka Gujejiani on 16.06.24.
//

import Foundation
import SimpleNetworking

final class NewsListViewModel: ObservableObject {
    // MARK: - Properties
    @Published var articles: [Article] = []
    var onArticleSelected: ((Article) -> Void)?
    
    // MARK: - Lifecycle
    init() {
        fetchNews()
    }
    
    // MARK: - Functions
    func fetchNews() {
        let url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=04bda797a49346e4aca004ee3402281b"
        
        WebService().fetchData(from: url, resultType: Custom.self) { result in
            switch result {
            case .success(let newsData):
                DispatchQueue.main.async {
                    self.articles = newsData.articles.filter { $0.urlToImage != nil }
                }
            case .failure(let error):
                print("Error fetching news: \(error)")
            }
        }
    }
    
    func selectArticle(_ article: Article) {
        onArticleSelected?(article)
    }
}
