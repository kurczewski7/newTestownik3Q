//
//  Ratings.swift
//  testownik
//
//  Created by Slawek Kurczewski on 13/11/2021.
//  Copyright © 2021 Slawomir Kurczewski. All rights reserved.
//

import Foundation

class Ratings {
    struct TestListStruct    {
        var lp: Int = 0
        var ratingIndex: Int = 0
    }
    var currentTest = 0
    var testList: [Int] = [4,2,4,2,1,7]
    //                     2,1,2,1,0,3
    var count: Int {
        get {    return testList.count    }
    }
    var results = [ TestResult(1, lastAnswer: false),
                    TestResult(2, lastAnswer: false),
                    TestResult(4, lastAnswer: true),
                    TestResult(7, lastAnswer: true)]    //[TestResult]()
    subscript(index: Int) -> TestResult? {
        get {
            guard index < self.testList.count  else {   return nil  }
            self.currentTest = index
            return  find(testForValue: self.testList[index])
        }
        set(newValue) {
            //print("oldValue: \(oldValue), newValue: \(newValue)")
            guard let newValue = newValue, index < self.testList.count   else {   return   }
            guard self.testList.first(where: {  $0 == newValue.fileNumber   }) != nil else { return }
            if let posInResults = find(posForValue: self.testList[index]) {
                if self.results[posInResults].fileNumber == newValue.fileNumber {
                    self.currentTest = index
                    self.results[posInResults] = newValue
                }
            }
        }
    }
    func editRating(forIndex index: Int, completion:  (_ result: TestResult) -> TestResult       ) {
        guard  index < self.testList.count   else {   return   }
        guard let testPos = find(posForValue: self.testList[index]) else { return  }
        self.results[testPos] = completion(self.results[testPos])
    }
    func addRating(_ fileNumber: Int, lastAnswer answer: Bool) {
        if let position = find(posForValue: fileNumber) {
            let oldTest = self.results[position]
            self.results.remove(at: position)
            oldTest.lastAnswer = answer
            self.results.append(oldTest)
        }
        else {
            let testResult = TestResult(fileNumber, lastAnswer: answer)
            self.results.append(testResult)
        }
    }

//     ratins[2] = TestResult(4, lastAnswer: true)
//      let xx = ratins[2]
        
    func getCurrTest(numberOnList nr: Int) -> TestResult? {
        guard nr < self.testList.count  else {   return nil  }
        return  find(testForValue: self.testList[nr])
    }
    func setCurrTest() {

        
    }
    func xxxxxx() {
        for el in self.testList {
            //print("el:\(el)")
            let bb = find(testForValue: el)
            print("el:\(el),bb:\(bb?.fileNumber ?? 0),\(bb?.lastAnswer ?? false)")
        }
    }
    func printf() {
        print("results:\(results)")
        print("testList:\(testList)")
    }
    func findElem(searchVal: Int) {
        if let val = self.results.first(where: {  $0.fileNumber == searchVal  }) {
            print("NEative:\(val)")
        }
    }
    func find(posForValue searchVal: Int)  -> Int? {
        for (index, value) in self.results.enumerated() {
            if value.fileNumber == searchVal {
                return index
            }
        }
        return nil
    }
    func find(testForValue searchVal: Int)  -> TestResult? {
        for (index, value) in self.results.enumerated() {
            if value.fileNumber == searchVal {
                return results[index]
            }
        }
        return nil
    }
    func saveRatings() {
        guard let uuId = database.selectedTestTable[0]?.uuId, self.results.count > 0 else {   return    }
        
        print("saveRatings, befor del:\(database.ratingsTable.count)")
        database.ratingsTable.deleteGroup(uuidDeleteField: "uuid_parent", forValue: uuId)
        database.ratingsTable.save()
        print("saveRatings,ratingsTable after del:\(database.ratingsTable.count)")
        
        print("saveRatings,results save:\(self.results.count)")
        for (index, value) in self.results.enumerated() {
            let rec = RatingsEntity(context: database.context)
            rec.lp = index.toInt16()
            print("index:\(index).\(uuId)")
            rec.uuId = UUID()
            rec.uuid_parent = uuId
            rec.file_number = value.fileNumber.toInt16()
            rec.good_answers = value.goodAnswers.toInt16()
            rec.wrong_answers = value.wrongAnswers.toInt16()
            rec.last_answer = value.lastAnswer
            rec.corrections_to_do = value.correctionsToDo.toInt16()
            rec.repetitions_to_do = value.repetitionsToDo.toInt16()
            _ = database.ratingsTable?.add(value: rec)
        }
        print("restoreRatings, befor save:\(database.ratingsTable.count)")
        database.ratingsTable?.save()
        print("restoreRatings, after save:\(database.ratingsTable.count)")
    }
    func saveTestList() {
        guard let uuId = database.selectedTestTable[0]?.uuId, self.testList.count > 0 else {   return     }

        print("saveTestList, befor save:\(self.testList.count)")
        database.testListTable.deleteGroup(uuidDeleteField: "uuid_parent", forValue: uuId)
        //database.testListTable.save()
        print("saveTestList, after save:\(self.testList.count)")
        
        for (index, value) in self.testList.enumerated() {
            let rec = TestListEntity(context: database.context)
            rec.lp = index.toInt16()
            rec.uuId = UUID()
            rec.uuid_parent = uuId
            rec.rating_index = value.toInt16()
            rec.done = true
            _ = database.testListTable?.add(value: rec)
        }
        database.testListTable?.save()
    }
    func restoreRatings() {
        var newRatings = [TestResult]()
        newRatings.removeAll()
        print("restoreRatings, restore:\(database.ratingsTable.count)")
        database.ratingsTable.forEach { index, oneElement in
            guard let elem = oneElement else {    return    }
            let fileNumber: Int = Int(oneElement?.file_number ?? 9999)
            let lastAnswer: Bool = oneElement?.last_answer ?? false
            let tmp = TestResult(fileNumber, lastAnswer: lastAnswer)
            
            tmp.correctionsToDo = elem.corrections_to_do.toInt()
            tmp.repetitionsToDo = elem.repetitions_to_do.toInt()
            tmp.setWrongAnswers(elem.wrong_answers.toInt())
            tmp.setGoodAnswers(elem.good_answers.toInt())
            tmp.errorMultiple = 2
            print("index:\(index)")
            newRatings.append(tmp)
        }
        if newRatings.count > 0 {
            self.results = newRatings
        }
        print("RRRRR:\(newRatings)")
    }
    func restoreTestList() {
        //    var testList: [Int] = [4,2,4,2,1,7]
        var newTestList = [TestListStruct]()
        newTestList.removeAll()
        print("restoreRatings, restore:\(database.ratingsTable.count)")
        database.testListTable.forEach { index, oneElement in
            guard let elem = oneElement else {    return    }
//            let lp: Int = Int(elem.lp)
//            let ratingIndex: Int = Int(elem.rating_index)
            let tmp = TestListStruct(lp: Int(elem.lp), ratingIndex: Int(elem.rating_index))
             
            //tmp.correctionsToDo = Int(elem.corrections_to_do)
            print("index:\(index)")
            //
            newTestList.append(tmp)
        }
        let aList = newTestList.sorted {    $0.lp < $1.lp  }.map {  $0.ratingIndex  }
        if aList.count > 0 {
            self.testList = aList
        }
        print("RRRRR:\(newTestList)")
    }
}
