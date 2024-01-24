//
//  AddTestViewController.swift
//  testownik
//
//  Created by Slawek Kurczewski on 12/04/2020.
//  Copyright © 2020 Slawomir Kurczewski. All rights reserved.
//

import UIKit

class AddTestViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate {
    var selectedCategory = ""
    var groups = ["Matematyka","Fizyka", "Chemia", "Biologia", "Historia", "Geografia", "Genetyka", "Języki obce", "Sztuka", "Geologia", "Informatyka", "Elektronika", "Literatura", "Automatyka", "Medycyna", "Telekomunikacja","I N N E", "Zologia" ].sorted()
    
    var folderUrlValue: String = ""
    var documentsValue : [CloudPicker.Document] = []

    @IBOutlet weak var textField1: UITextField! {
        didSet {  textField1.delegate = self  } }
    @IBOutlet weak var textField2: UITextField! {
        didSet {    textField2.delegate = self  }   }
    @IBOutlet weak var label: UILabel!
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        print("saveButtonPressed")
        saveData()
        self.performSegue(withIdentifier: "goToUnwindCloudVC", sender: nil)
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        print("cancelButtonPressed")
    }
    
    @IBAction func cancelNavigatorButton(_ sender: UIBarButtonItem) {
         //self.dismiss(animated: true, completion: nil)
        print("cancelNavigatorButton")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //groups.sorted()

        label.text =  getCurrentDate()
//        if documentsValue.count > 0 {
//            textField2.text = "\(documentsValue[0].myTexts)"
//        }
        //database.testDescriptionTable[0].file_name
        // Do any additional setup after loading the view.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // MARK: - UIPickerViewDelegate methods
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groups.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groups[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = groups[row]
        print("EEE:\(groups[row])")
    }
    func getCurrentDate() -> String {
       let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd  HH:mm:ss"
        return "Test  "+formatter.string(from: currentDateTime)
    }
    func getHeaderPicture(uuidParent: UUID, uuidPict: UUID, text: String) -> UIImage? {
        var image: UIImage? = nil
        
        //let line = text
        let lines = text.components(separatedBy: .newlines)
        if lines.count > 2 {
            let line1 = lines[1].trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            if line1.hasPrefix("[img]")  {
                let startIndex = line1.index(line1.startIndex, offsetBy: 5)
                let endIndex = line1.index(line1.endIndex, offsetBy: -6)
                //let range = startIndex..<endIndex
                let picName = String(line1[startIndex..<endIndex])
                print("picName:\(picName)")
                image = pictureLibrary.giveAsImage(picName)
               // image = UIImage(named: picName)
            }
        }
//        if let data = document.myPictureData {
//           self.picture?.image = UIImage(data:  data)
//        }
        //image = UIImage(named: picName)
        return image
        
    }
    func saveData() {
        //database.allTestsTable.deleteAll()
        //database.testDescriptionTable.deleteAll()
        let uuid = UUID()
        let context = database.context
        let allTestRecord = AllTestEntity(context: context)
        allTestRecord.auto_name = label.text
        allTestRecord.user_name = textField1.text
        allTestRecord.user_description  = textField2.text
        allTestRecord.category = selectedCategory
        allTestRecord.create_date = Date()
        allTestRecord.is_favorite = true
        allTestRecord.uuId = uuid
        allTestRecord.folder_url = folderUrlValue
        
        //allTestRecord.
        
        // FIXME: comment here
        // TODO:  comment here
        // MARK:  do zrobienia
        
        database.allTestsTable.append(allTestRecord)
        database.allTestsTable.save()
        for i in 0..<documentsValue.count {
            
            let currDoc = documentsValue[i]
            print("FFF \(i):\(currDoc.fileURL.lastPathComponent)")
            if let pict = currDoc.myPictureData {
                let pictName = currDoc.fileURL.lastPathComponent
                let pict = currDoc.myPictureData
                print("\nNEW PICTURE:\(pictName)")
                pictureLibrary.addData(forName: pictName, value: pict)
            }
            print("PICTUSES:\(pictureLibrary.count)")
        }
        
        for i in 0..<documentsValue.count {
            let record = TestDescriptionEntity(context: context)
            record.file_url = documentsValue[i].fileURL.absoluteString
            record.file_name = documentsValue[i].fileURL.lastPathComponent
            
            print("FILE NAME:\(record.file_name)")
            record.text =  documentsValue[i].myTexts
            record.code_page = Int16(documentsValue[i].myCodepage.rawValue)
            print("documentsValue[\(i)].myTexts: \(documentsValue[i].myTexts)")

            // TODO: Maybe error
            record.picture = documentsValue[i].myPictureData
           
            record.uuid_parent = uuid
            record.uuId = UUID()
            //-----------------------
            let pict = getHeaderPicture(uuidParent: record.uuid_parent!, uuidPict: record.uuId!, text: record.text!)
            record.picture = pict?.pngData()
            
            database.testDescriptionTable.append(record)
            database.testDescriptionTable.save()
        }
    }
    // MARK: UITextFieldDelegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
