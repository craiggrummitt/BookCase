//
//  AuthorTableViewController.swift
//  BookCase
//
//  Created by Craig Grummitt on 11/04/2016.
//  Copyright © 2016 Craig Grummitt. All rights reserved.
//

import UIKit

class AuthorTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var books:[Book] = []
    var filteredBooks:[Book] = []
    
    override func viewDidLoad() {
        if let savedBooks = loadBooks() {
            books = savedBooks
        } else {
            books = loadSampleBooks()
        }
        books.sortInPlace {
            return $0.author < $1.author
        }
        //MARK: Search
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        //searchController.searchBar.delegate = self  //http://useyourloaf.com/blog/updating-to-the-ios-8-search-controller/
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    func filterContentForSearchText() {
        if let searchText = searchController.searchBar.text {
            filteredBooks = books.filter { book in
                return book.author.lowercaseString.containsString(searchText.lowercaseString)
            }
        }
        tableView.reloadData()
    }
    func getBookAt(index:Int)->Book {
        if searchController.active && searchController.searchBar.text != "" {
            return(filteredBooks[index])
        } else {
            return(books[index])
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
        saveBooks()
    }
    //MARK:Data
    func loadSampleBooks()->[Book] {
        return [
            Book(title: "Great Expectations", author: "Charles Dickens",notes: "")
        ]
    }
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredBooks.count
        }
        return books.count
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("author", forIndexPath: indexPath)
        
        cell.textLabel?.text = getBookAt(indexPath.row).author
        cell.detailTextLabel?.text = getBookAt(indexPath.row).title
        //cell.textLabel?.text = books[indexPath.row].title
        //cell.detailTextLabel?.text = books[indexPath.row].author
        
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //Get books index
            var index:Int = indexPath.row
            if searchController.active && searchController.searchBar.text != "" {
                let deletedBook = filteredBooks[indexPath.row]
                if let deletedBookIndex = books.indexOf(deletedBook) {
                    index = deletedBookIndex
                }
                filteredBooks.removeAtIndex(indexPath.row)
                
            }
            //
            books.removeAtIndex(index)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            saveBooks()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
        }
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let selectedRow = tableView.indexPathForSelectedRow {
            if let destinationViewController = segue.destinationViewController as? BookDetailTableViewController {
                destinationViewController.book = getBookAt(selectedRow.row)//books[selectedRow.row]
            }
        }
    }
    
    @IBAction func createBook(sender: AnyObject) {
        searchController.searchBar.text = ""
        let book = Book(title: "New book", author: "", notes: "")
        self.books.append(book)
        let newIndexPath = NSIndexPath(forRow: self.books.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
        
        self.tableView.selectRowAtIndexPath(newIndexPath, animated: true, scrollPosition: .None)
        self.performSegueWithIdentifier("editSegue", sender: self)
    }
    // MARK: NSCoding
    func saveBooks() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(books, toFile: Book.BooksDirectory.path!)
        print(isSuccessfulSave ? "Successful save" : "Save Failed")
    }
    
    func loadBooks() -> [Book]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Book.BooksDirectory.path!) as? [Book]
    }
}
extension AuthorTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText()
    }
}