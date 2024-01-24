//
//  Database.swift
//  testownik
//
//  Created by Slawek Kurczewski on 12/04/2020.
//  Copyright © 2020 Slawomir Kurczewski. All rights reserved.
//

import Foundation
import CoreData

protocol DatabaseDelegate {
    func updateGUI()
//    func getNumberOfRecords(numbersOfRecords recNo: Int, eanMode: Bool)
}
protocol DatabaseDataSource {
    var delegate: DatabaseDelegate? { get }
    var context: NSManagedObjectContext { get }
    var fetch: [DatabaseFetch] { get }
    
    var allTestsTable: AllTestsTable! { get }
    var categoriesTable: CategoriesTable! { get }
    var testDescriptionTable: TestDescriptionTable! { get }
    var selectedTestTable: SelectedTestTable! { get }
    var ratingsTable: RatingsTable! { get }
    var testListTable: TestListTable! { get }
    var testToDoTable: TestToDoTable! { get }
}
class AllTestsTable:  DatabaseTableGeneric<AllTestEntity> {
    override class func className() -> String {        return "AllTestsTable"       }
}
class CategoriesTable:  DatabaseTableGeneric<CategoriesEntity> {
    override class func className() -> String {        return "CategoriesTable"   }
}
class TestDescriptionTable:  DatabaseTableGeneric<TestDescriptionEntity> {
    override class func className() -> String {        return "TestDescriptionTable"   }
}
class SelectedTestTable: DatabaseTableGeneric<SelectedTestEntity> {
    override class func className() -> String {        return "SelectedTestTable"   }
}
class RatingsTable: DatabaseTableGeneric<RatingsEntity> {
    override class func className() -> String {        return "RatingsTable"   }
}
class TestListTable: DatabaseTableGeneric<TestListEntity> {
    override class func className() -> String {        return "TestListTable"   }
}
class TestToDoTable: DatabaseTableGeneric<TestToDoEntity> {
    override class func className() -> String {        return "TestToDoTable"   }
}


//    var xx: RatingsEntity
//    var TestListEntity

class Database: DatabaseDataSource {
    var delegate: DatabaseDelegate?
    var context: NSManagedObjectContext
    var fetch: [DatabaseFetch] = [DatabaseFetch](repeating: DatabaseFetch(), count: 3)

    // MARK: - Entitis of project
    var allTestsTable: AllTestsTable!
    var categoriesTable: CategoriesTable!
    var testDescriptionTable: TestDescriptionTable!
    var selectedTestTable: SelectedTestTable!
    var ratingsTable: RatingsTable!
    var testListTable: TestListTable!
    var testToDoTable: TestToDoTable!
    
    //    var xx: RatingsEntity
    //    var TestListEntity
    
    init(context: NSManagedObjectContext) {
        self.context = context
        allTestsTable = AllTestsTable(databaseSelf: self, keys: ["uuId"], ascendingKeys: [true]) {
            return AllTestEntity.fetchRequest()
        }
        categoriesTable = CategoriesTable(databaseSelf: self, keys: ["uuId"], ascendingKeys: [true]) {
            return CategoriesEntity.fetchRequest()
        }
        testDescriptionTable = TestDescriptionTable(databaseSelf: self, keys: ["uuId"], ascendingKeys: [true]) {
            return TestDescriptionEntity.fetchRequest()
        }
        selectedTestTable = SelectedTestTable(databaseSelf: self, keys: ["uuId"], ascendingKeys: [true]) {
            return SelectedTestEntity.fetchRequest()
        }
        ratingsTable = RatingsTable(databaseSelf: self, keys: ["uuId"], ascendingKeys: [true]) {
            return RatingsEntity.fetchRequest()
        }
        testListTable = TestListTable(databaseSelf: self, keys: ["uuId"], ascendingKeys: [true]) {
            return TestListEntity.fetchRequest()
        }
        testToDoTable = TestToDoTable(databaseSelf: self, keys: ["uuId"], ascendingKeys: [true]) {
            return TestToDoEntity.fetchRequest()
        }
    }

    func save() {
        do {   try context.save()    }
        catch  {  print("Error saveing context \(error.localizedDescription)")   }
    }
    func fetchAllTest(with identifier: UUID) -> AllTestEntity? {
        var record: AllTestEntity?
        self.context.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AllTestEntity")
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier as CVarArg)
            fetchRequest.fetchLimit = 1
            record = (try? fetchRequest.execute())?.first as? AllTestEntity
        }
        return record
    }
    
}

