//
//  NewsDetailViewModel.swift
//  Accessible News
//
//  Created by Luka Gujejiani on 17.06.24.
//

import Foundation

class NewsDetailViewModel {
    var article: Article
    
    init(article: Article) {
        self.article = article
    }
    
    var title: String {
        return article.title
    }
    
    var description: String {
        return article.description ?? "No decription available"
    }
    
    var publishedAt: String {
        return "Published at: \(article.publishedAt)"
    }
    
    var source: String {
        return "Source: \(article.source.name)"
    }
    
    var author: String {
        return "Author: \(article.author ?? "Unknown author")"
    }
}
