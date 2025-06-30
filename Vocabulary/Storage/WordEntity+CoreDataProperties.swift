//
//  WordEntity+CoreDataProperties.swift
//  Vocabulary
//
import Foundation
import CoreData

@objc(WordEntity)
public class WordEntity: NSManagedObject {

}

extension WordEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordEntity> {
        return NSFetchRequest<WordEntity>(entityName: "WordEntity")
    }

    @NSManaged public var transcription: String?
    @NSManaged public var translation: String?
    @NSManaged public var word: String?

}

extension WordEntity : Identifiable {

}
