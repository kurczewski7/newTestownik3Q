//
//  DatabaseFetch.swift
//  testownik
//
//  Created by Slawek Kurczewski on 17/04/2020.
//  Copyright © 2020 Slawomir Kurczewski. All rights reserved.
//

import Foundation
import CoreData

class DatabaseFetch  {
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var context : NSManagedObjectContext {
        get {
            return fetchedResultsController.managedObjectContext
            //.delete(<#T##object: NSManagedObject##NSManagedObject#>)
        }
    }
    var sectionCount : Int {
        get {   return fetchedResultsController.sections?.count ?? 1     }
    }
    func configFetch(entityName: String, context: NSManagedObjectContext, key: String, ascending: Bool = true) {
        let context = database.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sort1 = NSSortDescriptor(key: key, ascending: ascending)
        fetchRequest.sortDescriptors = [sort1]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,  managedObjectContext: context,
                                                              sectionNameKeyPath: key, cacheName: "SectionCache")
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    func rowCount(forSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    func getObj(at indexPath: IndexPath) -> NSFetchRequestResult {
        let obj = fetchedResultsController.object(at: indexPath)
        return obj
    }
    func deleteObj(_ object: NSManagedObject) { 
        context.delete(object)
    }
    func save() {
        do {   try self.context.save()    }
        catch  {  print("Error saveing context \(error.localizedDescription)")   }
    }
}

