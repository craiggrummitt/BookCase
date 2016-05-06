//
//  CoverCollectionViewController.swift
//  BookCase
//
//  Created by Craig Grummitt on 15/04/2016.
//  Copyright © 2016 Craig Grummitt. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cover"

class CoverCollectionViewController: UICollectionViewController {
    let searchController = UISearchController(searchResultsController: nil)
    
    var books:[Book] = []
    var sortedBooks:[Book] = []
    var awaitingSave = false
    
    var defaultCover = UIImage(named: "book.jpg")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    func sortContent() {
        sortedBooks = books.sort {
            return $0.author < $1.author
        }
    }
    func getBookAt(index:Int)->Book {
        return(sortedBooks[index])
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
        collectionView!.reloadData()
    }
    //MARK:Data
    func loadSampleBooks()->[Book] {
        return [
            Book(title: "Great Expectations", author: "Charles Dickens",notes: "",cover:defaultCover)
        ]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return books.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = getBookAt(indexPath.row).cover
        cell.contentView.addSubview(imageView)
        
        return cell
    }
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let selectedRow = collectionView?.indexPathsForSelectedItems()?[0] {
            if let destinationViewController = segue.destinationViewController as? BookDetailTableViewController {
                awaitingSave = true
                destinationViewController.book = getBookAt(selectedRow.row)//books[selectedRow.row]
            }
        }
    }
    // MARK: NSCoding
    func saveBooks() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(books, toFile: Book.BooksDirectory.path!)
        print(isSuccessfulSave ? "Successful save" : "Save Failed")
    }
    
    func loadBooks() -> [Book]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Book.BooksDirectory.path!) as? [Book]
    }
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
}