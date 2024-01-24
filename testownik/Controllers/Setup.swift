//
//  Setup.swift
//  SwiftyDocPicker
//
//  Created by Slawek Kurczewski on 05/03/2020.
//  Copyright © 2020 Abraham Mangona. All rights reserved.
//

import UIKit
import SSZipArchive

class Setup {
    // MARK: Typedef
    enum LanguaesList: String {
        case enlish     = "en"
//        case english_US = "en-US"
//        case english_GB = "en-GB"
        case polish     = "pl"
        case german     = "de"
        case french     = "fr" //_FR"
        case spanish    = "es" //_ES"
    }
    enum PopViewType: Int {
        case toast       = 0
        case popUp       = 1
        case popUpStrong = 2
        case popUpBlink  = 3
    }
    struct PopupStrongParams {
        var tag = 2021
        var lines: Int = 6
        var height: CGFloat = 200
        var font = UIFont.systemFont(ofSize: 20)
        var frame: CGRect? = nil
    }
    struct PopUpBlinkParams {
        var tag = 2022
        var lines: Int = 6
        var height: CGFloat = 200
        var duration = 4.0
        var delay = 8.0
        var font = UIFont.systemFont(ofSize: 20)
        var frame: CGRect? = nil
    }
    // MARK: variables
    private static let backgroundColorsDefault: [UIColor] = [UIColor.systemYellow.withAlphaComponent(0.6), UIColor.lightGray, UIColor.systemBlue, UIColor.systemGreen]
    private static let textColorsDefault: [UIColor] = [.white, .white, .white, .black]
    private static var backgroundColorList =  backgroundColorsDefault
    private static var textColorList = textColorsDefault
    
    static let defaultMainGroupSize = 30
    static let defaultReapeadTest = 5
    
    static var popUpStrong: PopupStrongParams = PopupStrongParams()
    static var popUpBlink: PopUpBlinkParams = PopUpBlinkParams()
    static var cloudPicker: CloudPicker!
    static var animationEnded = true
    static var isNumericQuestions = false
    static var currentAligmentButton: UIControl.ContentHorizontalAlignment = .center
    static let askNumber = ["1️⃣","2️⃣","3️⃣","4️⃣","5️⃣","6️⃣","7️⃣","8️⃣","9️⃣","🔟"]
    static let allLanguages: [String : LanguaesList] = ["en": .enlish, "pl": .polish, "de": .german, "fr": .french, "es": .spanish]
    static var tempStr: String  = ""
    static var currentLanguage: LanguaesList  = .german
    {
        didSet {
            if oldValue != currentLanguage {
                languageChange()
            }
        }
    }
    static var manualName: String {
        get {
            switch currentLanguage {
            case .enlish     : tempStr = "Introduction to the program."
//            case .english_US : tempStr = "Introduction to the program."
//            case .english_GB : tempStr = "Introduction to the program."
            case .polish     : tempStr = "Wprowadzenie do programu."
            case .german     : tempStr = "Einführung in das Programm."
            case .french     : tempStr = "Présentation du programme."
            case .spanish    : tempStr = "Introducción al programa."
            }
        return tempStr
        }
    }
    static var  placeHolderRatings: String { get {
        switch currentLanguage {
        case .enlish     : tempStr = "Rating"
        case .polish     : tempStr = "Ocena"
        case .german     : tempStr = "Bewertung"
        case .french     : tempStr = "Notation"
        case .spanish    : tempStr = "Clasificación"
        }
        return tempStr }
    }
    static var placeHolderButtons: String { get {
        switch currentLanguage {
            case .enlish     : tempStr = "Question"
//            case .english_US : tempStr = "Question"
//            case .english_GB : tempStr = "Question"
            case .polish     : tempStr = "Pytanie"
            case .german     : tempStr = "Frage"
            case .french     : tempStr = "Question"
            case .spanish    : tempStr = "Pregunta"
        }
        return tempStr }
    }
    static var placeHolderTitle: String  { get {
        switch currentLanguage {
            case .enlish     : tempStr = "You don't have selected test. Add new test in search option."
//            case .english_US : tempStr = "You don't have selected test. Add new test in search option."
//            case .english_GB : tempStr = "You don't have selected test. Add new test in search option."
            case .polish     : tempStr = "Nie wybrałeś testu. Dodaj nowy test w opcji wyszukiwania."
            case .german     : tempStr = "Sie haben keinen Test ausgewählt. Neuen Test in Suchoption hinzufügen."
            case .french     : tempStr = "Vous n'avez pas sélectionné de test. Ajouter un nouveau test dans l'option de recherche."
            case .spanish    : tempStr = "No ha seleccionado la prueba. Agregue una nueva prueba en la opción de búsqueda."
        }
        return tempStr }
    }
    static var placeHolderDeleteTest: String { get {
        switch currentLanguage {
            case .enlish     : tempStr = "Do you want to delete all the tests ?"
//            case .english_US : tempStr = "Do you want to delete all the tests ?"
//            case .english_GB : tempStr = "Do you want to delete all the tests ?"
            case .polish     : tempStr = "Czy chcesz usunąć wszystkie testy ?"
            case .german     : tempStr = "Möchten Sie alle Tests löschen ?"
            case .french     : tempStr = "Voulez-vous supprimer tous les tests ?"
            case .spanish    : tempStr = "Quieres borrar todas las pruebas ?"
        }
        return tempStr
    }}
    
   
    // MARK: Static methods
    class func initValue() {
        let currLang = Settings.shared.getValue(stringForKey: .language_key)
        if currLang.count == 0 {
            if let selLanguage = Locale.preferredLanguages.first?.components(separatedBy: "-").first {
                let xx = Setup.allLanguages[selLanguage]
                Setup.currentLanguage = xx ?? .enlish //.german
                print("xx:\(xx)")
                print("Setup.currentLanguage:\(Setup.currentLanguage)")
                
                //Setup.LanguaesList.RawValue("pl")
            }
        }
    }
    class func languageChange() {
        let newVal = self.currentLanguage.rawValue
        Settings.shared.setValue(forKey: .language_key, newStringValue: newVal)
        print("zmiana jezyka na \(newVal)")
        //let newVal = Settings.LanguageEnum.english.rawValue
    }
    class func randomOrder(toMax: Int) -> Int {
        // For toMax = 10 get from 0 to 9
        return Int(arc4random_uniform(UInt32(toMax)))
        //Int.random(in: 1...3)
    }

