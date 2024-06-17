//
//  NewsListView.swift
//  Accessible News
//
//  Created by Luka Gujejiani on 16.06.24.
//

import SwiftUI

struct NewsListView: View {
    // MARK: - Proeprties
    @StateObject var viewModel = NewsListViewModel()
    
    // MARK: - View
    var body: some View {
        NavigationView {
            NewsTableView(articles: $viewModel.articles) { article in
                viewModel.selectArticle(article)
            }
            .navigationBarTitle("Headlines")
        }
        .onAppear {
             viewModel.onArticleSelected = { article in
                 if let topController = UIApplication.shared.topViewController() {
                     let detailViewModel = NewsDetailViewModel(article: article)
                     let detailVC = NewsDetailViewController()
                     detailVC.viewModel = detailViewModel
                     topController.present(detailVC, animated: true)
                 }
             }
         }
     }
 }
