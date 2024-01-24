//
//  Testownik.swift
//  testownik
//
//  Created by Slawek Kurczewski on 26/02/2020.
//  Copyright © 2020 Slawomir Kurczewski. All rights reserved.
//

import UIKit
//import  CoreData 

protocol TestownikDelegate {
    //func refreshButtonUI(forFilePosition filePosition: TestToDo.FilePosition)
    func refreshTabbarUI(visableLevel: Int)
//    func refreshButtonUI(forFilePosition: TestManager.FilePosition)
//    func refreshContent(forCurrentTest test: Test)
    //    func allTestDone()
    //    func progress()
    //    func refreshFilePosition(newFilePosition filePosition: TestToDo.FilePosition)
}
protocol TestownikDataSource {
    var delegate: TestownikDelegate? { get }
    var rawTestList: [Int] { get }
    var manager: Manager? { get }
    func getCurrent() -> Test
}
class Testownik: DataOperations, TestownikDataSource {
    var manager: Manager?
    
    struct Answer {
            let isOK: Bool
            let answerOption: String
            var lastYourCheck: Bool = false
    }

    var delegate: TestownikDelegate?
    //var viewContext: TestownikViewController? = nil
    var rawTestList = [Int]()
    var isChanged = false
    //var testToDo: TestToDo?
    
    var filePosition: Manager.FilePosition  {
        get
        {
//                    // delegate?.refreshButtonUI(forFilePosition: filePosition)
//                    return testManager?.filePosition ?? TestManager.FilePosition.first
                    return manager?.curFilePos ?? .first
                }}
    override var currentTestNumber: Int  {
        didSet {
//            print("currentTest:\(oldValue),\(currentTest), testownik.testManager ?.currentPosition=\(testManager?.currentPosition ?? 77), testownik.currentTest=\(currentTest), \(filePosition) ")
            // TODO: ???
            //delegate?.refreshButtonUI(forFilePosition: filePosition)
            // currentRow = currentTest < count ? currentTest : count-1
        }
    }
    var visableLevel: Int = 4 {
        didSet {
            // TODO: ????
            delegate?.refreshTabbarUI(visableLevel: visableLevel)
            print("Visable Level:\(visableLevel)")
        }
    }
    //var test: Test? = nil
//    var currentElement: Test? = nil
//    {
//        get {
//            let pos = testManager?.currentPosition
//            print("P   O   S  I  T  I  O  N : \(pos)")
//            return    testList[pos ?? 0]
//        }
//    }
    //var chooseOpions: [Bool] = [Bool](repeating: false, count: 10)
//    subscript(index: Int)  -> Test? {
//        guard index < testList.count else {  return nil   }
//        return testList[index]
//    }
    
    // MARK: Init Testownik class
    override init() {
        super.init()
        print("init sss")
        initNewTestlist()
    }
    func initNewTestlist() {
        database.selectedTestTable.loadData()
        guard database.selectedTestTable.isNotEmpty else {  return  }
        if let uuId = database.selectedTestTable[0]?.uuId {
            database.testDescriptionTable.loadData(forUuid: "uuid_parent", fieldValue: uuId)
            let elemCount = database.testDescriptionTable.count
            // TODO: DELETE
 //           self.testManager = TestManager(elemCount, maxValueLive: 2)
            
            self.manager = Manager(elemCount, maxValueLive: 2, groupSize: 5)
            fillDataDbToTestList()
            self.manager?.fillTestList(forTestList: &self.testList)
            
            print("self.testList.count=\(self.testList.count)")
            print("self.manager.testList.count=\(self.manager?.testList.count)")
         }
    }
    func createTestToDo() {
//        let number = database.testDescriptionTable.count
//        var  rawTestList = [Int]()
//        for i in 0..<number  { // self.testList.count
//            rawTestList.append(i)
//        }
//        self.rawTestList = rawTestList
//        //self.testToDo = TestToDo(rawTestList: self.rawTestList)
    }
    // MARK: Perform protocol TestToDoDelegate
//    func getCurrentTest(forFileNumber number: Int) -> Test? {
//        if  let number = testToDo?.getFirst()?.fileNumber {
//            self.currentTest = number
//            return self.getCurrent()
//        }
//        return nil
//    }
//    func refreshFilePosition(newFilePosition filePosition: TestToDo.FilePosition) {
//        delegate?.refreshButtonUI(forFilePosition: filePosition)
//    }
//    func allTestDone() {
//        
//    }    
//    func progress() {
//
//    }
    // MARK: Metod for navigation
    override func getCurrent() -> Test {        
//        self.currentTest = testManager?.getCurrentRawTest()?.fileNumber ?? 0
        return super.getCurrent()
    }
    override func first() {
        self.manager?.first()
        //self.test = manager?.currentTest
        print("first NUMER:   \(manager?.fileNumber)")
    }
    override func next() {
        self.manager?.next()
        //self.test = manager?.currentTest
        print("next NUMER:   \(manager?.fileNumber)")
    }
    override func previous() {
        self.manager?.previous()
        print("previous NUMER:   \(manager?.fileNumber)")
   }
    override func last() {
        self.manager?.last()
        print("last NUMER:   \(manager?.fileNumber)")
    }

