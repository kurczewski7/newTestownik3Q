//
//  ZipViewController.swift
//  SwiftyDocPicker
//
//  Created by Slawek Kurczewski on 18/03/2020.
//  Copyright © 2020 Abraham Mangona. All rights reserved.
//

import UIKit

class ZipViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var zipFileNameValue = ""
    var urlValue = ""
    
    var cloudPicker: CloudPicker!
    var documentsUnziped : [CloudPicker.Document] = []
    var indexpath = IndexPath(row: 0, section: 0)
    //var tmpDoc = [CloudPicker.Document]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cloudPicker = Setup.cloudPicker
        
        print("--------------------\nZipViewController,urlValue=\(urlValue)")
//        let urlStr1 = "File_Zip_URL:file:///Users/slawek/Library/Developer/CoreSimulator/Devices/FFB0AE7E-10D1-4A00-829A-6F1A7969B397/data/Containers/Data/Application/BCF38805-F45C-4522-9ADC-2004CBB2C913/Documents/Testownik_tmp/baza_slawek/001.txt"
//
//        let urlStr2 = "File_Zip_URL:file:///Users/slawek/Library/Developer/CoreSimulator/Devices/FFB0AE7E-10D1-4A00-829A-6F1A7969B397/data/Containers/Data/Application/BCF38805-F45C-4522-9ADC-2004CBB2C913/Documents/Testownik_tmp/baza_slawek/002.txt"
//
//        let urlstr3 = "File_Zip_URL:file:///Users/slawek/Library/Developer/CoreSimulator/Devices/FFB0AE7E-10D1-4A00-829A-6F1A7969B397/data/Containers/Data/Application/BCF38805-F45C-4522-9ADC-2004CBB2C913/Documents/Testownik_tmp/baza_slawek/003.txt"
//        let dok1 = CloudPicker.Document(fileURL: URL(string: urlStr1)!)
//        let dok2 = CloudPicker.Document(fileURL: URL(string: urlStr2)!)
//        let dok3 = CloudPicker.Document(fileURL: URL(string: urlStr2)!)
//        documentsUnziped.append(dok1)
//        documentsUnziped.append(dok2)
//        documentsUnziped.append(dok3)
        
        //cloudPicker = CloudPicker(presentationController: self)
        if !urlValue.isEmpty  {
            print(",,,,,,,,,,,")
            let urlStr = urlValue
            let url = URL(fileURLWithPath: urlStr, isDirectory: true)
            print("--------\nurlStr:=:=  \(urlStr)")
            print("--------\nFolder URL=  \(url)")
            documentsUnziped = cloudPicker.documentsUnziped
            print("documentsUnziped.count=\(documentsUnziped.count)")
//            documentsUnziped = cloudPicker.documentFromZip(pickedURL: url)
//            print("++++++\n\(documentsUnziped.count)")
        }
        else {
            print("Error Display Zip")
        }
        
        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cloudPicker.documentsUnziped.count
        //Setup.cloudPicker.documentsUnziped.count //3 //documentsUnziped.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt:\(indexPath.row),\(indexPath.section)")
        print("url0:\(Setup.cloudPicker.documentsUnziped[0].fileURL.absoluteString)")
        print("url1:\(Setup.cloudPicker.documentsUnziped[1].fileURL.absoluteString)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "zipCell", for: indexPath) as! ZipCollectionViewCell
        cell.backgroundColor = .brown
        cell.titleLabel.text =  "\(self.cloudPicker.documentsUnziped[indexPath.row].fileURL.lastPathComponent)"
        //cell.titleLabel.text =  "\(Setup.cloudPicker.documentsUnziped[indexPath.row].fileURL.lastPathComponent)"   //tmpDoc[indexPath.item].fileURL.lastPathComponent    // "\(indexPath.item)"
        // cell.configure(document: documentsUnziped[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
        self.indexpath = indexPath
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        performSegue(withIdentifier: "showZipDetail", sender: cell)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      // 1
      switch kind {
      // 2
      case UICollectionView.elementKindSectionHeader:
        // 3  \(ZipSectionHeaderView.self)  sectionHeader
        guard
          let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "zipSectionHeader",
            for: indexPath) as? ZipSectionHeaderView
          else {
            fatalError("Invalid view type")
        }

        //let searchTerm = searches[indexPath.section].searchTerm
        headerView.label.text = zipFileNameValue    //searchTerm
        return headerView
      default:
        // 4
        assert(false, "Invalid element type")
      }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("showZipDetail")
        if segue.identifier == "showZipDetail" {
            if let nextViewController = segue.destination as? DetailViewController {
                nextViewController.cloudPickerValue =  self.cloudPicker                 //Setup.cloudPicker
                nextViewController.documentsValue = self.cloudPicker.documentsUnziped   //Setup.cloudPicker.documentsUnziped
                nextViewController.indexpathRow = indexpath.row
            }
         print("showArchiveDetail")
        }
    }
}


