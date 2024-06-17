//
//  Represantable.swift
//  Accessible News
//
//  Created by Luka Gujejiani on 17.06.24.
//

import SwiftUI

struct NewsTableView: UIViewRepresentable {
    // MARK: - Properties
    @Binding var articles: [Article]
    var onArticleSelected: (Article) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator($articles, onArticleSelected: onArticleSelected)
    }
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.delegate = context.coordinator
        tableView.dataSource = context.coordinator
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsTableViewCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        DispatchQueue.main.async {
            uiView.reloadData()
        }
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, UITableViewDelegate, UITableViewDataSource {
        @Binding var articles: [Article]
        var onArticleSelected: (Article) -> Void
        
        init(_ articles: Binding<[Article]>, onArticleSelected: @escaping (Article) -> Void) {
            self._articles = articles
            self.onArticleSelected = onArticleSelected
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            articles.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell else {
                return UITableViewCell()
            }
            
            let article = articles[indexPath.row]
            cell.configure(with: article)
            
            cell.accessibilityLabel = article.title
            cell.accessibilityHint = "Double tap to read more"
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let article = articles[indexPath.row]
            onArticleSelected(article)
        }
    }
}
