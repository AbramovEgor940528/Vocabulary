//
//  WordEntity+CoreDataProperties.swift
//  Vocabulary
//
//  Created by Егор Абрамов on 18.05.2025.
//
//

import Foundation
import CoreData


extension WordEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordEntity> {
        return NSFetchRequest<WordEntity>(entityName: "WordEntity")
    }

    @NSManaged public var trancription: String?
    @NSManaged public var translation: String?
    @NSManaged public var word: String?

}

extension WordEntity : Identifiable {

}
