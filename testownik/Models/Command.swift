//
//  Command.swift
//  testownik
//
//  Created by Slawek Kurczewski on 15/10/2021.
//  Copyright © 2021 Slawomir Kurczewski. All rights reserved.
//

import Foundation
protocol CommandDelegate {
    func executeCommand(forCommand cmd: Command.CommandList)
}

class Command {
    
    enum CommandList: Int {
        case fullScreen = 0
        
        case one        = 1
        case two        = 2
        case three      = 3
        case four       = 4
        case five       = 5
        case six        = 6
        case seven      = 7
        case eight      = 8
        case nine       = 9
        case ten        = 10

        case left       = 11
        case righi      = 12
        case check      = 13
        case next       = 14
        case previous   = 15
        case start      = 16
        case end        = 17
        case exit       = 18
        case listen     = 19
        case readOn     = 20
        
        case reduceScr  = 21
        case incScreen  = 22
        case showResult = 23
        
        // last option for empty command
        case empty      = 24
    }
    var delegate: CommandDelegate? = nil
    
    var vocabularyEn = [[String]]()
    var vocabularyPl = [[String]]()
    
    var vocabularyGe = [[String]]()
    var vocabularyFr = [[String]]()
    var vocabularySp = [[String]]()

    init() {
//        let word0 = ["full Screen","wide screen"]
//        let word1 = ["one","first"]
        // MARK: Enlish vocabulary
        vocabularyEn .append(["full Screen","wide screen"])
        
        vocabularyEn .append(["one","first"])
        vocabularyEn .append(["two","second"])
        vocabularyEn .append(["three","third"])
        vocabularyEn .append(["four","fourth"])
        vocabularyEn .append(["five","fifth"])
        vocabularyEn .append(["six","sixth"])
        vocabularyEn .append(["seven","seventh"])
        vocabularyEn .append(["eight","eighth"])
        vocabularyEn .append(["nine","ninth"])
        vocabularyEn .append(["ten","tenth"])
        
        vocabularyEn .append(["left","Backwards","backwards","undo"])
        vocabularyEn .append(["righi","Forward","forward"])
        vocabularyEn .append(["check","let's check"])
        vocabularyEn .append(["next"])
        vocabularyEn .append(["previous","former","foregoing"])
        vocabularyEn .append(["start","beginning"])
        vocabularyEn .append(["end","last","late"])
        vocabularyEn .append(["exit","termination","finish","turn off","disconnection"])
        vocabularyEn .append(["listen","listening"])
        vocabularyEn .append(["read","reading","speech","speak","Say","powiedzieć"])
        
        vocabularyEn .append(["increment screen","enlarge the screen","increase the screen","widen the screen"])
        vocabularyEn .append(["reduce the screen"])
        vocabularyEn .append(["show result"])
 
        // MARK: Polish vocabulary
        vocabularyPl .append(["pełny ekran"])        //,"powiększ ekran","poszeż ekran"])
        
        vocabularyPl .append(["jeden","first"])
        vocabularyPl .append(["dwa","second"])
        vocabularyPl .append(["trzy","third"])
        vocabularyPl .append(["cztery","fourth"])
        vocabularyPl .append(["pięć","fifth"])
        vocabularyPl .append(["sześć","sixth"])
        vocabularyPl .append(["siedem","seventh"])
        vocabularyPl .append(["osiem","eighth"])
        vocabularyPl .append(["dziewięć","ninth"])
        vocabularyPl .append(["dziesięć","tenth"])
        
        vocabularyPl .append(["lewo","Backwards","backwards","undo"])
        vocabularyPl .append(["prawo","Forward","forward"])
        vocabularyPl .append(["sprawdź","let's check"])
        vocabularyPl .append(["następne","następny","następna","kolejne","kolejna","kolejny","dalej"])
        vocabularyPl .append(["poprzedni","poprzednia","poprzednie","cofnij"])
        vocabularyPl .append(["start","początek"])
        vocabularyPl .append(["koniec","ostatni","ostatnia","ostatnie"])
        vocabularyPl .append(["wyjście","zakończenie"])
        vocabularyPl .append(["słuchaj","słuchanie"])
        vocabularyPl .append(["czytaj","czytanie","mowa","mówienie","powiedz"])
        
        vocabularyPl .append(["powiększ ekran","poszeż ekran","zwiększ ekran"])
        vocabularyEn .append(["zmniejsz ekran","pomniejsz ekran"])
        vocabularyPl .append(["wyniki","ocena","pokaż wynik","pokaż wyniki","ile punktów","ocena"])
 
        // MARK: German vocabulary
        // MARK: French vocabulary
        // MARK: Spanish vocabulary
    }
    
    func findCommand(forText searchText: String) -> CommandList? {
        var returnVal: CommandList? = nil
        
        for i in 0..<CommandList.empty.rawValue-1 {
            let tmpArr = vocabularyPl[i]
            for name in tmpArr {
                if findText(forText: searchText, patern: name) {
                    returnVal = CommandList(rawValue: i)
                    break
                }
            }
        }
        if let _ = returnVal {
            //delegate?.executeCommand(forCommand: cmd)
            delegate?.executeCommand(forCommand: .five)
        }
        return returnVal
    }
    func findText(forText searchText: String, patern: String)  -> Bool {
        return (searchText.range(of: patern) == nil ? false : true)
    }
        
        
    
}
//enum LanguaesList: String {
//    case enlish     = "en"
//    case english_US = "en-US"

//        return (searchText == patern)
//        let string = "hello Swift"
//        if string.contains("Swift") {
//            print("exists")
//        }
