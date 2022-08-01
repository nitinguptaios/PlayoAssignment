//
//  WebViewVC.swift
//  PlayoAssignmentiOS
//
//  Created by iPHTech38 on 01/08/22.
//

import UIKit
import WebKit

class WebViewVC: UIViewController {
    
    @IBOutlet weak var webviewInstance: WKWebView!
    @IBOutlet weak var newsTitle: UILabel!
    
    var webUrl = ""
    var newsString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        newsTitle.text = newsString
        
        // MARK: Requesting Web View from Given url
        webviewInstance.load(NSURLRequest(url: NSURL(string: webUrl)! as URL) as URLRequest)
    }

    //MARK: Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
