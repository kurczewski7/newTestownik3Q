////
////  .swift
////  testownik
////
////  Created by Sławek K on 10/05/2022.
////  Copyright © 2022 Slawomir Kurczewski. All rights reserved.
////
//import Foundation
//protocol TestToDoDataSource {
//    var count: Int { get }
//    var groups: Int { get }
//    var groupSize: Int { get }
//    var reapeadTest: Int { get }
//    var currentPosition: Int { get }
//    func save()
//    func restore()
//}
//protocol TestToDoDelegate {
//    func allTestDone()
//    func progress(forCurrentPosition currentPosition: Int, totalCount count:Int)
////    func refreshContent(forFileNumber fileNumber: Int)
////    func refreshButtonUI(forFilePosition filePosition: TestManager.FilePosition)
//}
//class TestToDo: TestToDoDataSource {
//    typealias MainTestsValues = (mainTests: [[RawTest]], mainCount: Int, groups: Int, groupSize: Int)
//    typealias ExtraTestsValues = (extraTests: [[RawTest]], extraCount: Int, extraSize: Int)
//    struct TestInfo {
//        let fileNumber: Int
//        let groupNr: Int
//        let errorReapad: Int
//        let reapadNr: Int
//        let checked: Bool
//        let extra: String // ???
//    }
//    struct RawTest {
//        let fileNumber: Int
//        var isExtraTest: Bool
//        var checked: Bool = false
//        var errorCorrect: Bool = false
//    }
////    enum FilePosition {
////        case first
////        case last
////        case other
////    }
//    var delegate: TestToDoDelegate?  //? TestownikDelegate?
//    var groups: Int = 0
//    var groupSize: Int = Setup.defaultMainGroupSize {
//        didSet {
//            if database.selectedTestTable.count > 0 {
//                database.selectedTestTable[0]?.group_size = groupSize.toInt16()
//                database.selectedTestTable.save()
//            }
//        }
//    }
//    var reapeadTest: Int = Setup.defaultReapeadTest {
//        didSet {
//            if database.selectedTestTable.count > 0 {
//                database.selectedTestTable[0]?.reapead_test = reapeadTest.toInt16()
//                database.selectedTestTable.save()
//            }
//        }
//    }
//    var filePosition: TestManager.FilePosition = .first {
//        didSet {
//            if delegate == nil {
//                print("delegate = NIL, 1")
//            }
//            delegate?.refreshButtonUI(forFilePosition: filePosition)
//            if filePosition == .last {
//                delegate?.allTestDone()
//            }
//        }
//    }
//    var currentPosition: Int = 0 {
//        didSet {
//            print("****  CURRENT POSITION=\(currentPosition)")
//            if  self.currentPosition == 0 {    filePosition = .first     }
//            else if  self.currentPosition == count-1 {   filePosition = .last     }
//            else  {  filePosition = .other      }
//            
//            if delegate == nil {
//                print("delegate = NIL, 2")
//            }
//            // TODO: Error
//            //testownik.currentTest += 1
//            delegate?.progress(forCurrentPosition: currentPosition + 1, totalCount: count)
//        }
//    }
//    
//    private var mainCount: Int = 0
//    private var extraCount: Int = 0
//    private var rawTests: [RawTest] = [RawTest]()
//    
//    var mainTests: [[RawTest]] = [[RawTest]]()
//    var extraTests: [[RawTest]] = [[RawTest]]()
//    var count: Int {
//        get {
//            return self.mainCount + self.extraCount
//        }
//    }
//    var currentGroup: Int {
//        get {
//            let numberFrom1 = currentPosition + 1
//            let fullSize = groupSize + reapeadTest
//            return Int(numberFrom1 / fullSize) + (numberFrom1 % fullSize > 0 ? 1 : 0) - 1
//        }
//    }
//    var startSegment = 0
//    subscript(index: Int)  -> RawTest? {
//        return getElem(numberFrom0: index)
//    }
//    subscript(_ group: Int, _ position: Int) ->  RawTest? {
//    guard   group < self.groups, position < mainTests[group].count else {  return nil  }
//        if position <= self.groupSize {
//            return mainTests[group][position]  }
//        else    {
//            return mainTests[group][position - self.groupSize]  }
//    }
//    init(rawTestList: [Int]) {
//        for i in 0..<rawTestList.count {
//            let tmpElem = RawTest(fileNumber: rawTestList[i], isExtraTest: false)
//            self.rawTests.append(tmpElem)
//            
//        }
//        if let selectRec = database.selectedTestTable[0] {
//            self.groupSize = Int(selectRec.group_size)
//            self.reapeadTest = Int(selectRec.reapead_test)
//            self.currentPosition = Int(selectRec.current_position)
//            database.testToDoTable.loadData(forUuid: "uuid_parent", fieldValue: selectRec.uuId!)
//            //selectRec.current_position
//        }
//        if database.testToDoTable.isEmpty {
//            createTests()
//            save()
//        }
//        else {
//            restore()
//        }
//    }
//    private func createTests() {
//        //groups = Int(rawTests.count / groupSize) + (rawTests.count % groupSize == 0 ? 0 : 1 )
//        // TODO: czasowo
//        if let mainVal = fillMainTests(forGroupSize:  5)//self.groupSize) {
//        {
//            self.mainTests = mainVal.mainTests
//            self.mainCount = mainVal.mainCount
//            self.groups    = mainVal.groups
//            self.groupSize = mainVal.groupSize
//        }
//        //if let extraVal = fillExtraTests(forMainTest: self.mainTests, forGroupSize: self.groupSize, forReapeadTest: self.reapeadTest)
//    
//        if let extraVal = fillExtraTests(forMainTest: self.mainTests, forGroupSize: 5, forReapeadTest: 3) {
//            self.extraTests  = extraVal.extraTests
//            self.extraCount  = extraVal.extraCount
//            self.reapeadTest = extraVal.extraSize
//        }
//        // TODO: ????
//        self.currentPosition = 0
//    }
//    func getCurrentRawTest(onlyNewElement onlyNew: Bool = false)  -> RawTest? {
//        print("currentPosition=\(currentPosition)")
//        // print("main[0=\(mainTests[0][0])")
//        if let retVal = getElem(numberFrom0: currentPosition) {
//            return retVal
//        }
//        return nil
//    }
//    func getCurFileNumber() -> Int {
//        guard self.currentPosition < self.count else { return 0 }
//        let fileNumber = getElem(numberFrom0: self.currentPosition)?.fileNumber
//        print("self.currentPosition:\(self.currentPosition)")
//        return fileNumber ?? 0
//    }
//    func getFirst(onlyNewElement onlyNew: Bool = false)  -> RawTest? {
//        currentPosition = 0
//        return getElem(numberFrom0: currentPosition)
//    }
//    func getLast(onlyNewElement onlyNew: Bool = false) -> RawTest? {
//        currentPosition = count - 1
//        return getElem(numberFrom0: currentPosition)
//    }
//    func getNext(onlyNewElement onlyNew: Bool = false)  -> RawTest? {
//        currentPosition += (currentPosition < count - 1 ? 1 : 0)
//        guard currentPosition < count  else {  return nil  }
//        return getElem(numberFrom0: currentPosition, changePosition: true)
//        //return getElem(numberFrom0: currentPosition,
//    }
//    func getPrev(onlyNewElement onlyNew: Bool = false)  -> RawTest? {
//        currentPosition -= (currentPosition > 0 ? 1 : 0)
//        guard currentPosition >= 0 else {  return nil  }
//        return getElem(numberFrom0: currentPosition, changePosition: true)
//    }
//    func getGroup(forNumerTest number: Int) -> Int? {
//        var retVal: Int? = nil
//        for i in 0..<self.groups {
//            if mainTests[i].contains(where: {  $0.fileNumber == number  }) {
//                retVal = i
//                break
//            }
//        }
//        return retVal
//    }
//    //        for i in 0..<count {
////            if let elem = getElem(numberFrom0: i), (!elem.checked || !onlyNew) {
////                self.currentPosition = i
////                return elem
////            }
////        }
//
////        for i in currentPosition..<count {
////            if let elem = getElem(numberFrom0: i), (!elem.checked || !onlyNew) {
////                self.currentPosition = i
////                return elem
////            }
////        }
////        return nil
//
//    func add(forFileNumber number: Int, errorCorrect: Bool = true) {
//        guard let foundGroup = getGroup(forNumerTest: number) else { return   }
//        var row = extraTests[foundGroup]
//        addExtra(forRow: &row, fileNumber: number, errorCorrect: errorCorrect)
//        changeQueue(forRow: &row, fileNumber: number, errorCorrect: errorCorrect)
//        //swapWhenDupplicate(forRow: &row, currentGroup: foundGroup)
//        extraTests[foundGroup] = row
//    }
//    func addExtra(forRow row: inout [RawTest], fileNumber number: Int, errorCorrect: Bool = true) {
//        let dupicArray = row.filter { $0.fileNumber == number && $0.errorCorrect }
//        guard dupicArray.count == 0 else {
//            if let position = findPosition(forRow: row, fileNumber: number) {   row[position].errorCorrect = true      }
//            return
//        }
//        let oneTest = RawTest(fileNumber: number, isExtraTest: true, checked: false, errorCorrect: errorCorrect)
//        let fileNumbersToDelete = row.filter { !$0.errorCorrect }
//        if fileNumbersToDelete.count > 0 {
//            if let newPosition = findPosition(forRow: row, fileNumber: fileNumbersToDelete[0].fileNumber) {
//                row[newPosition] = oneTest
//            }
//        }
//        else {
//            row.append(oneTest)
//            row.remove(at: row.count - 1)
//        }
//    }
//    func getElem(numberFrom0: Int, changePosition: Bool = false) -> RawTest? {
//        var retVal: RawTest = RawTest(fileNumber: 0, isExtraTest: false)
//        let numberFrom1 = numberFrom0 + 1
//        let fullSize = groupSize + reapeadTest
//        guard fullSize > 0 else {  return nil  }
//        let currentGroup = Int(numberFrom1 / fullSize) + (numberFrom1 % fullSize > 0 ? 1 : 0) - 1
//        guard numberFrom0 < self.count, currentGroup < groups, currentGroup < mainTests.count else {      return nil   }
//        if changePosition {
//            self.currentPosition = numberFrom0
//        }
//        let positionInGroup = numberFrom0 - (currentGroup * fullSize)
//        let currGroupSize = mainTests[currentGroup].count
//        
//        if   positionInGroup < currGroupSize {
//            guard currentGroup < mainTests.count else {  return nil  }
//            retVal = mainTests[currentGroup][positionInGroup]
//            retVal.isExtraTest = false
//        }
//        else {
//            // FIXME: Error here
//            guard currentGroup < extraTests.count else {  return nil  }
//            retVal = extraTests[currentGroup][positionInGroup - currGroupSize]
//            retVal.isExtraTest = true
//        }
//        print("File number:\( positionInGroup < currGroupSize ? " " : "E") \(numberFrom0), \(retVal.fileNumber )")
//        return retVal
//    }
//    func reorganizeExtra(forRow row: inout [RawTest], fileNumber: Int, hawMenyTimes number: Int = 30) {
//        let tt = TestToDo.RawTest(fileNumber: fileNumber, isExtraTest: false, checked: false, errorCorrect: false)
//        guard !isSortingOk(forRow: &row) || row[0].fileNumber == fileNumber else {   return     }
//        for _ in 0..<number {
//            reSorting(previousElem: tt, forRow: &row)
//            if row[0].fileNumber == fileNumber {
//                cyclicShift(forRow: &row)
//             }
//            if isSortingOk(forRow: &row) && row[0].fileNumber != fileNumber {   break    }
//            mixTests(inputElements: &row)
//        }
//        if row[0].fileNumber == fileNumber {
//            cyclicShift(forRow: &row)
//        }
//    }
//    func isSortingOk(forRow row: inout [RawTest])  -> Bool {
//        var retVal = true
//        for i in 0..<row.count - 1 {
//            if row[i].fileNumber == row[i+1].fileNumber {
//                retVal = false
//                break
//            }
//        }
//        return retVal
//    }
//    func changeQueue(forRow row: inout [RawTest], fileNumber number: Int, errorCorrect: Bool = true) {
//        var newRow: [RawTest] = [RawTest]()
//        guard row.count > 0 else {   return   }
//        for i in 0..<row.count {
//            if row[i].fileNumber != number {
//                newRow.append(row[i])
//                row.remove(at: i)
//                break
//            }
//        }
//        isertAtEnd(fromRow: &row ,toRow: &newRow)
//        insertBetween(fromRow: &row, toRow: &newRow, fileNumber: number)
//        if row.count > 0 {
//            for _ in 0..<5 {
//                let oldCount = row.count
//                insertBetween(fromRow: &row, toRow: &newRow, fileNumber: number)
//                if row.count == oldCount || row.count == 0 {
//                    break
//                }
//            }
//        }
//        if  row.count > 0 {
//            newRow.append(contentsOf: row)
//            row.removeAll()
//        }
//        row = newRow
//    }
//    //======================================
//    // Private methods
//    private func insertBetween(fromRow row: inout [RawTest], toRow newRow: inout [RawTest], fileNumber number: Int) {
//        var setToDelete = Set([Int]())
//        for pos in 0..<row.count {
//            let tmp = row[pos]
//            for j in 0..<newRow.count {
//                guard row.count > 0 && newRow.count > j else {    continue    }
//                if j == newRow.count - 1 {
//                    if newRow[j].fileNumber != tmp.fileNumber {
//                        newRow.append(tmp)
//                        setToDelete.insert(pos)
//                    }
//                    break
//                }
//                if j == 0  &&  tmp.fileNumber != number  &&  newRow[j].fileNumber != tmp.fileNumber {
//                    newRow.insert(tmp, at: j)
//                    setToDelete.insert(pos)
//                    break
//                }
//                if  newRow[j].fileNumber != tmp.fileNumber && newRow[j+1].fileNumber != tmp.fileNumber {
//                    newRow.insert(tmp, at: j+1)
//                    setToDelete.insert(pos)
//                    break
//                }
//            }
//        }
//        let tabToDelete = setToDelete.sorted {$0 > $1}
//        for poz in tabToDelete {
//            row.remove(at: poz)
//        }
//    }
//    private func isertAtEnd(fromRow row: inout [TestToDo.RawTest], toRow newRow: inout [TestToDo.RawTest]) {
//        var setToDelete = Set([Int]())
//        let couuntRec = row.count
//        for pos in 0..<couuntRec {
//            if newRow[newRow.count-1].fileNumber != row[pos].fileNumber {
//                newRow.append(row[pos])
//                setToDelete.insert(pos)
//            }
//        }
//        let tabToDelete = setToDelete.sorted {$0 > $1}
//        for pos in tabToDelete {
//            row.remove(at: pos)
//        }
//    }
//    private func findPosition(forRow row: [RawTest], fileNumber number: Int) -> Int? {
//            for (index, value) in row.enumerated() {
//                if value.fileNumber == number {   return index    }
//            }
//        return nil
//    }
//    private func cyclicShift(forRow row: inout [RawTest]) {
//        let tmp = row[0]
//        row.remove(at: 0)
//        row.append(tmp)
//    }
////    private func swapWhenDupplicate(forRow row: inout [RawTest],  currentGroup groupNo: Int) {
////        guard groupNo < groups, mainTests[groupNo].count > 0, row.count > 2, mainTests[groupNo][mainTests.count-1].fileNumber == row[0].fileNumber else { return   }
////        //var tmp = extraTests[groupNo]
////        let oneTest = row[1]
////        row.remove(at: 1)
////        row.insert(oneTest, at: 0)
////        extraTests[groupNo] = row
////    }
//    private func reSorting(previousElem: RawTest, forRow row: inout [RawTest]) {
//        var errList: [Int] = [Int]()
//        row.sort { !$0.errorCorrect  &&  $1.errorCorrect }
//        row.sort {
//            if $0.fileNumber == $1.fileNumber  {  errList.append($0.fileNumber) }
//            return true
//        }
//    }
//    private func fillMainTests(forGroupSize groupSize: Int)  -> MainTestsValues?  {
////        var count: Int { get }
////        var groups: Int { get }
////        var groupSize: Int { get }
////        var reapeadTest: Int { get }
////        var currentPosition: Int { get }
//        var mainTests: [[RawTest]] = [[RawTest]]()
//        var mainCount = 0
//        var retVal: MainTestsValues
//        guard groupSize > 0 else {  return nil   }
//        let groups = Int(self.rawTests.count / groupSize) + (self.rawTests.count % groupSize == 0 ? 0 : 1 )
//        for j in 0..<groups {
//            let emptyArray = [RawTest]()
//            mainTests.append(emptyArray)
//            let testsList = lotteryMainTests(fromFilePosition: j*groupSize, arraySize: groupSize)
//            mainTests[j].append(contentsOf: testsList)
//            mainCount += testsList.count
//        }
//        retVal.mainTests = mainTests
//        retVal.mainCount = mainCount
//        retVal.groups    = groups
//        retVal.groupSize = groupSize
//        return retVal
//    }
//    private func fillExtraTests(forMainTest mainTests: [[RawTest]], forGroupSize groupSize: Int, forReapeadTest reapeadTest: Int ) -> ExtraTestsValues?  {
//        var extraTests: [[RawTest]] = [[RawTest]]()
//        var extraCount = 0
//        var retVal: ExtraTestsValues
//        guard groupSize > 0 else {  return nil   }
//        let groups = Int(self.rawTests.count / groupSize) + (self.rawTests.count % groupSize == 0 ? 0 : 1 )
//        for i in 0..<groups {
//            let emptyArray = [RawTest]()
//            extraTests.append(emptyArray)
//            var row = mainTests[i]
//            mixTests(inputElements: &row, count: reapeadTest)
//            if let number = (i != 0 ? mainTests[i-1].last?.fileNumber : 0) {
//                changeQueue(forRow: &row, fileNumber: number)
//                extraTests[i].append(contentsOf: row)
//                extraCount += row.count
//            }
//        }
//        if let lastCount = extraTests.last?.count, lastCount < reapeadTest {
//            var row = extraTests[extraTests.count - 1]
//            let preLast = max(groups - 2, 0)
//            for i in 0..<(reapeadTest - lastCount) {
//                let tmp = extraTests[preLast][i]
//                row.append(tmp)
//                extraCount += 1
//            }
//            let number = mainTests[preLast].last?.fileNumber ?? 0
//            changeQueue(forRow: &row, fileNumber: number)
//            extraTests[extraTests.count - 1] = row
//        }
//        retVal.extraTests = extraTests
//        retVal.extraCount = extraCount
//        retVal.extraSize  = reapeadTest
//        return retVal
//    }
//    private func lotteryMainTests(fromFilePosition startPos: Int, arraySize size: Int, shuffle: Bool = true  ) -> [RawTest]    {
//        var newTests: [RawTest] = [RawTest]()
//        newTests.removeAll()
//        for i in 0..<size {
//            if startPos + i == rawTests.count {   break   }
//            newTests.append(rawTests[startPos + i])
//        }
//        print("befor")
//        for el in newTests {
//            print("\(el.fileNumber)")
//        }
//        if shuffle {
//            mixTests(inputElements: &newTests)
//        }
//        
//        print("after")
//        for el in newTests {
//            print("\(el.fileNumber)")
//        }
//       return newTests
//    }
//    private func mixTests(inputElements inputTst: inout [RawTest], count: Int = -1)  {
//        var outputTst: [RawTest] = [RawTest]()
//        let countElem = inputTst.count
//        for i in 0..<countElem {
//            if i == count {
//                break
//            }
//            let pos = Setup.randomOrder(toMax: inputTst.count)
//            let elem = inputTst[pos]
//            inputTst.remove(at: pos)
//            outputTst.append(elem)
//        }
//        inputTst = outputTst
//    }
//    func resizeAll(newGroupSize groupSize: Int, newReapeadCount reapeadTest:Int, onlyTest: Bool = true) {        
//        let currentPosition = self.currentPosition
//        if !onlyTest {
//            if let mainVal = fillMainTests(forGroupSize: groupSize) {
//                self.mainTests  = mainVal.mainTests
//                self.mainCount  = mainVal.mainCount
//                self.groups     = mainVal.groups
//                self.groupSize  = mainVal.groupSize
//            }
//            if let extraVal = fillExtraTests(forMainTest: self.mainTests, forGroupSize: groupSize, forReapeadTest: reapeadTest) {
//                self.extraTests = extraVal.extraTests
//                self.extraCount = extraVal.extraCount
//            }
//
//            self.groupSize = groupSize
//            self.reapeadTest = reapeadTest
//        }
//        
//        let fileNumber = getElem(numberFrom0: self.currentPosition)?.fileNumber
//        var currentGroup = 0
//        for i in 0..<self.groups {
//            if mainTests[i].contains(where: { $0.fileNumber == fileNumber    }) {
//                currentGroup = i
//                self.startSegment = currentGroup * (groupSize + reapeadTest)
//                self.currentPosition = self.startSegment
//                //
//                //self.currentGroup = currentGroup
//                break
//            }
//        }
//   }
//    func save()  {
//        print("saveTestToDo, befor del:\(database.testToDoTable.count)")
//       
//        let oldPosition = self.currentPosition
//        database.selectedTestTable.loadData()
//        database.selectedTestTable[0]?.current_position = self.currentPosition.toInt16()
//        database.selectedTestTable[0]?.group_size = self.groupSize.toInt16()
//        database.selectedTestTable[0]?.reapead_test = self.reapeadTest.toInt16()
//                
//        guard let uuidParent = database.selectedTestTable[0]?.uuId, self.count > 0 else {   return    }
//        database.testToDoTable.deleteGroup(uuidDeleteField: "uuid_parent", forValue: uuidParent)
//        database.testToDoTable.save()
//        let uuId = UUID()
//        for i in 0..<count {
//            if let elem = getElem(numberFrom0: i) {
//                let rec = TestToDoEntity(context: database.context)
//                rec.lp = Int16(i)
//                rec.uuId = uuId
//                rec.uuid_parent = uuidParent
//                rec.fileNumber = Int16(elem.fileNumber)
//                rec.isExtraTest = elem.isExtraTest
//                rec.checked = elem.checked
//                rec.errorCorrect = elem.errorCorrect
//                _ = database.testToDoTable?.add(value: rec)
//            }
//        }
//        self.currentPosition = oldPosition
//        database.testToDoTable.save()
//        database.selectedTestTable[0]?.current_position = self.currentPosition.toInt16()
//        database.selectedTestTable[0]?.group_size = self.groupSize.toInt16()
//        database.selectedTestTable[0]?.reapead_test = self.reapeadTest.toInt16()
//        database.selectedTestTable.save()
//    }
//    func countArrayElement<T>(ofArray aArray: [[T]]) -> Int {
//        var retVal = 0
//        for i in 0..<aArray.count {
//            for _ in 0..<aArray[i].count {
//                retVal += 1
//            }
//        }
//        return retVal
//    }
//    func restore() {
//        //let onlyTest: Bool = false
//        var restoredDict = [Int: RawTest]()
//        //var restoredTests = [RawTest]()
//        
//        let emptyArray = [RawTest]()
//        var rawTests: [RawTest] = [RawTest]()
//        var mainTests: [[RawTest]] = [[RawTest]]()
//        var extraTests: [[RawTest]] = [[RawTest]]()
//        //var oldIsExtra = true
//        
//        database.selectedTestTable.loadData()
//        guard let uuidParent = database.selectedTestTable[0]?.uuId else {   return    }
//        self.currentPosition = database.selectedTestTable[0]?.current_position.toInt() ?? 0
//        self.groupSize = database.selectedTestTable[0]?.group_size.toInt() ?? Setup.defaultMainGroupSize
//        self.reapeadTest = database.selectedTestTable[0]?.reapead_test.toInt() ?? Setup.defaultReapeadTest
//        let noRestarting = database.selectedTestTable[0]?.nr_retesting.toInt()
//        
//        database.testToDoTable.loadData(forFilterField: "uuid_parent", fieldValue: uuidParent)
//        print("COUNT:\(database.testToDoTable.count)")
//        database.testToDoTable.forEach { index, oneRecord in
//            guard let rec = oneRecord else {    return    }
//            let elem = RawTest(fileNumber: Int(rec.fileNumber), isExtraTest: rec.isExtraTest, checked: rec.checked, errorCorrect: rec.errorCorrect)
//            restoredDict[Int(rec.lp)] = elem
//        }
////        self.mainCount = mainVal.mainCount
////        self.extraCount = extraVal.extraCount
//
//        if restoredDict.count > 0 {
//            for i in 0..<restoredDict.count {
//                if let elem = restoredDict[i] {
//                    rawTests.append(elem)
//                    if !elem.isExtraTest {
//                        if mainTests.last?.count == self.groupSize || mainTests.count == 0 {
//                            mainTests.append(emptyArray)
//                        }
//                        mainTests[mainTests.count - 1].append(elem)
//                   }
//                    else {
//                        if extraTests.last?.count == self.extraCount || extraTests.count == 0 {
//                            extraTests.append(emptyArray)
//                        }
//                        extraTests[extraTests.count - 1].append(elem)
//                    }
//                }
//            }
//            self.currentPosition = Int(database.selectedTestTable[0]?.current_position ?? 0)
//            self.groupSize = Int(database.selectedTestTable[0]?.group_size ?? 30)
//            self.reapeadTest = Int(database.selectedTestTable[0]?.reapead_test ?? 5)
//            self.rawTests = rawTests
//            self.mainTests = mainTests
//            self.extraTests = extraTests
//            self.mainCount = countArrayElement(ofArray: mainTests)
//            self.extraCount = countArrayElement(ofArray: extraTests)
//            self.groups = Int(self.rawTests.count / self.groupSize) + (self.rawTests.count % self.groupSize == 0 ? 0 : 1 )
////                self.groupSize = mainTests.first?.count ?? 30
////                self.reapeadTest = extraTests.first?.count ?? 5
//        }
//        print("MAIN   :\(mainTests.count),\(extraTests.count)")
//    }
//    deinit {
//        save()
//    }
//}
