//
//  NewsModel.swift
//  Accessible News
//
//  Created by Luka Gujejiani on 16.06.24.
//

import Foundation

struct Custom: Decodable {
    let articles: [Article]
}

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

struct Source: Decodable {
    let name: String
}
