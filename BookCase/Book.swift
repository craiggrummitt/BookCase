//
//  BookModel.swift
//  HouseHunter
//
//  Created by Craig Grummitt on 29/02/2016.
//  Copyright © 2016 Craig Grummitt. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

public class Book: NSObject, NSCoding {
    
    var title:String
    var author:String
    var notes:String
    
    init(title:String,author:String,notes:String) {
        self.notes = notes
        self.title = title
        self.author = author
    }
    
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let BooksDirectory = DocumentsDirectory.URLByAppendingPathComponent("Books")
    
    // MARK: Types
    struct PropertyKey {
        static let title = "title"
        static let author = "author"
        static let notes = "notes"
    }
    
    // MARK: NSCoding
    convenience required public init?(coder aDecoder: NSCoder) {
        guard let title = aDecoder.decodeObjectForKey(PropertyKey.title) as? String,
        let author = aDecoder.decodeObjectForKey(PropertyKey.author) as? String,
        let notes = aDecoder.decodeObjectForKey(PropertyKey.notes) as? String
        
            else { return nil }
        
        self.init(
            title: title,
            author: author,
            notes: notes
        )
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: PropertyKey.title)
        aCoder.encodeObject(self.author, forKey: PropertyKey.author)
        aCoder.encodeObject(self.notes, forKey: PropertyKey.notes)
    }
}
