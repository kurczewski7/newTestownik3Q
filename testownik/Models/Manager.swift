//
//  Manager.swift
//  Pods
//
//  Created by Sławek K on 03/12/2023.
//

import Foundation

//protocol ArrayProperty {
//    var currentIndex: Int { get }
//}

//---------------------------------
// MARK: extension
typealias TestDataArr = [Manager.TestHistoryData]
extension TestDataArr {
    func createSortKey() -> [Int] {
        let len = self.count
        guard len > 0 else { return [Int]() }
        var retVal: [Int] = [Int](repeating: 0, count: len)
        for i in 0..<len {
            retVal[i] = i
        }
        return Setup.changeArryyOrder(forArray: retVal, fromPosition: 0, count: retVal.count)
    }
    //            let sortedArr = self.changeSubArryyOrder(forSubArray: retVal, fromPosition: 0, count: retVal.count)
    //            return sortedArr
    func sortFullArrayIntoGroups(forGroupLenth lenth: Int) -> [Element] {
        // FIXME: not last group
        let emptyArr = [Element]()
        var retValue = [Element]()
        var row = [Element]()
        guard lenth > 0 else { return emptyArr }
        //let groups = Int(self.count / lenth)
        let totalGroups = (self.count / lenth) + (self.count % lenth == 0 ? 0 : 1 )
        retValue.removeAll()
        for i in 0..<totalGroups {
            row.removeAll()
            row = sortOneArrayFragment(fromStartIndex: i * lenth, count: lenth)
            retValue.append(contentsOf: row)
        }
        // TODO: fill it
        return retValue
    }
    func sortOneArrayFragment(fromStartIndex start: Int, count: Int)  -> [Element]  {
        let emptyArr = [Element]()
        guard self.isInRange(start) else { return emptyArr }
        let end = Swift.min(start + count - 1, self.endIndex - 1)
        guard self.isInRange(end) else { return emptyArr }
        var tmpArr = Array(self[start...end])
        tmpArr = self.changeSubArryyOrder(forSubArray: tmpArr, fromPosition: 0, count: tmpArr.count)
        return tmpArr
    }
}
//---------------------------------
// MARK: protocol
protocol ManagerDataSource {
    var count: Int { get }
    var currentPosition: Int { get }
    var fileNumber: Int { get set }
    var finishedAdd: Bool { get set }
    func save()
    func restore()

    var testList : [Test] { get }
    var allTestPull: TestDataArr { get }
    var loteryTestBasket: TestDataArr { get }
    var historycalTest: TestDataArr { get }
    var finishedTest: TestDataArr { get }
}
protocol ManagerDelegate {
    func allTestDone()
    func progress(forCurrentPosition currentPosition: Int, totalPercent percent:Int)
    //func refreshContent(forFileNumber fileNumber: Int)
    func refreshView()
    func refreshButtonUI(forFilePosition filePosition: Manager.FilePosition)
    
    //func refreshButtonUI(forFilePosition filePosition: TestManager.FilePosition)
}
//---------------------------------
// MARK: class
class Manager: ManagerDataSource  {
    // MARK: type
    enum FilePosition {
        case first
        case last
        case other
    }
    enum HistoryArrayType: Int {
        case undefined = 0
        case allPool   = 1
        case basket    = 2
        case history   = 3
        case finished  = 4
    }
    struct AnswerShort {
            var isOK: Bool
            var lastYourCheck: Bool = false
    }
    struct TestHistoryData {
        let fileNumber: Int
        let lifeValue: Int
        var answerOptions = [AnswerShort]()
        var oneWasSelected: Bool = false
        var isCorect: Bool = false
        var keySort: [Int] = [Int]()
    }
    //        let groupNr: Int
    //        let errorReapad: Int
    //        let reapadNr: Int
    //        let checked: Bool
    //        let extra: String // ???

    // MARK: variable
    var delegate: ManagerDelegate?
    var count: Int = 0
    var groupSize = 0
    var finishedAdd = true
    let isSortDisplay = true
    
    var testList : [Test] = [Test]()
    var allTestPull: TestDataArr = TestDataArr()
    var loteryTestBasket: TestDataArr = TestDataArr()
    var historycalTest: TestDataArr = TestDataArr()
    var finishedTest: TestDataArr = TestDataArr()

