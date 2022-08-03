//
//  Human+CoreDataProperties.swift
//  GeekBrainsLesons
//
//  Created by Олег Ганяхин on 21.02.2022.
//
//

import Foundation
import CoreData


extension Human {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Human> {
        return NSFetchRequest<Human>(entityName: "Human")
    }

    @NSManaged public var name: String?
    @NSManaged public var gender: Bool
    @NSManaged public var birthday: Date?

}

extension Human : Identifiable {

}
