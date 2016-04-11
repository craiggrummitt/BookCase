//
//  BookDetailTableViewController.swift
//  HouseHunter
//
//  Created by Craig Grummitt on 29/02/2016.
//  Copyright © 2016 Craig Grummitt. All rights reserved.
//

import UIKit


class BookDetailTableViewController: UITableViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    var book:Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let book = book {
            titleTextField.text = book.title
            authorTextField.text = book.author
            notesTextField.text = book.notes
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func bookChanged(sender: AnyObject) {
        if let book = book {
            if let title = titleTextField.text {
                book.title = title
            }
            if let author = authorTextField.text {
                book.author = author
            }
            if let notes = notesTextField.text {
                book.notes = notes
            }
        }
    }
}