    var totalCount: Int {
        return allTestPull.count + loteryTestBasket.count + finishedTest.count
    }
    var curFilePos: FilePosition = .first {
        didSet {
            if curFilePos != oldValue {
                delegate?.refreshButtonUI(forFilePosition: self.curFilePos)
            }
        }
    }
    var fileNumber: Int = -1 {
        didSet {
            if fileNumber != oldValue {
                delegate?.refreshView()
            }
        }
    }
    var currentPosition: Int = -1 {
        didSet {
            if currentPosition != oldValue  {
                if let fileNr = currentHistory?.fileNumber {
                    self.fileNumber = fileNr
                }
                self.currentTest = getCurrentTest()
                self.curFilePos = .other
                if currentPosition == 0 {
                    self.curFilePos = .first
                }
                else if historycalTest.isLast(currentPosition) && self.finishedAdd   {      //    || true
                    self.curFilePos = .last
                }
                //let percent =  testList.count > 0 ? Int((finishedTest.count * 100) / testList.count) : 0
                let percent =  historycalTest.count > 0 ? Int(((currentPosition + 1) * 100) / historycalTest.count) : 0
                delegate?.progress(forCurrentPosition: currentPosition, totalPercent: percent)
            }
        }
    }
    //var tmpTest: Test?
    var currentTest: Test? {
        willSet {
                setCurrenTest(forNewValue: newValue)
        }
    }
    var currentHistory: TestHistoryData? {
        get {
            guard historycalTest.isInRange(currentPosition) else { return nil }
            return historycalTest[currentPosition]
        }
    }
    
    // MARK: init
    init(_ testListCount: Int, maxValueLive: Int, groupSize: Int ) {
        self.groupSize = groupSize
        self.fillAllTestPull(testListCount: testListCount, forLiveValue: maxValueLive, groupSize: groupSize)
        _ = self.fillLoteryBasket()
        print("\(allTestPull.map({$0.fileNumber}))")
        print("TEST LIST=\(testList.map({$0.fileNumber}))")
        //let xx = currentTest
    }
    // MARK: methods
    func changeAnswer(forNumberOption number: Int) {
        guard historycalTest.isInRange(currentPosition), historycalTest[currentPosition].answerOptions.isInRange(number) else {  return }
        historycalTest[currentPosition].answerOptions[number].lastYourCheck.toggle()
        
//        test.answerOptions[number].lastYourCheck = historycalTest[currentPosition].answerOptions[number].lastYourCheck
    }
    fileprivate func setOptionsParam(_ sortOptions: inout [Testownik.Answer]) {
        //let xx = currentHistory?.answerOptions[1].lastYourCheck
        guard let tmpOpt = currentHistory?.answerOptions else { return }
                for i in 0..<tmpOpt.count {
                    if sortOptions.isInRange(i) && tmpOpt.isInRange(i) {
                        sortOptions[i].lastYourCheck = tmpOpt[i].lastYourCheck
                    }
                }
        //sortOptions[1].lastYourCheck = currentHistory?.answerOptions[1].lastYourCheck
    }
    
