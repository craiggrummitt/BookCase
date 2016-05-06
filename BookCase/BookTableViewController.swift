//
//  ViewController.swift
//  BookCase
//
//  Created by Craig Grummitt on 10/04/2016.
//  Copyright © 2016 Craig Grummitt. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var books:[Book] = []
    var sortedBooks:[Book] = []
    var filteredBooks:[Book] = []
    var awaitingSave = false
    var defaultCover = UIImage(named: "book.jpg")!
    
    override func viewDidLoad() {

        //MARK: Search
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    func sortContent() {
        sortedBooks = books.sort {
            return $0.title.lowercaseString < $1.title.lowercaseString
        }
    }
    func filterContentForSearchText() {
        if let searchText = searchController.searchBar.text {
            filteredBooks = sortedBooks.filter { book in
                return book.title.lowercaseString.containsString(searchText.lowercaseString)
            }
        }
        tableView.reloadData()
    }
    func getBookAt(index:Int)->Book {
        if searchController.active && searchController.searchBar.text != "" {
            return(filteredBooks[index])
        } else {
            return(sortedBooks[index])
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if awaitingSave {
            awaitingSave = false
            saveBooks()
        } else {
            if let savedBooks = loadBooks() {
                books = savedBooks
            } else {
                books = loadSampleBooks()
            }
        }
        sortContent()
        tableView.reloadData()
    }
    //MARK:Data
    func loadSampleBooks()->[Book] {
        return [
            Book(title: "Great Expectations", author: "Charles Dickens",notes: "", cover: defaultCover)
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier("book", forIndexPath: indexPath)
        
        cell.textLabel?.text = getBookAt(indexPath.row).title
        cell.detailTextLabel?.text = getBookAt(indexPath.row).author
        cell.imageView?.image = getBookAt(indexPath.row).cover
        //cell.textLabel?.text = books[indexPath.row].title
        //cell.detailTextLabel?.text = books[indexPath.row].author
        
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let bookToDelete = getBookAt(indexPath.row)
            if let bookToDeleteIndex = books.indexOf(bookToDelete) {
                books.removeAtIndex(bookToDeleteIndex)
            }
            if searchController.active && searchController.searchBar.text != "" {
                filteredBooks.removeAtIndex(indexPath.row)
            } else {
                sortedBooks.removeAtIndex(indexPath.row)
            }
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
                awaitingSave = true
                destinationViewController.book = getBookAt(selectedRow.row)//books[selectedRow.row]
            }
        }
    }
    
    @IBAction func createBook(sender: AnyObject) {
        searchController.searchBar.text = ""
        let book = Book(title: "New book", author: "", notes: "", cover: defaultCover)
        self.books.append(book)
        self.sortedBooks.append(book)
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
extension BookTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText()
    }
}
