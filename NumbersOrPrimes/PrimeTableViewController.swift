//
//  PrimeTableViewController.swift
//  TableViewPrimes
//
//  Created by weimar on 2/17/16.
//  Copyright © 2016 Weimar. All rights reserved.
//

import UIKit


class PrimeTableViewController: UITableViewController {
    
    var dataSource: PrimeDataSource = PrimeDataSource(max: 20)
    
    let primeImage = UIImage(named: "check_ok.png")
    let nonPrimeImage = UIImage(named: "check_cross.png")
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
    
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        tableView.estimatedRowHeight = 50
        
        // the follwing is from www.raywunderlich.com/113772/uiserachcontroller-tutorial
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        // searchController.searchDisplayController?.displaysSearchBarInNavigationBar = true
        searchController.searchBar.placeholder = NSLocalizedString("Number or #pos or x*y*z", comment: "")
        
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.searchBar.keyboardType = .NumberPad
        definesPresentationContext = true
        // tableView.tableHeaderView = searchController.searchBar
        navigationItem.titleView = searchController.searchBar
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // use just one section.
    }
    
    // return the number of rows.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return dataSource.size // can be changed by changing the data source and forcing the tableview to reload.
    }

    // creates/recycles a cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =
            self.tableView.dequeueReusableCellWithIdentifier( "PrimeTableCell", forIndexPath: indexPath)
                    as! PrimeTableViewCell
        
        var row = indexPath.row
        
        // increase table size if necessary
        if (row == dataSource.size-1){
            print (" resize to \( row*2 )" )
            // increase by doubling the max. 
            // easily scales to thousands of cells!
            dataSource = PrimeDataSource(max: row*2)
            tableView.reloadData()
        }
        if (row > dataSource.MAX){
            row = dataSource.MAX;
        }
        
        // set content of cell.
        cell.primeNumber.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.primeNumber.text = dataSource.getName(row)
        
        cell.primeImage.image = dataSource.isPrime(row) ? primeImage : nonPrimeImage
    
        cell.primeDecomp.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.primeDecomp.text = dataSource.isPrime(row)
            ? "Prime # \(dataSource.indexInPrimes(row)) of \(dataSource.primes.endIndex)"
            : String(dataSource.decompositionAsProduct(row))
        
        return cell
    }
    
    // Helper to select a certain number
    func selectNumber(number: Int){
        print(" select number \(number)")
        if (number >= 1000000){
            print(" Error: \(number) is too big!")

            let searchText = searchController.searchBar.text!
            searchController.searchBar.text = searchText.substringToIndex(searchText.endIndex.predecessor());
            
            alert(title: "Sorry", text: "\(number) is too big!")
            // MyToast(view: self.view, text: " Error: \(number) is too big!", duration: 5.0)
            return
        }
        if (number >= dataSource.size){
            dataSource = PrimeDataSource(max: number + 15)
            tableView.reloadData()
        }
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: number, inSection: 0),
            atScrollPosition: UITableViewScrollPosition.Top,
            animated: false)
        
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowPrimeDetail" {
            let detailViewController = segue.destinationViewController
                as! PrimeDetailViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            detailViewController.number = row
        }else if segue.identifier == "GoToAboutView" {
            // no special action.
        }else{
            print(" Error: seque is "+segue.description)
        }
    }
    // http://stackoverflow.com/questions/12509422/how-to-perform-unwind-segue-programmatically
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {
        //  action here when coming back.
    }
    
    func alert(title title: String, text: String){
        // create the alert
        let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertControllerStyle.Alert)
    
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

extension PrimeTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController){
        if let num = Int(searchController.searchBar.text!){
            selectNumber(num)
        }else if let text = searchController.searchBar.text {
            if text.containsString("*"){
                let numText = text.substringToIndex(text.rangeOfString("*")!.startIndex);
                print ("numText =\(numText)")
                if let num1 = Int(numText){
                    var prod = num1
                    var remText = text.substringFromIndex(text.rangeOfString("*")!.endIndex)
                    while (remText != ""){
                        if remText.containsString("*"){
                            let numText = remText.substringToIndex(remText.rangeOfString("*")!.startIndex);
                            print ("numText =\(numText)")
                            if let num2 = Int(numText){
                                prod *= num2
                            }
                            remText = remText.substringFromIndex(remText.rangeOfString("*")!.endIndex)
                        }else{ // probbaly another number?
                            if let num2 = Int(remText){
                                prod *= num2
                            }
                            remText = ""
                        }
                    }
                    selectNumber(prod)
                }
            }else if text.containsString("#"){
                let remText = text.substringFromIndex(text.rangeOfString("#")!.endIndex);
                print ("#remText =\(remText)")
                if let num = Int(remText){
                    if (num < 78500){
                        while (dataSource.prime(atPosition: num) == nil){
                            dataSource = PrimeDataSource(max: dataSource.size * 2)
                            tableView.reloadData()
                        }
                        selectNumber(dataSource.primes[num-1])
                    }else{
                       // error
                        selectNumber(1000000);
                    }
                    
                }
             }
        }
    }

}