    fileprivate func getCurrentTest() -> Test? {
        var test: Test?
        // FIXME: empty testList
        guard testList.isInRange(fileNumber) else { return nil }
        test = testList[fileNumber]
        guard isSortDisplay else {
            var tmpOptins =  test!.answerOptions
            setOptionsParam(&tmpOptins)
            test?.answerOptions = tmpOptins
            return test
        }
        if let options = test?.answerOptions {
            print("\(options)")
            if let sortKey = currentHistory?.keySort,  test != nil {  //options.createSortKey()
                var sortOptions = options.sortArray(forUserKey: sortKey)
                setOptionsParam(&sortOptions)
                test!.answerOptions = sortOptions
                print("\(sortOptions)")
            }
        }
        return test
    }
    fileprivate func setCurrenTest(forNewValue newValue: Test?) {
        guard testList.isInRange(fileNumber) else { return  }
        if var test = newValue {
            guard isSortDisplay else {
                testList[fileNumber] = test
                return
            }
            var options = test.answerOptions
//            options[1].lastYourCheck = true  //aTest.answerOptions[0].lastYourCheck = true
//            options[1].lastYourCheck = true
//            options[0].lastYourCheck = true
            if historycalTest.isInRange(currentPosition) {
                var curTmp =  historycalTest[currentPosition]
                if curTmp.keySort.isEmpty {
                    curTmp.keySort = options.createSortKey()
                }
            }
            if historycalTest.isInRange(currentPosition) {
                let sortKey = historycalTest[currentPosition].keySort
                if sortKey.isNotEmpty() {
                    let sortOptions = options.reversSortArray(forUserKey: sortKey)
                    test.answerOptions = sortOptions
                }
            }
            testList[fileNumber] = test
            setHistoryAnswers(forOptions: options)
        }
    }
    fileprivate func setHistoryAnswers(forOptions options: [Testownik.Answer]) {
        var isCorect = true
        let youAnswerArr = options.map({ $0.lastYourCheck ? 1 : 0 })
        let isOkArr = options.map({$0.isOK ? 1 : 0 })
        for i in 0..<options.count {
            if youAnswerArr[i] != isOkArr[i]  {
                isCorect = false
                break
            }
        }
        let oneWasSelected = youAnswerArr.reduce(0) { $0 + $1 } > 0 ? true : false
        guard historycalTest.isInRange(currentPosition) else { return }
        historycalTest[currentPosition].isCorect = isCorect
        historycalTest[currentPosition].oneWasSelected = oneWasSelected            
    }
    func getSelectedOption(forOptionNumber number: Int) -> AnswerShort? {
        guard let options = currentHistory?.answerOptions, options.isInRange(number) else { return nil }
        return options[number]        
    }
    func first() {
        if historycalTest.isEmpty {
            fillHistorycal()
            //fillHistorycal(forSeveralTimes: 2)
        }
        if historycalTest.isNotEmpty() {
            self.fileNumber = historycalTest.first!.fileNumber
            //self.delegate?.refreshView()
        }
        self.currentPosition = 0
    }
    func next() -> Bool  {
        self.finishedAdd = loteryTestBasket.isEmpty
        
        
        //historycalTest.removeElem { $0.fileNumber == 5 ? true : false }
        
        guard !(self.finishedAdd && historycalTest.isLast(currentPosition)) else { return false }
        let isNext = historycalTest.isExistNext(currentPosition)
        if isNext {
            self.fileNumber = readNext()
            self.currentPosition += 1
        } else {
            self.fileNumber = addNext()
            self.currentPosition = historycalTest.count - 1
        }        
        return true
    }
    func readNext() -> Int {
        guard historycalTest.isInRange(self.currentPosition + 1) else { return 0 }
        return historycalTest[self.currentPosition + 1].fileNumber
    }
    fileprivate func addSortedKey(toTest test: inout Manager.TestHistoryData) {
        let fileNumber = test.fileNumber
        if testList.isInRange(fileNumber) {
            let options = testList[fileNumber].answerOptions
            let keySort = options.createSortKey()
            let sortOption = options.sortArray(forUserKey: keySort)
            let isOkArray = sortOption.map({$0.isOK})
            let shortAnswer = AnswerShort(isOK: false, lastYourCheck: false)
            var aArr = [AnswerShort](repeating: shortAnswer, count: keySort.count)

            for i in 0..<aArr.count {
                aArr[i].isOK = isOkArray[i]
            }

            if keySort.isNotEmpty() {
                test.keySort = keySort
                test.answerOptions = aArr
            }
            for i in 0..<aArr.count {
                aArr[i].isOK = isOkArray[i]
            }
            test.answerOptions.append(contentsOf: aArr)
        }
    }
    fileprivate func addNext() -> Int {
        //var aTest: TestData
        guard loteryTestBasket.isNotEmpty() else { return 0 }
        if var aTest = getUniqueElement(forLastValue: self.fileNumber) {
            addSortedKey(toTest: &aTest)
            //MARK: todo
            aTest.answerOptions[1].lastYourCheck
            historycalTest.append(aTest)
            // MARK: TO DO delete
            loteryTestBasket.removeElem { elem in
                return elem.fileNumber == aTest.fileNumber ? true : false
            }
            return aTest.fileNumber
        }
        return 0
    }
    func getUniqueElement(forLastValue last: Int) -> TestHistoryData? {
        guard loteryTestBasket.isNotEmpty() else { return nil }
        if let aTest1 = loteryTestBasket.getRandomElement(deleteItAfter: false), aTest1.fileNumber != last  {
            self.fileNumber = aTest1.fileNumber
            print("RANDOM 1: \(aTest1.fileNumber)")
            return aTest1
        }
        if let aTest2 = loteryTestBasket.getRandomElement(deleteItAfter: false), aTest2.fileNumber != last  {
            self.fileNumber = aTest2.fileNumber
            print("RANDOM 2: \(aTest2.fileNumber)")
            return aTest2
        }
        if let aTest3 = loteryTestBasket.getRandomElement(deleteItAfter: false), aTest3.fileNumber != last  {
            self.fileNumber = aTest3.fileNumber
            print("RANDOM 3: \(aTest3.fileNumber)")
            return aTest3
        }
        if let aTest4 = loteryTestBasket.getRandomElement(deleteItAfter: false), aTest4.fileNumber != last  {
            self.fileNumber = aTest4.fileNumber
            print("RANDOM 4: \(aTest4.fileNumber)")
            return aTest4
        }
        return nil
    }
    func previous() {
        self.currentPosition -= self.currentPosition > 0 ? 1 : 0
        guard let aTest = historycalTest.getElement(forIndex: self.currentPosition, deleteItAfter: false) else { return }
        self.fileNumber = aTest.fileNumber
        //self.delegate?.refreshView()
    }
    func last() {
        if let aTest = historycalTest.last {
            self.fileNumber = aTest.fileNumber
        }
        self.currentPosition = historycalTest.count - 1
    }
    func fillTestList(forTestList testList : inout [Test]) {
        self.testList = testList
        if self.testList.isEmpty {
            print("testList IS EMPTY")
        }
    }
    func fillAllTestPull(testListCount: Int, forLiveValue lifeValue: Int, groupSize: Int = 5) {
        allTestPull.removeAll()
        for i in 0..<testListCount {
            let el = TestHistoryData(fileNumber: i, lifeValue: lifeValue)
            allTestPull.append(el)
        }
        allTestPull = allTestPull.sortFullArrayIntoGroups(forGroupLenth: groupSize)
    }
    func fillLoteryBasket() -> Bool {
        guard allTestPull.isNotEmpty() else { return false }
        if self.loteryTestBasket.isEmpty {
            let end = min(groupSize, allTestPull.count)
            guard end > 0 else { return  false }
            let moreTests = allTestPull[0..<end]
            loteryTestBasket.append(contentsOf: moreTests)
            for _ in 0..<moreTests.count {
                allTestPull.remove(at: 0)
            }
        }
         if loteryTestBasket.count < groupSize {  // 3,5,7             !    1,2
            let newLen = groupSize - loteryTestBasket.count
            for _ in 0..<newLen {
                if let oneTest = allTestPull.first {
                    loteryTestBasket.append(oneTest)
                    allTestPull.remove(at: 0)
                }
                else {
                    break
                }
            }
        }
        return true
    }
    func fillHistorycal(forSeveralTimes times: Int = 1) {
        for i in 1...times {
            if var aTest = loteryTestBasket.getRandomElement(deleteItAfter: true) {
                self.fileNumber = aTest.fileNumber
                addSortedKey(toTest: &aTest)
                historycalTest.append(aTest)
                if loteryTestBasket.count < self.groupSize {
                    if let elem = allTestPull.getFirsElement(deleteItAfter: true) {  //if let elem = allTestPull.first
                        loteryTestBasket.append(elem)
                    }
                }
            }
        }
    }
    // TODO: remove param
    func getFirst(onlyNewElement onlyNew: Bool = false)  -> TestHistoryData? {
        if historycalTest.isEmpty {
            return nil
        }
        else {
            return historycalTest.first
        }
    }
    func moveToFinished(forLoteryBasket index: Int) {
        guard loteryTestBasket.isInRange(index) else { return }
        let oneTest = loteryTestBasket[index]
        finishedTest.append(oneTest)
        loteryTestBasket.remove(at: index)
    }
    func removeElemFromHistory(forFileNumber fileNumber: Int) {
        var index = -1
        guard loteryTestBasket.isNotEmpty() else { return }
        let tmpArr = loteryTestBasket.map({$0.fileNumber})
        for i  in 0..<tmpArr.count {
            if tmpArr[i] == fileNumber {
                index = i
                break
            }
        }
        if index >= 0 {
            loteryTestBasket.remove(at: index)
        }
    }
//    func createSortedKey() -> [Int] {
//        return [0]
//    }
//    func reverseSortedKey(_ key: [Int]) -> [Int] {
//        return [0]
//    }
    func save() {
        
    }
    func restore() {
        
    }
}

