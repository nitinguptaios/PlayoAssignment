//
//  HomeVC.swift
//  PlayoAssignmentiOS
//
//  Created by iPHTech38 on 01/08/22.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var searchFieldView: UITextField!
    @IBOutlet weak var newsTableView: UITableView!
    
    var DemoData = [DataModel]()
    var tempDemoData = [DataModel]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeVC.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(red: 0.29, green: 0.63, blue: 0.73, alpha: 1.00)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        designView()
        
        makeRequest(completion: {[weak self] response in
            switch response{
            case .success(let data):
                self?.showLoader()
                let apiKey = "bc9e425cbc28497d8e582a155b465a66"
                self?.apiCallNew(url: "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=\(apiKey)")
                DispatchQueue.main.async {
                    self?.newsTableView.reloadData()
                }
            case .failure(let error):
                break
            }
        })
    }
    
    // Design View for Placeholder font change
    func designView() {
        self.newsTableView.addSubview(refreshControl)
        
        self.navigationController?.isNavigationBarHidden = true

        searchFieldView.addTarget(self, action: #selector(HomeVC.textFieldDidChange(_:)), for: .editingChanged)

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 5))
        searchFieldView.leftViewMode = .always
        searchFieldView.leftView = paddingView
        let grayPlaceholder = NSAttributedString(string: "Search news ... ",
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
                
        searchFieldView.attributedPlaceholder = grayPlaceholder
    }
    
}

extension HomeVC {
    
    //MARK: Closures function for API handling
    func makeRequest(completion: @escaping (Result<[DataModel], Error>) -> Void){
        completion(.success(self.DemoData))
    }
    
    //MARK: API Function Call
    func apiCallNew(url: String) {
        // Prepare URL
        let url = URL(string: url)
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    
                    if let dictData = jsonResponse as? NSDictionary, let articleData = dictData.value(forKey: "articles") as? NSArray {
                        print(articleData)
                        self.DemoData.removeAll()
                        self.tempDemoData.removeAll()
                        for data in articleData {
                            if let article = data as? NSDictionary {
                                if let title = article.value(forKey: "title") as? String, let desc = article.value(forKey: "description") as? String, let image = article.value(forKey: "urlToImage") as? String, let author = article.value(forKey: "author") as? String, let url = article.value(forKey: "url") as? String {
                                    
                                    // Insert value to Data Model
                                    self.DemoData.append(DataModel.init(title: title, desc: desc, author: author, imageUrl: image, url: url))
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.newsTableView.reloadData()
                        }
                    }
                    self.hideLoader()
                    self.tempDemoData = self.DemoData
                }
                catch let error
                {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    // Refershing on pulling list
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        let apiKey = "bc9e425cbc28497d8e582a155b465a66"
        self.apiCallNew(url: "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=\(apiKey)")
        self.newsTableView.reloadData()
        refreshControl.endRefreshing()
    }
}

//MARK: DECLRAING DATASOURCE & DELEGATES OF TABLEVIEW
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DemoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        cell.authorLabel.text = self.DemoData[indexPath.row].author
        cell.descriptionLabel.text = self.DemoData[indexPath.row].desc
        cell.titleLabel.text = self.DemoData[indexPath.row].title
        cell.newsImage.downloaded(from: self.DemoData[indexPath.row].imageUrl!)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = self.storyboard!.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        webVC.newsString = self.DemoData[indexPath.row].title!
        webVC.webUrl = self.DemoData[indexPath.row].url!
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    // MARK: Height of Table View Cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

//MARK: Search Bar didChange
extension HomeVC {
    @objc func textFieldDidChange(_ textField: UITextField) {
        debugPrint("Serched Text is ",textField.text)
        if let searchText = textField.text, !searchText.isEmpty {
            DemoData = tempDemoData.filter ( { data in return data.author!.lowercased().contains(searchText.lowercased()) ||
                data.title!.lowercased().contains(searchText.lowercased()) ||
                data.desc!.lowercased().contains(searchText.lowercased())
            })
            
        } else {
            DemoData = tempDemoData
        }
        
        self.newsTableView.reloadData()
    }
}