    class func getNumericPict(number: Int) -> String {
        guard number < 10 else { return ""}
        return (isNumericQuestions ? " "+askNumber[number]+" " : "")
    }
    class func findValue<T: Comparable>(currentList: [T], valueToFind: T, handler: (_ currElem: T) -> Bool) -> Bool {
        var found = false
        // TODO: Finalize method
        for i in 0..<currentList.count {
            if currentList[i] == valueToFind { found = true}
        }
        return found
    }
    class func setTextColor(forToastType type: Setup.PopViewType,  textColor: UIColor? = nil) {
        if let textColor = textColor {            textColorList[type.rawValue] = textColor        }
        else {     textColorList[type.rawValue] = textColorsDefault[type.rawValue]        }
    }
    class func setBackgroundColor(forToastType type: Setup.PopViewType, backgroundColor: UIColor? = nil) {
        if let backgroundColor = backgroundColor {            backgroundColorList[type.rawValue] = backgroundColor        }
        else {            backgroundColorList[type.rawValue] = backgroundColorsDefault[type.rawValue]        }
    }
    class func setColor(forToastType type: Setup.PopViewType, backgroundColor: UIColor?, textColor: UIColor? = UIColor.black) {
        if let textColor = textColor {
            textColorList[type.rawValue] = textColor        }
        if let backgroundColor = backgroundColor {
            backgroundColorList[type.rawValue] = backgroundColor        }
    }
    class func displayToast(forController controller: UIViewController, message: String, seconds delay: Double)  {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        animationEnded = false
        alert.view.backgroundColor = backgroundColorList[PopViewType.toast.rawValue]
        alert.view.alpha = 0.3
        alert.view.layer.cornerRadius = 10
        alert.view.clipsToBounds = true
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            animationEnded = true
            alert.dismiss(animated: true)
        }
    }
    class func displayToast(forView view: UIView, message : String, seconds delay: Double) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 75, y: view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor =  backgroundColorList[PopViewType.toast.rawValue]
        toastLabel.textColor = textColorList[PopViewType.toast.rawValue]
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        animationEnded = false
        UIView.animate(withDuration: 5, delay: 11, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.2
        }, completion: {(isCompleted) in
            animationEnded = true
            toastLabel.removeFromSuperview()
            })
    }
    class func popUp(context ctx: UIViewController, msg: String, height: CGFloat = 100) {
        let toast = UILabel(frame:  CGRect(x: 16, y: ctx.view.frame.size.height / 2, width: ctx.view.frame.size.width - 32, height: height))
        toast.backgroundColor =  backgroundColorList[PopViewType.popUp.rawValue]
        toast.textColor =  textColorList[PopViewType.popUp.rawValue]
        toast.textAlignment = .center;
        toast.numberOfLines = 3
        toast.font = UIFont.systemFont(ofSize: 20)
        toast.layer.cornerRadius = 12;
        toast.clipsToBounds  =  true
        toast.text = msg
        animationEnded = false
        ctx.view.addSubview(toast)
        
        UIView.animate(withDuration: 15.0, delay: 0.2,
            options: .curveEaseOut,  animations: {
            toast.alpha = 0.0
            }, completion: {(isCompleted) in
                animationEnded = true
                toast.removeFromSuperview()
        })
    }
    class func popUpStrong(context ctx: UIViewController, msg: String, numberLines lines: Int = popUpStrong.lines, height: CGFloat = popUpStrong.height)  -> UILabel   {
        let frame = CGRect(x: 16, y: ctx.view.frame.size.height / 2, width: ctx.view.frame.size.width - 32, height: height)
        if Setup.popUpStrong.frame == nil {
            Setup.popUpStrong.frame = frame
        }
        let toast = UILabel(frame: Setup.popUpStrong.frame!)

        toast.backgroundColor = backgroundColorList[PopViewType.popUpStrong.rawValue]
        toast.textColor = textColorList[PopViewType.popUpStrong.rawValue]
        toast.textAlignment = .center;
        toast.numberOfLines = lines
        toast.font = popUpStrong.font
        toast.layer.cornerRadius = 12;
        toast.clipsToBounds  =  true
        toast.isUserInteractionEnabled = true
        toast.tag = popUpStrong.tag
        ctx.view.addSubview(toast)
        toast.text = msg
        animationEnded = false
        ctx.view.addSubview(toast)
        
      return toast
    }
    class func popUpBlink(context ctx: UIViewController, msg: String, numberLines lines: Int =  popUpBlink.lines, height: CGFloat = popUpBlink.height, completionFinish: @escaping () -> Void) {
        let toast = UILabel(frame:
            CGRect(x: 16, y: ctx.view.frame.size.height / 2,
                   width: ctx.view.frame.size.width - 32, height: height))
        
        toast.backgroundColor =  backgroundColorList[PopViewType.popUpBlink.rawValue]
        toast.textColor =  textColorList[PopViewType.popUpBlink.rawValue]      
        toast.textAlignment = .center;
        toast.numberOfLines = lines
        toast.font = popUpBlink.font  //UIFont.systemFont(ofSize: 20)
        toast.layer.cornerRadius = 12;
        toast.clipsToBounds  =  true
        toast.text = msg
        
        //gestures.addTapGestureToView(forView: toast, touchNumber: 1)
        animationEnded = false
        ctx.view.addSubview(toast)
        
        UIView.animate(withDuration: popUpBlink.duration, delay: popUpBlink.delay,
            options: .curveEaseOut,  animations: {
            toast.alpha = 0.0
            }, completion: {(isCompleted) in
                animationEnded = true
                toast.removeFromSuperview()
                completionFinish()
            })
    }
    class func changeArryyOrder<T>(forArray array: [T],fromPosition start: Int, count: Int) -> [T] {
        var position = 0
        var sortedArray = [T]()
        //var elemDel: Set <Int>
        let len = array.count
        let end = array.index(start, offsetBy: count, limitedBy: len) ?? len
        //array.index(start, offsetBy: count)
        guard start < len, end <= len else {   return sortedArray      }
        var tmpArray = Array(array[start..<end])
        guard tmpArray.count > 0 else {   return sortedArray      }
        for _ in 1...tmpArray.count {
            position = randomOrder(toMax: tmpArray.count)
            sortedArray.append(tmpArray[position])
            tmpArray.remove(at: position)
        }
        return sortedArray
        //let elem = srcAnswerOptions[position]
    }
}
