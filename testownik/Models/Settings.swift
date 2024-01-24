//
//  Settings.swift
//  testownik
//
//  Created by Slawek Kurczewski on 15/09/2021.
//  Copyright © 2021 Slawomir Kurczewski. All rights reserved.
//

import Foundation
import UIKit

//test_scope: Double
//retesting_no: Int16
//wrong_testing_no: Int16
//percentage_repetitions: Int16
//part_size: Int16

//slider_scope_test
//no_repetitions_key repetition_0
//no_repetitions_wrong_key repetition_wrong_0
//percen_repeat_key percent_a
//split_key split_a

//test_scope_key
//nr_retesting_key
//nr_wrong_testing_key
//percent_repeat_key
//part_size_key
//

class Settings {
    enum SettingBundleEnum: String {
        case version_key            = "version_key"
        case speaking_key           = "speaking_key"
        case listening_key          = "listening_key"
        case dark_thema_key         = "dark_thema_key"
        case code_page_key          = "code_page_key"
        case language_key           = "language_key"
        case repeating_key          = "repeating_key"
        case delete_tests_key       = "delete_tests_key"
    
        case BuildVersionKey        = "build_preference"
        case AppVersionKey          = "version_preference"
        case BundleShortVersion     = "CFBundleShortVersionString"
        case BundleVersion          = "CFBundleVersion"
        
