//
//  NewsListViewModel.swift
//  Accessible News
//
//  Created by Luka Gujejiani on 16.06.24.
//

import Foundation
import SimpleNetworking

class NewsListViewModel: ObservableObject {
    @Published var articles: [Article] = []
    
    var onArticleSelected: ((Article) -> Void)?
    
    init() {
        fetchNews()
    }
    
    func fetchNews() {
        let url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=04bda797a49346e4aca004ee3402281b"
        
        WebService().fetchData(from: url, resultType: Custom.self) { result in
            switch result {
            case .success(let newsData):
                DispatchQueue.main.async {
                    self.articles = newsData.articles
                    print(newsData)
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
