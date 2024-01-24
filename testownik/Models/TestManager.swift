////
////  TestManager.swift
////  testownik
////
////  Created by Sławek K on 16/09/2023.
////  Copyright © 2023 Slawomir Kurczewski. All rights reserved.
////
//
//import Foundation
//
//protocol TestManagerDataSource {
//    var count: Int { get }
//    var currentPosition: Int { get }
//    var lastFileNumber: Int { get set }
//    
//    var rawTestList : [Int] { get }
////    var allTestPull: [TestManager.TestInfo] { get }
////    var loteryTestBasket: [TestManager.TestInfo] { get }
////    var historycalTest: [TestManager.TestInfo] { get }
//
//
////    var groups: Int { get }
////    var groupSize: Int { get }
////    var reapeadTest: Int { get }
////    var currentPosition: Int { get }
////    func save()
////    func restore()
//}
//protocol TestManagerDelegate {
//    func allTestDone()
//    func progress(forCurrentPosition currentPosition: Int, totalCount count:Int)
//    func refreshContent(forFileNumber fileNumber: Int)
////    func refreshButtonUI(forFilePosition filePosition: TestManager.FilePosition)
//    
//    //func refreshButtonUI(forFilePosition filePosition: TestManager.FilePosition)
//}
//class TestManager:  TestManagerDataSource {  //
//    struct TestInfo {
//        let fileNumber: Int
//        let lifeValue: Int
//        
//        //        let groupNr: Int
//        //        let errorReapad: Int
//        //        let reapadNr: Int
//        //        let checked: Bool
//        //        let extra: String // ???
//    }
//    struct RawTest {
//        let fileNumber: Int
//        var isExtraTest: Bool
//        var checked: Bool = false
//        var errorCorrect: Bool = false
//    }
//    enum FilePosition {
//        case first
//        case last
//        case other
//    }
//    
////    var delegate: TestManagerDelegate?
//    
//    let groupSize = 5  //Setup.defaultMainGroupSize
//    let maxValueLive: Int
//    var lastFileNumber: Int = 0
//    var rawTestListCount: Int = 0
//    var rawTestList = [Int]()
//    
//    var allTestPull: [TestInfo] = [TestInfo]()
//    var loteryTestBasket: [TestInfo] = [TestInfo]()
//    var historycalTest: [TestInfo] = [TestInfo]()
//    var count: Int {
//        get {
//            return allTestPull.count + loteryTestBasket.count
//        }
//    }
//    var filePosition: FilePosition = Manager.FilePosition.first
//        didSet {
////            if delegate == nil {
////                print("delegate = NIL, 1")
////            }
////            delegate?.refreshButtonUI(forFilePosition: filePosition)
////            if filePosition == .last {
////                delegate?.allTestDone()
////            }
//        }
//    }
//    var currentPosition: Int = 0 {
//        didSet {
//            print("****  CURRENT POSITION=\(currentPosition)")
//            //            if  self.currentPosition == 0 {    filePosition = .first     }
//            //            else if  self.currentPosition == count-1 {   filePosition = .last     }
//            //            else  {  filePosition = .other      }
//            
////            if delegate == nil {
////                print("delegate = NIL, 2")
////            }
////            else {
////                delegate?.progress(forCurrentPosition: currentPosition + 1, totalCount: count)
////            }
//        }
//    }
//    var currentAnswerOptions: TestInfo = TestInfo(fileNumber: 0, lifeValue: 0)
//    
//    
//    //    var currentPosition: Int = 0 {
//    //        didSet {
//    //            print("****  CURRENT POSITION=\(currentPosition)")
//    //            if  self.currentPosition == 0 {    filePosition = .first     }
//    //            else if  self.currentPosition == count-1 {   filePosition = .last     }
//    //            else  {  filePosition = .other      }
//    //
//    //            if delegate == nil {
//    //                print("delegate = NIL, 2")
//    //            }
//    //            // TODO: Error
//    //            //testownik.currentTest += 1
//    //            delegate?.progress(forCurrentPosition: currentPosition + 1, totalCount: count)
//    //        }
//    //    }
//    
//    init(_ rawTestListCount: Int, maxValueLive: Int = 3) {
//        self.rawTestListCount = rawTestListCount
//        self.maxValueLive = maxValueLive
//        fillTestManager(forRawListCout: rawTestListCount, forLive: maxValueLive)
//        //self.rawTestList = rawTestList
//    }
//    func fillTestManager(forRawListCout rawListCount: Int, forLive lifeValue: Int) {
//        allTestPull.removeAll()
//        for i in 0..<rawTestListCount {
//            let tmpElem = TestInfo(fileNumber: i, lifeValue: lifeValue)
//            allTestPull.append(tmpElem)
//        }
//        loteryQueue()
//        _ = getNext()
//    }
//    func loteryQueue() {
//        var tmpTestPull = [TestInfo]()
//        let totalGroups = (self.allTestPull.count / self.groupSize) + (self.allTestPull.count % self.groupSize == 0 ? 0 : 1 )
//        for i in 0..<totalGroups {
//            let oneGroup = Setup.changeArryyOrder(forArray: self.allTestPull, fromPosition: i * self.groupSize, count: self.groupSize)
//            tmpTestPull.append(contentsOf: oneGroup)
//        }
//        print("new Pull: \(tmpTestPull)")
//        self.allTestPull = tmpTestPull
//    }
//    func getFirst(onlyNewElement onlyNew: Bool = false)  -> TestInfo? {
//        if historycalTest.isEmpty {
//            return nil
//        }
//        else {
//            return historycalTest.first
//        }
//    }
//    func getLast(onlyNewElement onlyNew: Bool = false) -> RawTest? {
//        //        currentPosition = count - 1
//        //        return getElem(numberFrom0: currentPosition)
//        return nil
//    }
//    // MARK: getNext
//    func getNext(onlyNewElement onlyNew: Bool = false)  -> TestInfo? {
//        if self.loteryTestBasket.isEmpty {
//            let end = min(groupSize, allTestPull.count)
//            let moreTests = allTestPull[0..<end]
//            loteryTestBasket.append(contentsOf: moreTests)
//            for _ in 0..<moreTests.count {
//                allTestPull.remove(at: 0)
//            }
//        }
//        guard !loteryTestBasket.isEmpty else {   return nil    }
//        let oneTest = loteryTestBasket.first
//        loteryTestBasket.remove(at: 0)
//        if let nextTest = allTestPull.first {
//            loteryTestBasket.append(nextTest)
//            allTestPull.remove(at: 0)
//        }
//        print("oneTest.number:\(oneTest?.fileNumber)")
//        currentPosition += (currentPosition < historycalTest.count - 1 ? 1 : 0 )
//        if currentPosition == historycalTest.count  {
//            historycalTest.append(oneTest!)
//        }
//        return oneTest
//        
//        //guard self.groupSize <= self.loteryTestBasket.count  else { return  }
//        //        currentPosition += (currentPosition < count - 1 ? 1 : 0)
//        //        guard currentPosition < count  else {  return nil  }
//        //        return getElem(numberFrom0: currentPosition, changePosition: true)
//        //        //return getElem(numberFrom0: currentPosition,
//    }
//    func getPrev(onlyNewElement onlyNew: Bool = false)  -> TestInfo? {
//        guard currentPosition >= 0, currentPosition < historycalTest.count  else {  return nil  }
//        currentPosition -= (currentPosition > 0 ? 1 : 0 )
//        return getElem(numberFrom0: currentPosition, changePosition: true)
//    }
//    func getRandom() -> TestInfo? {
//        guard self.loteryTestBasket.count > 0 else {    return nil   }
//        let randomPoz = Setup.randomOrder(toMax: self.loteryTestBasket.count)
//        guard randomPoz < self.loteryTestBasket.count else { return nil }
//        self.currentPosition = randomPoz
//        let current = self.loteryTestBasket[randomPoz]
//        return current
//    }
//    func getCurrent() -> TestInfo? {
//        guard !loteryTestBasket.isEmpty, self.currentPosition >= 0 else {   return nil    }
//        return self.loteryTestBasket[self.currentPosition]
//    }
//    //------------------
//    //    func getCurrentRawTest
//    //    func getFirst
//    //    func getLast
//    //    func getNext
//    //    func getPrev
//    
//    func getCurFileNumber() -> Int {
//        //        guard self.currentPosition < self.count else { return 0 }
//        //        let fileNumber = getElem(numberFrom0: self.currentPosition)?.fileNumber
//        //        print("self.currentPosition:\(self.currentPosition)")
//        //        return fileNumber ?? 0
//        return 0
//    }
//    //        currentPosition = 0
//    //        return getElem(numberFrom0: currentPosition)
//    func getCurrentRawTest(onlyNewElement onlyNew: Bool = false)  -> RawTest? {
//        //        print("currentPosition=\(currentPosition)")
//        //        // print("main[0=\(mainTests[0][0])")
//        //        if let retVal = getElem(numberFrom0: currentPosition) {
//        //            return retVal
//        //        }
//        return nil
//    }
//    
//    func getElem(numberFrom0: Int, changePosition: Bool = false) -> TestInfo? {
//        //var retVal: RawTest = RawTest(fileNumber: 0, isExtraTest: false)
//        guard currentPosition >= 0, currentPosition < historycalTest.count  else {  return nil  }
//        return historycalTest[currentPosition]
//    }
//    func getCurrentTest(forTestInfo testInfo: TestInfo) -> RawTest? {
//        let rawTest = RawTest(fileNumber: 0, isExtraTest: false)
//        let fileNumber = testInfo.fileNumber
//        return rawTest
//    }
//        
//        //    func changeQueue(forRow row: inout [RawTest], fileNumber number: Int, errorCorrect: Bool = true) {
//        //        var newRow: [RawTest] = [RawTest]()
//        //        guard row.count > 0 else {   return   }
//        //        for i in 0..<row.count {
//        //            if row[i].fileNumber != number {
//        //                newRow.append(row[i])
//        //                row.remove(at: i)
//        //                break
//        //            }
//        //        }
//        //        insertAtEnd(fromRow: &row ,toRow: &newRow)
//        //        insertBetween(fromRow: &row, toRow: &newRow, fileNumber: number)
//        //        if row.count > 0 {
//        //            for _ in 0..<5 {
//        //                let oldCount = row.count
//        //                insertBetween(fromRow: &row, toRow: &newRow, fileNumber: number)
//        //                if row.count == oldCount || row.count == 0 {
//        //                    break
//        //                }
//        //            }
//        //        }
//        //        if  row.count > 0 {
//        //            newRow.append(contentsOf: row)
//        //            row.removeAll()
//        //        }
//        //        row = newRow
//        //    }
//        //    private func insertAtEnd(fromRow row: inout [TestManager.RawTest], toRow newRow: inout [TestManager.RawTest]) {
//        //        var setToDelete = Set([Int]())
//        //        let couuntRec = row.count
//        //        for pos in 0..<couuntRec {
//        //            if newRow[newRow.count-1].fileNumber != row[pos].fileNumber {
//        //                newRow.append(row[pos])
//        //                setToDelete.insert(pos)
//        //            }
//        //        }
//        //        let tabToDelete = setToDelete.sorted {$0 > $1}
//        //        for pos in tabToDelete {
//        //            row.remove(at: pos)
//        //        }
//        //    }
//        //    private func insertBetween(fromRow row: inout [TestManager.RawTest], toRow newRow: inout [TestManager.RawTest], fileNumber number: Int) {
//        //        var setToDelete = Set([Int]())
//        //        for pos in 0..<row.count {
//        //            let tmp = row[pos]
//        //            for j in 0..<newRow.count {
//        //                guard row.count > 0 && newRow.count > j else {    continue    }
//        //                if j == newRow.count - 1 {
//        //                    if newRow[j].fileNumber != tmp.fileNumber {
//        //                        newRow.append(tmp)
//        //                        setToDelete.insert(pos)
//        //                    }
//        //                    break
//        //                }
//        //                if j == 0  &&  tmp.fileNumber != number  &&  newRow[j].fileNumber != tmp.fileNumber {
//        //                    newRow.insert(tmp, at: j)
//        //                    setToDelete.insert(pos)
//        //                    break
//        //                }
//        //                if  newRow[j].fileNumber != tmp.fileNumber && newRow[j+1].fileNumber != tmp.fileNumber {
//        //                    newRow.insert(tmp, at: j+1)
//        //                    setToDelete.insert(pos)
//        //                    break
//        //                }
//        //            }
//        //        }
//        //        let tabToDelete = setToDelete.sorted {$0 > $1}
//        //        for poz in tabToDelete {
//        //            row.remove(at: poz)
//        //        }
//        //    }
//
//    
//}
//// End
//
////    func getNextTest() {
////        if self.loteryTestBasket.isEmpty {
////            //guard self.groupSize <= self.loteryTestBasket.count  else { return  }
////            let end = min(self.groupSize, self.allTestPull.count)
////            let moreTests = self.allTestPull[0..<end]
////            self.loteryTestBasket.append(contentsOf: moreTests)
////            //historycalTest.append(<#T##newElement: TestInfo##TestInfo#>)
////            for _ in 0..<moreTests.count {
////                self.allTestPull.remove(at: 0)
////            }
////        }
////        else    {
////            if let oneTest = self.allTestPull.first {
////                self.loteryTestBasket.append(oneTest)
////                self.historycalTest.append(oneTest)
////                self.allTestPull.remove(at: 0)
////            }
////        }
////    }
//
