//
//  NewsListView.swift
//  Accessible News
//
//  Created by Luka Gujejiani on 16.06.24.
//

import SwiftUI

struct NewsListView: View {
    @StateObject var viewModel = NewsListViewModel()
    
    var body: some View {
        NavigationView {
            NewsTableView(articles: $viewModel.articles) { article in
                viewModel.selectArticle(article)
            }
            .navigationBarTitle("Top Headlines")
        }
        .onAppear {
             viewModel.onArticleSelected = { article in
                 if let topController = UIApplication.shared.topViewController() {
                     let detailViewModel = NewsDetailViewModel(article: article)
                     let detailVC = NewsDetailViewController()
                     detailVC.viewModel = detailViewModel
                     topController.present(detailVC, animated: true) {
//                         detailVC.updateTitle?(detailViewModel.title)
//                         detailVC.updateDescription?(detailViewModel.description)
//                         detailVC.updatePublishedAt?(detailViewModel.publishedAt)
//                         detailVC.updateSource?(detailViewModel.source)
//                         detailVC.updateAuthor?(detailViewModel.author)
                     }
                 }
             }
         }
     }
 }

// MARK: - UI View Representable
struct NewsTableView: UIViewRepresentable {
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
        tableView.backgroundColor = .blue
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


extension UIApplication {
    func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes
                                .filter { $0.activationState == .foregroundActive }
                                .compactMap { $0 as? UIWindowScene }
                                .first?.windows
                                .filter { $0.isKeyWindow }
                                .first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
