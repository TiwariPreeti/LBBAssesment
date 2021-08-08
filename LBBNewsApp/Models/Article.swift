//
//  NewsHeadlinesTableViewCell.swift
//  LBBNewsApp
//
//  Created by Macbook on 05/08/21.
//

import Foundation

struct ArticleList: Decodable {
    let articles: [Article]
}

struct Article: Decodable {
    let title: String
    let description: String
    let urlToImage : String
}


