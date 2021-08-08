//
//  NewsHeadlinesTableViewCell.swift
//  LBBNewsApp
//
//  Created by Macbook on 05/08/21.
//

import UIKit

class NewsHeadlinesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsDescription: UITextView!
    @IBOutlet weak var newsAuthor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//    func configure(for vm: ArticleViewModel) {
//        self.newsAuthor.text = vm.title
//        self.newsDescription.text = vm.description
//        if vm.urlToImage == "" {
//            self.newsImage.image = UIImage(named: vm.urlToImage)
//        }else if let url = URL(string: vm.urlToImage ?? "empty") {
//            URLSession.shared.dataTask(with: url) { (data, response, error) in
//                if let data = data {
//                    DispatchQueue.main.async {
//                        self.newsImage.image = UIImage(data: data)
//                    }
//                }
//            }.resume()
//        }
//    }

}
