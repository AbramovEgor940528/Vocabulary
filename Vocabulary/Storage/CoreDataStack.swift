//
//  CoreDataStack.swift
//  Vocabulary
//
//  Created by Егор Абрамов on 25.05.2025.
//

import Foundation
import CoreData

enum Constant {
    static let dataModelFilename = "Vocabulary"
}

class CoreDataStack {
    static let shared = CoreDataStack()
    
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: Constant.dataModelFilename)
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        
        return container
    }()
    
    private init() {}
    
    private func save() {
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Failed to save the context:", error.localizedDescription)
        }
    }
    
    // MARK: CRUD
    
    func saveWord(word: String, transсription: String, translation: String) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "WordEntity", in: context) else {return}
        
        let newWord = WordEntity(entity: entity, insertInto: context)
        
        newWord.word = word
        newWord.transcription = transсription
        newWord.translation = translation
        
        save()
    }
    
    func readWords() -> [WordEntity] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WordEntity")
        do {
            let result = try context.fetch(fetchRequest) as? [WordEntity]
            return result ?? []
        } catch {
            print("Ошибка чтения: \(error)")
            return []
        }
    }
    
    func deleteWord( word: String ) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WordEntity")
//        do {
//            let result = try context.fetch(fetchRequest) as? [WordEntity]
//            if var result = result {
//                for (index, element) in result.enumerated() {
//                    if word == element.word {
//                        result.remove(at: index)
//                    }
//                }
//            }
//        }
        do {
           if let result = try context.fetch(fetchRequest) as? [WordEntity],
            let wordForDelete = result.first(where: { $0.word == word } ) {
                context.delete(wordForDelete)
               save()
               print(" Удалили \(word) из CD ")
               
           } else {
               print("Ошибка - не удалось найти слово")
           }
        } catch {
            print("Ошибка удаления \(error)")
        }
    }
}


