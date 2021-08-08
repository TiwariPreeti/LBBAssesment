//
//  NewsHeadlinesTableViewCell.swift
//  LBBNewsApp
//
//  Created by Macbook on 05/08/21.
//

import UIKit


class NewsHeadlinesTableViewController: UITableViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    private var articleListVM: ArticleListViewModel!
    
    var articlesList = [newsArticleList]()
    var selected = false

    override func viewDidLoad() {
        super.viewDidLoad()

        SQLiteConnection.sharedInstance.createArticlesTable()

         self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.title = "News Headline"
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
      //  self.setup()
        callAPI() {
            _ in
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        }

    }
    
     func viewWillAppear() {
        selected = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articlesList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        var cell = UITableViewCell()
        let isIndexValid = articlesList.indices.contains(indexPath.row)
        
        if isIndexValid {
            let article = articlesList[indexPath.row]
            
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "NewsHeadlinesTableViewCellID", for: indexPath) as! NewsHeadlinesTableViewCell
            
            //To download images to show preview
            if article.urlToImage == "" {
                cell1.newsImage.image = UIImage(named: "NewsImage")
            }else if let url = URL(string: article.urlToImage ?? "empty") {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell1.newsImage.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
            
            cell1.newsDescription.text = article.title
            
            if (article.author) != nil {
                cell1.newsAuthor.text = "-" + String(describing: article.author!)
            }else{
                cell1.newsAuthor.text = ""
            }
            cell = cell1
        }
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil{
            let article = articlesList[indexPath.row]
            //ArticleDetailsVIewControllerID
                            
            DispatchQueue.main.async {
                let articleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleDetailsVIewControllerID") as! ArticleDetailsVIewController
                
                articleVC.urlString = article.url ?? ""
                articleVC.publishedBy = article.author ?? ""
                articleVC.publishedAt = article.publishedAt ?? ""
                articleVC.imgToUrl = article.urlToImage ?? ""
                self.navigationController?.pushViewController(articleVC, animated: true)
            }
        }
//        if !selected {
//            selected = true
//            if tableView.cellForRow(at: indexPath) != nil{
//                let article = articlesList[indexPath.row]
//                //ArticleDetailsVIewControllerID
//
//                DispatchQueue.main.async {
//                    let articleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleDetailsVIewControllerID") as! ArticleDetailsVIewController
//
//                    articleVC.urlString = article.url ?? ""
//                    articleVC.publishedBy = article.author ?? ""
//                    articleVC.urlString = article.publishedAt ?? ""
//                    articleVC.urlString = article.urlToImage ?? ""
//                    self.navigationController?.pushViewController(articleVC, animated: true)
//                }
//            }
//        }
    }
    //call api
    private func setup() {
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let initRequest = ServiceRequestResponse.sharedInstance
        let sql = SQLiteConnection.sharedInstance

        if initRequest.isConnectedToNetwork() == true {
        Webservice().getArticles(with: URL.urlForTopHeadlines()) { articles in
            
            if let articles = articles {
                
                self.articleListVM = ArticleListViewModel(articles: articles)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
        }else {
            //Fetch records from local
            self.articlesList = sql.selectAllArticles()
        }
        
    }
    func callAPI(completion: @escaping (Bool) -> ()){
        
        let initRequest = ServiceRequestResponse.sharedInstance
        let sql = SQLiteConnection.sharedInstance

        if initRequest.isConnectedToNetwork() == true {
            initRequest.requestService(NewsAPI, data:[String : AnyObject]()) { response in
                print(response)
                _ = sql.deleteAll()
                if (response["status"] as! String) == "ok"  {
                    
                    
                    var articlesListCopy = [newsArticleList]()

                    if response["articles"] is NSArray{
                        let articles = response["articles"] as! NSArray
                        print(articles)
                        for obj in articles {
                            let file = obj as! NSDictionary
                            
                            articlesListCopy.append(newsArticleList(author: file["author"] as? String, content: file["content"] as? String, description: file["description"] as? String, publishedAt: file["publishedAt"] as? String, title: file["title"] as? String, url: file["url"] as? String, urlToImage: file["urlToImage"] as? String))
                            _ = sql.SaveArticles(Author: file["author"] as? String ?? " ", Content: file["content"] as? String ?? " ", Description: file["description"] as? String ?? " ", PublishedAt: file["publishedAt"] as? String ?? " ", Title: file["title"] as? String ?? " ", Url: file["url"] as? String ?? " ", UrlToImage: file["urlToImage"] as? String ?? " ")
                        }
                        self.articlesList = articlesListCopy
                        completion(true)
                    }
                }
                

            }
        }else{
            //Fetch records from local
            self.articlesList = sql.selectAllArticles()
        }
    }
    
}
