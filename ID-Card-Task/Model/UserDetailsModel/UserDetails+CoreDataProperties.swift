//
//  UserDetails+CoreDataProperties.swift
//  
//
//  Created by ADMIN on 09/03/21.
//
//

import Foundation
import CoreData


extension UserDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetails> {
        return NSFetchRequest<UserDetails>(entityName: "UserDetails")
    }

    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var email: String?
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var street: String?
    @NSManaged public var zipCode: String?
    @NSManaged public var idCard: Bool

}
