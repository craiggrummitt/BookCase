//
//  BookDetailTableViewController.swift
//  HouseHunter
//
//  Created by Craig Grummitt on 29/02/2016.
//  Copyright © 2016 Craig Grummitt. All rights reserved.
//

import UIKit
import SwiftyJSON

class BookDetailTableViewController: UITableViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var barcodeButton: UIButton!
    var book:Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let book = book {
            titleTextField.text = book.title
            authorTextField.text = book.author
            notesTextField.text = book.notes
            imageView.image = book.cover
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func takePhoto(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func getBarcode(sender: AnyObject) {
        let scannerViewController = ScannerViewController()
        scannerViewController.modalPresentationStyle = .Popover
        scannerViewController.popoverPresentationController?.sourceView = barcodeButton
        scannerViewController.popoverPresentationController?.sourceRect = barcodeButton.bounds
        scannerViewController.delegate = self
        self.presentViewController(scannerViewController, animated: true, completion: nil)
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


extension BookDetailTableViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            if let book = book {
                book.cover = image
            }
        }
    }
}

extension BookDetailTableViewController:ScannerViewControllerDelegate {
    
    //https://www.googleapis.com/books/v1/volumes?q=9780194792325
    func foundBarcode(barcode:String) {
        guard let url = NSURL(string: "https://www.googleapis.com/books/v1/volumes?q=\(barcode)") else {return}
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithURL(url) { (data, response, error) in
            guard let data = data else { return }
            // USING NSJSONSerialization
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: AnyObject]
                if let items = json["items"] as? [AnyObject] {
                    if let volume = items[0] as? [String:AnyObject] {
                        if let volumeInfo = volume["volumeInfo"] as? [String:AnyObject] {
                            if let title = volumeInfo["title"] as? String,
                                authors = volumeInfo["authors"] as? [String],
                                imageLinks = volumeInfo["imageLinks"] as? [String:String],
                                thumbnail = imageLinks["thumbnail"] {
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.titleTextField.text = title
                                    self.authorTextField.text = authors.joinWithSeparator(",")
                                    self.loadCover(thumbnail)
                                    if let book = self.book {
                                        book.title = title
                                        book.author = authors.joinWithSeparator(",")
                                    }
                                })
                            }
                        }
                    }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
            /* ALTERNATIVELY, USING SWIFTYJSON
             
             //------Swifty JSON Style JSON
            let json = JSON(data: data)
            if let volumeInfo = json["items"][0]["volumeInfo"].dictionary {
                if let title = volumeInfo["title"]?.string,
                    let authors = volumeInfo["authors"]?.array,
                    let firstAuthor = authors[0].string,
                    let imageLinks = volumeInfo["imageLinks"]?.dictionary,
                    let thumbnail = imageLinks["thumbnail"]?.string,
                    let book = self.book
                {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.titleTextField.text = title
                        self.authorTextField.text = firstAuthor
                        book.title = title
                        book.author = firstAuthor
                        self.loadCover(thumbnail)
                    })
                }
            }
            */
        }
        dataTask.resume()
    }
    func loadCover(thumbnailURL:String) {
        guard let url = NSURL(string: thumbnailURL) else {return}
        print("Loading \(url)")
        let session = NSURLSession.sharedSession()
        let downloadTask = session.downloadTaskWithURL(url) { (temporaryURL, response, error) in
            if let imageURL = temporaryURL, data = NSData(contentsOfURL: imageURL), image = UIImage(data: data) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.imageView.image = image
                    if let book = self.book {
                        book.cover = image
                    }
                })
            }
        }
        downloadTask.resume()
    }
}








