//
//  Event.swift
//  countdown
//
//  Created by evdodima on 17/02/2017.
//  Copyright © 2017 Evdodima. All rights reserved.
//

import Foundation
import UIKit


class Event : NSObject, NSCoding {
    var name:String
    var date:Date
    var creationDate:Date
    var imageName:String
    
    init(name:String, date:Date, creationDate:Date){
        self.name = name
        self.date = date
        self.creationDate = creationDate
        
        let randomIndex = Int(arc4random_uniform(UInt32(imageNames.count)))
        imageName =  imageNames[randomIndex]
        
    }
    
    public func encode(with aCoder: NSCoder){
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.date, forKey:"date")
        aCoder.encode(self.creationDate, forKey:"creationDate")
        aCoder.encode(self.imageName, forKey:"imageName")
    }
    
    public required init?(coder aDecoder: NSCoder){
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.date = aDecoder.decodeObject(forKey: "date") as! Date
        self.creationDate = aDecoder.decodeObject(forKey: "creationDate") as! Date
        self.imageName = aDecoder.decodeObject(forKey:"imageName") as! String
    }




}
