//
//  ArticleDetailsVIewController.swift
//  LBBNewsApp
//
//  Created by Macbook on 05/08/21.
//

import UIKit
import WebKit

class ArticleDetailsVIewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var ArticleDetailsWebView: WKWebView!
    @IBOutlet weak var lblPublishedat: UILabel!
    var urlString :String = ""
    var publishedBy :String = ""
    var publishedAt :String = ""
    var imgToUrl :String = ""
    
    
    @IBOutlet weak var imgBanner: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News Detail"
        self.lblAuthor.text = "Author :- " +  self.publishedBy
        self.lblPublishedat.text = "Published At  :- " +  self.publishedAt
        //To download images to show preview
        if imgToUrl == "" {
            self.imgBanner.image = UIImage(named: imgToUrl)
        }else if let url = URL(string: imgToUrl ?? "empty") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.imgBanner.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        self.ArticleDetailsWebView.uiDelegate = self
        let myURL = URL(string:urlString)
        let myRequest = URLRequest(url: myURL!)
        self.ArticleDetailsWebView.load(myRequest)
    }
}