        case test_scope_key         = "test_scope_key"
        case nr_retesting_key       = "nr_retesting_key"
        case nr_wrong_testing_key   = "nr_wrong_testing_key"
        case percent_repeat_key     = "percent_repeat_key"
        case part_size_key          = "part_size_key"
    }
    enum LanguageEnum : String {
        case automatic = "automatic"
        case english   = "english"
        case german    = "german"
        case french    = "french"
        case spanish   = "spanish"
        case polish    = "polish"
    }
    enum CodePageEnum: String {
        case utf8    = "utf8"
        case iso9    = "iso9"
        case win1250 = "win1250"
    }
    enum RepeatingEnum: String {
        case repeating_a = "repeating_a"
        case repeating_b = "repeating_b"
        case repeating_c = "repeating_c"
        case repeating_d = "repeating_d"
        case repeating_e = "repeating_e"
        case repeating_f = "repeating_f"
    }
    // MARK: Sinleton definition
    static var shared: Settings = {
        let instance = Settings()
        return instance
    }()
// let xxx = String.Encoding.windowsCP1250
    
    
    
//    class func checkAndExecuteSettings() {
//        if UserDefaults.standard.bool(forKey: SettingBundleEnum.dark_thema_key.rawValue) {
//            UserDefaults.standard.set(false, forKey: SettingBundleEnum.dark_thema_key.rawValue)
//            let appDomain: String? = Bundle.main.bundleIdentifier
//            UserDefaults.standard.removePersistentDomain(forName: appDomain!)
//        }
//    }
    //-------------------
    func startObserver() {
//        UserDefaults.standard.addObserver(self, forKeyPath: colorPreference,  options: .new,   context: nil)
    }
    func xxxxx() {
//        override func observeValue(forKeyPath keyPath: String?,
//                                   of object: Any?,
//                                   change: [NSKeyValueChangeKey : Any]?,
//                                   context: UnsafeMutableRawPointer?) {
//          if keyPath == colorPreference {
//            updateEntryCellColor()
//          }
//        }
//
//        private func updateEntryCellColor() {
//          let overrideColorPreference = UserDefaults
//            .standard.bool(forKey: colorPreference)
//          let overrideColor = UIColor.white
//          if overrideColorPreference {
//            entryCell.contentView.backgroundColor = overrideColor
//            textView.textColor = UIColor.black
//          } else {
//            entryCell.contentView.backgroundColor = nil
//            textView.textColor = UIColor.label
//          }
//        }

    }
    func yyyy() {
        //var appDefault: NSDictionary = NSDictionary.decodeDictionaryWithKeys(of: AnyClass, objectsOf: AnyObject, forKey: "you_key")
        let appDefault: Dictionary = NSDictionary.dictionaryWithValues(forKeys: ["you_key"])
      UserDefaults.standard.register(defaults: appDefault )
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.integer(forKey: "you_key")
        
//        @IBAction private func share(_ sender: Any?) {
//          guard var textToShare = textView.text,
//            !textToShare.isEmpty else { return }
//          if let namePreference = UserDefaults
//            .standard.string(forKey: namePreference),
//            UserDefaults
//              .standard.bool(forKey: signaturePreference) {
//            textToShare += "\n -\(namePreference)"
//          }
//          let activityController
//            = UIActivityViewController(activityItems: [textToShare],
//                                       applicationActivities: nil)
//          if let popoverController
//            = activityController.popoverPresentationController {
//            popoverController.barButtonItem
//              = navigationItem.rightBarButtonItem
//          }
//          present(activityController,
//                  animated: true,
//                  completion: nil)
//        }

    }
    func getCountryCode(forLanguage key: Setup.LanguaesList) -> String?
    {
        if let val = Setup.allLanguages.key(from: key) {
            return val
        }
        return nil
    }
    //-------------------
    func setVersionAndBuildNumber() {
        let version = Bundle.main.object(forInfoDictionaryKey:  SettingBundleEnum.BundleShortVersion.rawValue)  //CFBundleShortVersionString
        UserDefaults.standard.set(version, forKey:  SettingBundleEnum.AppVersionKey.rawValue)
        let build = Bundle.main.object(forInfoDictionaryKey: SettingBundleEnum.BundleVersion.rawValue)
        UserDefaults.standard.set("\(version ?? 1) build \(build ?? 1)", forKey: SettingBundleEnum.version_key.rawValue )
//        let lang = Bundle.main.object(forInfoDictionaryKey: "Local")
//        print("=========\nlang:\(lang)")
    }
//--------
    func getValue(boolForKey key: SettingBundleEnum) -> Bool {
        let val = UserDefaults.standard.bool(forKey: key.rawValue)
        print("Val \(key.rawValue):\(val)")
        return val
    }
    func getValue(stringForKey key: SettingBundleEnum) -> String {
        var ret = ""
        if let val = UserDefaults.standard.object(forKey: key.rawValue) {
            print("STRIN:   \(val)")
            ret = "\(val)"
        }
        return ret
    }
    func getValue(integerForKey key: SettingBundleEnum) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    func setValue(forKey key: SettingBundleEnum, newBoolValue value: Bool)  {
        UserDefaults.standard.set(value , forKey: key.rawValue)
    }
//    class func setValueBool(forKey key: SettingBundleEnum, newValue value: Bool)  {
//        UserDefaults.standard.set(value , forKey: key.rawValue)
//    }
    func setValue(forKey key: SettingBundleEnum, newStringValue value: String) {
        UserDefaults.standard.set(value , forKey: key.rawValue)
    }
    func setValue(forKey key: SettingBundleEnum, newIntValue value: Int) {
        UserDefaults.standard.set(value , forKey: key.rawValue)
    }
    func reversBoolValue(forKey key: SettingBundleEnum) {
        let tmp = getValue(boolForKey: key)
        setValue(forKey: key, newBoolValue: !tmp)
    }
    func checkResetRequest(forUIViewController controller: UIViewController)  {
        let isReset = getValue(boolForKey: .delete_tests_key)
        setValue(forKey: .delete_tests_key, newBoolValue: false)
        guard isReset else {  return   }
        let message: String = Setup.placeHolderDeleteTest
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { action in    self.DeleteAllTests()      }
        alert.addAction(ok)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
//    case automatic = "automatic"
//    case english   = "english"
//    case german    = "german"
//    case french    = "french"
//    case spanish   = "spanish"
//    case polish    = "polish"

    func readCurrentLanguae() {
        let currLangCode = getValue(stringForKey: .language_key)
        switch currLangCode {
            case LanguageEnum.automatic.rawValue :
                //  Get syste language                Setup.currentLanguage = .enlish
                if let languageCode = Locale.preferredLanguages.first?.components(separatedBy: "-").first // "en"
                {
                    // "en" to .english
                    Setup.currentLanguage = Setup.allLanguages[languageCode] ?? .enlish
                    //  Setup.allLanguages.key(from: .french)
                }
                print("automatic")
            case LanguageEnum.english.rawValue   : Setup.currentLanguage = .enlish
                print("english")
            case LanguageEnum.german.rawValue    : Setup.currentLanguage = .german
                print("german")
            case LanguageEnum.french.rawValue    : Setup.currentLanguage = .french
                print("french")
            case LanguageEnum.spanish.rawValue   : Setup.currentLanguage = .spanish
                print("spanish")
            case LanguageEnum.polish.rawValue    : Setup.currentLanguage = .polish
                print("polish")
            default:
                print("ERROR  LanguageEnum")
            Setup.currentLanguage = Setup.allLanguages[Locale.preferredLanguages.first?.components(separatedBy: "-").first ?? "en"] ?? .enlish
                //setLanguage(forSettings: Setup.currentLanguage)
            }
        //setLanguage(forSettings: .enlish)
    }
    func setLanguage(forSettings curLang: Setup.LanguaesList) {
        let landCode = curLang.rawValue
        Settings.shared.setValue(forKey: .language_key, newStringValue: landCode)
    }
    func DeleteAllTests() {
        print(">>>>   KASOWANIE TESTÓW   <<<<<<<<<")
    }
    //retesting_no: Int16
    //wrong_testing_no: Int16
    //percentage_repetitions: Int16
    //test_scope: Double
    //part_size: Int16
    
//    slider_scope_test
//    no_repetitions_key repetition_0
//    no_repetitions_wrong_key repetition_wrong_0
//    percen_repeat_key percent_a
//    split_key split_a
    func readTestPreferences() {
        let  nr = 0
        if let nr_retesting = database.allTestsTable[nr]?.nr_retesting {
            setValue(forKey: .nr_retesting_key, newIntValue: Int(nr_retesting))
        }
        if let nr_wrong_testing = database.allTestsTable[nr]?.nr_wrong_testing {
            setValue(forKey: .nr_wrong_testing_key, newIntValue: Int(nr_wrong_testing))
        }
        if let test_scope = database.allTestsTable[nr]?.test_scope {
            setValue(forKey: .test_scope_key, newIntValue: Int(test_scope))
        }
        if let percent_repeat = database.allTestsTable[nr]?.percent_repeat {
            setValue(forKey: .percent_repeat_key, newIntValue: Int(percent_repeat))
        }
        if let part_size = database.allTestsTable[nr]?.part_size {
            setValue(forKey: .percent_repeat_key, newIntValue: Int(part_size))
        }
    }
    func saveTestPreferences() {
        let  nr = 0
        let xx = Double(getValue(integerForKey: .test_scope_key))
        print("XX:\(xx)")
        let yy = getValue(integerForKey:  .nr_retesting_key)
        print("YY:\(yy)")
        let zz = getValue(integerForKey: .nr_wrong_testing_key)
        print("zz:\(zz)")
        let aa = getValue(integerForKey: .percent_repeat_key)
        print("aa:\(aa)")
        let bb = getValue(integerForKey: .part_size_key)
        print("bb:\(bb)")

        if database.allTestsTable.count > nr {
            database.allTestsTable[nr]?.nr_retesting     =  Int16(getValue(integerForKey: .nr_retesting_key))
            database.allTestsTable[nr]?.nr_wrong_testing =  Int16(getValue(integerForKey: .nr_wrong_testing_key))
            database.allTestsTable[nr]?.test_scope       =  Int16(getValue(integerForKey: .test_scope_key))
            
            database.allTestsTable[nr]?.part_size        =  Int16(getValue(integerForKey: .part_size_key))
            database.allTestsTable[nr]?.percent_repeat   =  Int16(getValue(integerForKey: .percent_repeat_key))            
            database.allTestsTable.save()
        }
    }

//    class func displayToast(forController controller: UIViewController, message: String, seconds delay: Double)  {
//        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        alert.view.backgroundColor = .systemYellow
//        alert.view.alpha = 0.3
//        alert.view.layer.cornerRadius = 10
//        alert.view.clipsToBounds = true
//        controller.present(alert, animated: true)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
//            alert.dismiss(animated: true)
//        }
//    }
    
//    class func SetValue<T>(forKey key: SettingBundleEnum, newValue value: T) {
//        UserDefaults.standard.set(value , forKey: key.rawValue)
//    }
//---------------
    func registerSettingBundle() {
        let appDefaults = [String : AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    @objc func defaultsChanged() {
        if UserDefaults.standard.bool(forKey: "red_theme_key") {
           // self.view.backgroundColor = .red
            print("RedThemeKey")
        }
        else {
        //    self.view.backgroundColor = .white
            print("whiteThemaKey")
        }
    }
}
