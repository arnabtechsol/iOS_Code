//
//  Place+CoreDataProperties.swift
//  
//
//  Created by Arnab on 24/06/18.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var address: String?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var placeid: String?
    @NSManaged public var search_string: String?

}