    // MARK: Perform protocol TestownikDelegate
    func refreshData() {
        //self.loadTestFromDatabase()
        self.fillDataDbToTestList()
        self.manager?.fillTestList(forTestList: &testList)
        
        // TODO: check this
        //self.currentTest = 0
        self.isChanged = true
    }
    
    
    // MARK: Methods for Testownik database
    func loadTestFromDatabase() {
    //    database.selectedTestTable.loadData()
        //print("\nselectedTestTable.coun = \(database.selectedTestTable.count)")
        guard database.selectedTestTable.count > 0 else {   return     }
        //if  let selectedUuid = database.selectedTestTable[0]?.toAllRelationship?.uuId {
        if  let selectedUuid = database.selectedTestTable[0]?.uuId {
            database.testDescriptionTable.loadData(forUuid: "uuid_parent", fieldValue: selectedUuid)
            if database.testDescriptionTable.count > 0 {
                print("file_name:\(String(describing: database.testDescriptionTable[0]?.file_name))")
                print("TEXT:\(String(describing: database.testDescriptionTable[0]?.text))")
                
                // TODO: clear data
                let txtVal = getTextDb666(txt: database.testDescriptionTable[0]?.text ?? " ")
                if  txtVal.count < 3 {
                    print("Pusty rekord")
                    self.clearData()
                }
                else    {
                    print("Pełny rekord")
                    fillDataDbToTestList()
                    // MARK: INITIAL
//                    let xxxx = testToDo?.mainTests
//                    let yyy = testToDo?.mainTests.first
//                    let zzz = testToDo?.currentPosition
//                    let bbb = testToDo?[0]
//                    let ddd = testToDo?.getCurrentRawTest()?.fileNumber
//                    let aaa = testToDo?.extraTests
                }
                //currentTest = testToDo?.getCurrent()?.fileNumber
            }
            // MARK: INTTIAL
        }
    }
// MARK: fillDataDb
    func fillDataDbToTestList() {
        var titles = [String]()
        var textLines = [String]()
        var pict: UIImage? = nil
        print("database.testDescriptionTable.count fillDataDb:\(database.testDescriptionTable.count)")
        print("testownik.count befor:\(self.count)")
        self.testList.removeAll()
        
        database.testDescriptionTable.forEach { (index, testRecord) in
            if let txt = testRecord?.text, !txt.isEmpty {
                titles.removeAll()
                pict = nil
                //=========>
                textLines = getTextDb666(txt: txt)
                guard textLines.count > 2 else {    return     }
                for i in 2..<textLines.count {
                    if !textLines[i].isEmpty  {    titles.append(textLines[i])      }
                }
                let isOk = getAnswer(textLines[0])
                let answerOptions = fillOneTestAnswers(isOk: isOk, titles: titles)
                let sortedAnswerOptions = changeOrder(forAnswerOptions: answerOptions)
                let fileName = testRecord?.file_name?.components(separatedBy: ".")[0] ?? ""
                if let pictData = testRecord?.picture {
                    pict = UIImage(data: pictData)
                }
                let test = Test(code: textLines[0], ask: textLines[1], pict: pict, answerOptions: sortedAnswerOptions, youAnswers5: [], fileName: fileName)
                self.testList.append(test)
            }
        }
        // TODO:  comment here
        print("testownik.count after:\(self.count)")
}
    func fillDemoData() {
        
    }
    func readPicture() -> UIImage {
        let list = ["001.png","002.png","003.png","004.png"]
        let position = Setup.randomOrder(toMax: 3)
        return UIImage(named: list[position])!
    }
    func changeOrder(forAnswerOptions answerOptions: [Answer]) -> [Answer] {
        var position = 0
        var sortedAnswerOptions = [Answer]()
        var srcAnswerOptions = answerOptions
        for _ in 1...srcAnswerOptions.count {
            position = Setup.randomOrder(toMax: srcAnswerOptions.count)
            sortedAnswerOptions.append(srcAnswerOptions[position])
            srcAnswerOptions.remove(at: position)
        }
        return sortedAnswerOptions
        //Setup.changeArryyOrder(forArray: srcAnswerOptions, fromPosition: 0, count: srcAnswerOptions.count)
    }
    func fillOneTestAnswers(isOk: [Bool], titles: [String]) -> [Answer] {
        var answerOptions: [Answer] = []
        let lenght = isOk.count < titles.count ? isOk.count : titles.count
        for i in 0..<lenght {
            answerOptions.append(Answer(isOK: isOk[i], answerOption: titles[i]))
        }
        return answerOptions
    }
    func isAllAnswersOk() -> Bool {
        var retValue = true
        for (key, value) in testList[currentTestNumber].answerOptions.enumerated() {
            if value.lastYourCheck != value.isOK {
                retValue = false
                break
            }
        }
//        if  selectedOption < testList[currentTest].answerOptions.count {
//            value = testList[currentTest].answerOptions[selectedOption].isOK
//        }
        return retValue
    }
    func switchYourAnsfer(selectedOptionForTest optionNumber: Int)     {
        // MARK: to do switchYourAnsfer
        testownik.manager?.changeAnswer(forNumberOption: optionNumber)
        
        
        
 //       var value: Bool = false
//        guard let option = testownik.manager?.currentTest?.answerOptions, option.isInRange(optionNumber) else { return }
//        let yourCheck = option[optionNumber].lastYourCheck
                
//        if  selectedOption < testList[currentTestNumber].answerOptions.count {
//            value = testList[currentTestNumber].answerOptions[selectedOption].lastYourCheck
//            value.toggle()
//            testList[currentTestNumber].answerOptions[selectedOption].lastYourCheck = value
//        }
    }
    func findValue<T: Comparable>(currentList: [T], valueToFind: T) -> Int {
        var found = -1
        for i in 0..<currentList.count {
            if (currentList[i] == valueToFind)  {   found = i     }
        }
        return found
    }
//    func teeest() {
//        createStartedTest(forLanguage: .enlish)
//        createStartedTest(forLanguage: .polish)
//        
//        createStartedTest(forLanguage: .spanish)
//        createStartedTest(forLanguage: .french)
//        createStartedTest(forLanguage: .german)
//    }



