//
//  NewsModel.swift
//  Accessible News
//
//  Created by Luka Gujejiani on 16.06.24.
//

import Foundation

// MARK: - Custom
struct Custom: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Decodable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

// MARK: - Source
struct Source: Decodable {
    let id: String?
    let name: String
}

