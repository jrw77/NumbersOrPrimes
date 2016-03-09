//
//  PrimeDetailViewController.swift
//  NavigationPrimes
//
//  Created by weimar on 2/17/16.
//  Copyright © 2016 Weimar. All rights reserved.
//

import UIKit

class PrimeDetailViewController: UIViewController {

    var number : Int?
    let webPrefix = "http://m.wolframalpha.com/input/?i="
    
    @IBOutlet weak var myWebView: UIWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        if let num = number {
            self.title = "Number details: \(num)"
        }

        if let num = number {
            let webURL = NSURL(string: webPrefix+String(num)+"&x=0&y=-30")
            let urlRequest = NSURLRequest(URL: webURL!)
            print("url: \(urlRequest)")
            myWebView.loadRequest(urlRequest)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }

    
}
