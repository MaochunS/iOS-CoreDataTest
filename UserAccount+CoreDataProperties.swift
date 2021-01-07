//
//  UserAccount+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by maochun on 2021/1/7.
//
//

import Foundation
import CoreData


extension UserAccount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserAccount> {
        return NSFetchRequest<UserAccount>(entityName: "UserAccount")
    }

    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var tel: String?
   

}

extension UserAccount : Identifiable {

}
