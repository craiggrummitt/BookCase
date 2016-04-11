//
//  ViewController.swift
//  BookCase
//
//  Created by Craig Grummitt on 10/04/2016.
//  Copyright © 2016 Craig Grummitt. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var books:[Book] = []
    
    override func viewDidLoad() {
        if let savedBooks = loadBooks() {
            books = savedBooks
        } else {
            books = loadSampleBooks()
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return books.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("book", forIndexPath: indexPath)
        
        cell.textLabel?.text = books[indexPath.row].title
        cell.detailTextLabel?.text = books[indexPath.row].author
        
        return cell
    }
    
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            books.removeAtIndex(indexPath.row)
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
                destinationViewController.book = books[selectedRow.row]
            }
        }
    }
    
    @IBAction func createBook(sender: AnyObject) {
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