    func saveData() {
        //database.allTestsTable.deleteAll()
        //database.testDescriptionTable.deleteAll()
        let uuid = UUID()
        let context = database.context
        let allTestRecord = AllTestEntity(context: context)
    }
     func getText(fileName: String, encodingSystem encoding: String.Encoding = .utf8) -> [String] {  //windowsCP1250
        var texts: [String] = ["brak danych"]
        var encodingType: String.Encoding = .utf8
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
            do {
                let yy = "DDDD"
                let xxx = try String(contentsOfFile: path ,usedEncoding: &encodingType)
                print(("encoding:\(encodingType.rawValue)"))
                let data = try String(contentsOfFile: path ,encoding: encoding)
                let myStrings = data.components(separatedBy: .newlines)
                texts = myStrings
                print("text-Cs:\(texts)")
            }
            catch {
                print("ENCODE:\(encodingType)")
                print(error.localizedDescription)
            }
        }
         else {
             print("Error path:\(fileName)")
         }
        return texts
    }
    func testOtherCodePageFile() {
        var texts: [String] = ["brak danych"]
        var xxx: String.Encoding = .iso2022JP
        
        print("\npoczatek A:\(xxx.rawValue),(xxx)")
        xxx = .windowsCP1250
        print("\npoczatek B:\(xxx.rawValue),(xxx)")
        
        for i in 1..<15 {
            xxx.rawValue = UInt(i)
            print("\n\(i):\(xxx.description)")
        }
        if Bundle.main.path(forResource: "newFile", ofType: "txt") != nil {
//            for i in 0..<20 {
//                xxx.rawValue = UInt(i)
//                if let str = giveCodepaeText(contentsOfFile: path, encoding: xxx) {
//                    texts = str.components(separatedBy: .newlines)
//                    print("text-Cs B:\(xxx.rawValue),\(texts)")
//                    //break
//                }
            }
        }
    
    func giveCodepaeText(contentsOfFile: String ,encoding: String.Encoding) -> String? {
        //var retVal: String?

        do {
            print("contentsOfFile:\(contentsOfFile)")
            print(("encoding:\(encoding.rawValue),file:\(contentsOfFile),\(encoding.description)"))
            let str = try String(contentsOfFile: contentsOfFile ,encoding: encoding)
            print(("\nstr:\(str)\n"))
            return str
        }
        catch {
//            print(error.localizedDescription)
//            print("blad:\(contentsOfFile)")
            print("KKKK:\(encoding.hashValue),\(encoding.description)")
              return nil
        }
    }
    //==========================
    func giveCodepaeText2(contentsOfFile: String ,encoding: String.Encoding) -> String? {
        return "brak"
    }
    func getTextDb666(txt: String, encodingSystem encoding: String.Encoding = .utf8) -> [String]  {
        var texts: [String] = ["brak danych"]
        var outputTxt: [String] = [String]()
        outputTxt.removeAll()
        texts = txt.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
        //print("texts:\(texts)")
        for i in 0..<texts.count  {
            if !texts[i].isEmpty {
                outputTxt.append(texts[i].trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        return outputTxt
    }

    func getAnswer(_ codeAnswer: String) -> [Bool] {
        var answer = [Bool]()
        let myLenght=codeAnswer.count
        //print("myLenght:\(myLenght)")
        for i in 1..<myLenght {
            answer.append(codeAnswer.suffix(codeAnswer.count)[i]=="1" ? true : false)
        }
        //print("answer,\(answer)")
        return answer
    }
    func xcts_random(size: Int, forCount number: Int = 1000) {
        var statisticArray: [Int] = [Int](repeating: 0, count: size+1)
        for _ in 0..<number {
            let val = Setup.randomOrder(toMax: size)
            print(val)
            statisticArray[val] += 1
        }
    print("Arr=\(statisticArray)")
    }
    
//    func frstRandom(repeat: Bool) -> Test?   {
//        return nil
//    }
//    func nextRandom(repeat: Bool) -> Test?  {
//        return nil
//    }
//    func previousRandom(repeat: Bool) -> Test?  {
//        return nil
//    }
//    func lastRandom(repeat: Bool) -> Test?  {
//        return nil
//    }    
    

}



//        let xxx = "first\nsecond\nferd"
//        let z = xxx.split(separator: "\n")
//        let cc = xxx.data(using: String.Encoding.utf8)
//        let dd = xxx.data(using: String.Encoding.windowsCP1250)
//        var ff = Data(base64Encoded: xxx)
//        print("ccc:\(String(describing: cc))")
//        print("ccc:\(String(describing: dd))")
//
//        let ttt =  xxx.components(separatedBy: .newlines)
//        print("ttt:\(ttt)")




//    func getCodePageText(pathToFile path: String, encodingSystem encoding: String.Encoding = .ascii) -> [String] {
//        return getCodePgTxt(path: path, encodingSystem: encoding)
//    }
//    func getCodePageText(fileName: String, encodingSystem encoding: String.Encoding = .ascii) -> [String] {
//        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
//            return getCodePgTxt(path: path, encodingSystem: encoding)
//        }
//        else {
//            return  [String]()
//        }
//    }
//    private func getCodePgTxt(path: String, encodingSystem encoding: String.Encoding = .ascii) -> [String] {
//        let encodingList: [String.Encoding] = [String.Encoding.utf8, .windowsCP1250, .windowsCP1251, .windowsCP1252, .windowsCP1253, .windowsCP1254, .isoLatin2, .isoLatin1, .ascii, .nonLossyASCII, .unicode, .macOSRoman, .utf16 ]
//        var encodingType: String.Encoding = encoding
//        var texts: [String] = ["brak danych"]
//
//        print("first encoding:\(encodingType.description),\(encodingType.rawValue)")
////        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
//        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//                if let codePage = checkCodePageId(path: path) {
//                    do {
//                        let str1 = try String(contentsOfFile: path ,encoding: codePage)
//                        let myStrings = str1.components(separatedBy: .newlines)
//                        texts = myStrings
//                        print("text-Cs A:\(codePage.description)")
//                        print("\n,\(texts)")
//                    }
//                    catch {
//                        for i in 0..<encodingList.count {
//                            if let str2 = giveCodepaeText(contentsOfFile: path, encoding: encodingList[i]) {
//                                texts = str2.components(separatedBy: .newlines)
//                                print("text-Cs B:\(encodingList[i].description)")
//                                print("\n,\(texts)")
//                                break
//                            }
//                        }
//                    }
//            }
//            else {
//                for i in 0..<encodingList.count {
//                    if let str2 = giveCodepaeText(contentsOfFile: path, encoding: encodingList[i]) {
//                        texts = str2.components(separatedBy: .newlines)
//                        print("text-Cs C:\(encodingList[i].description)")
//                        print("\n,\(texts)")
//                        break
//                    }
//                }
//            }
//        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
////        }
////        else {
////            print("removeAll")
////            texts.removeAll()
////        }
//    return  texts
//    }
//    func checkCodePageId(path: String )  -> String.Encoding? {
//        var encodingType: String.Encoding = .utf8
//
//        do {
//            let str = try String(contentsOfFile: path ,usedEncoding: &encodingType)
//            print(("encoding:\(encodingType.rawValue),\(encodingType.description)\nstr:\(str)\n"))
//
//            print("encoding Type:\(encodingType.description),\(encodingType.rawValue)")
//            return encodingType
//        }
//        catch {
//            return nil
//        }
//    }





//=================
//            catch {
//                print("ENCODE:\(encodingType),\(encodingType.rawValue)")
//                print(error.localizedDescription)
//                do {
//
//                }
//                catch {
//                    do {
//                        let str2 = try String(contentsOfFile: path ,encoding: encodingList[3])
//                        let myStrings = str2.components(separatedBy: .newlines)
//                        texts = myStrings
//                        print("text-Cs druie:\(texts)")
//                    }
//                    catch {
//                        print("eeeerrrrrooorr")
//                    }
//                }
//            }


//        var encodingType: String.Encoding = .utf8
//        let file = "001.txt"
//        //var str = ""
//        let url = URL(fileURLWithPath: "http://www.wp.pl")
//
//        do {
////            let str1 = try String(contentsOf: url, usedEncoding: &encodingType)
////            print("Used for encoding url \(url.absoluteString) - \(str1): \(encodingType)")
//            print("file:\(fileName)")
//            let str2 = try String(contentsOfFile: fileName, usedEncoding: &encodingType)
//            print("Used for encoding string \(str2): \(encodingType)")
//        } catch {
//            print("XXXXXXX:AAAA")
//
//        }

//        do {
//        let xx = String(contentsOf: <#T##URL#>, usedEncoding: &T##String.Encoding)
//
//        }
    
//        do {
//            let str = try String(contentsOf: url, usedEncoding: &encodingType)
//            print("Used for encoding: \(encodingType)")
//        } catch {
//            do {
//                let str = try String(contentsOf: url, encoding: .utf8)
//                print("Used for encoding: UTF-8")
//            } catch {
//                do {
//                    let str = try String(contentsOf: url, encoding: .isoLatin1)
//                    print("Used for encoding: Windows Latin 1")
//                } catch {
//                    // Error handling
//                }
//            }
//        }

