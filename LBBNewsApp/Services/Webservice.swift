//
//  NewsHeadlinesTableViewCell.swift
//  LBBNewsApp
//
//  Created by Macbook on 05/08/21.
//

import Foundation

class Webservice {
    
    func getArticles(with url: URL, completion: @escaping ([Article]?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                
                let articlesList = try? JSONDecoder().decode(ArticleList.self, from: data)
                completion(articlesList?.articles)
            }
            
        }.resume()
        
    }
    
}
