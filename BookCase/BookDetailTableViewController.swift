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
     /*   let scannerViewController = ScannerViewController()
        scannerViewController.modalPresentationStyle = .Popover
        scannerViewController.popoverPresentationController?.sourceView = barcodeButton
        scannerViewController.popoverPresentationController?.sourceRect = barcodeButton.bounds
        scannerViewController.delegate = self
        self.presentViewController(scannerViewController, animated: true, completion: nil)
       */
        foundBarcode("9780194792325")
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
            //-------> TO BE CONTINUED
        }
    }
}








