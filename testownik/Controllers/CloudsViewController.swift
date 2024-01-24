//
//  CloudViewController.swift
//  SwiftyDocPicker
//
//  Created by Abraham Mangona on 9/14/19.
//  Copyright © 2019 Abraham Mangona. All rights reserved.
//

import UIKit

class CloudViewController: UIViewController, CloudPickerDelegate  {

    //SSZipArchiveDelegate
//    var cloudPicker: CloudPicker!
    var documents  : [CloudPicker.Document] = [CloudPicker.Document]()
//    var documentsUnziped : [CloudPicker.Document] = []
//    var unzipedPathDir: String = ""
//    documentsUnziped = cloudPicker.documentFromZip(pickedURL: url)
//    print("++++++\n\(documentsUnziped.count)")

    var indexpath = IndexPath(row: 0, section: 0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func unwindToCloudVC(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as? AddTestViewController
        print("label:\(String(describing: sourceViewController?.label.text))")
        print("Unwind")
        // Use data from the view controller which initiated the unwind segue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CloudViewController")
        self.view?.tag = 222
        self.documents.removeAll()
        Setup.cloudPicker = CloudPicker(presentationController: self)
        Setup.cloudPicker.delegate = self
        Setup.popUp(context: self, msg: "Pres + and select folder or zip file")
    }
    func errorZipStructureMessae(message: String) {
        Setup.displayToast(forView: self.view, message: message + " !!!", seconds: 5)
    }
    func didPickDocuments(documents: [CloudPicker.Document]?) {
        self.documents.removeAll()
        documents?.forEach {
            self.documents.append($0)
        }
        self.documents.sort {
            $0.fileURL.lastPathComponent < $1.fileURL.lastPathComponent
        }
        collectionView.reloadData()
    }
    @IBAction func pickPressed(_ sender: UIBarButtonItem) {
        Setup.cloudPicker.present(from: view)
    }
    
    @IBAction func trashPressed(_ sender: UIBarButtonItem) {
        Setup.cloudPicker.cleadData()
        documents.removeAll()
        collectionView.reloadData()
    }    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        print("savePressed")
        self.dismiss(animated: true)
    }
 
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("------\nsegue: \(String(describing: segue.identifier))")
         if segue.identifier == "showSave" {
            if let nextViewController = segue.destination as? AddTestViewController {
                // TODO: ERROR
                //nextViewController.documentsValue = self.documents
                nextViewController.documentsValue = Setup.cloudPicker.currentDocuments
                nextViewController.folderUrlValue = Setup.cloudPicker.sourceUrl ?? "no url"
            }
        }
        if segue.identifier == "showDetail" {
            let document = documents[self.indexpath.row]
            if let nextViewController = segue.destination as? DetailViewController {
                nextViewController.cloudPickerValue = Setup.cloudPicker
                nextViewController.documentsValue = documents
                nextViewController.indexpathRow = indexpath.row

                
                nextViewController.fileExtensionValue = Setup.cloudPicker.splitFilenameAndExtension(fullFileName: document.fileURL.lastPathComponent).fileExt
                
                Setup.displayToast(forView: self.view, message: "Druga wiadomość", seconds: 3)
                Setup.popUp(context: self, msg: "Trzecia wiadomość")
                
                print("nextViewController:\(nextViewController)")
                print("fileURL: \(document.fileURL)")
                print("self.indexpath 2:\(self.indexpath)")
            }
      }
      if segue.identifier == "showArchive" {
        let document = documents[self.indexpath.row]
        if let nextViewController = segue.destination as? ZipViewController {
            nextViewController.zipFileNameValue = document.fileURL.lastPathComponent
            nextViewController.urlValue = Setup.cloudPicker.unzipedPathDir
            //nextViewController.cloudPicker = Setup.cloudPicker
            
            print("::::::\(Setup.cloudPicker.unzipedPathDir)")
            for i in 0..<Setup.cloudPicker.documentsUnziped.count {
                print("\n\(Setup.cloudPicker.documentsUnziped[i].fileURL)")
            }
            //cloudPicker.unzipedPathDir =
            //Setup.unzipFile(atPath: document.fileURL.absoluteString, delegate: self)
            //let urlStr = cloudPicker.unzip(document: document)
        }
         print("showArchive")
      }
    }
}

extension CloudViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("ERROR HIRE")
        return documents.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "documentCell", for: indexPath) as? DocumentCell
        cell?.configure(document: documents[indexPath.row])
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexpath = indexPath
        print("self.indexpath 1:\(self.indexpath)")
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let noZip = Setup.cloudPicker.sourceType != .filesZip
        if noZip {
          performSegue(withIdentifier: "showDetail", sender: cell)
        }
        else {
            //Setup.popUp(context: self, msg: "Zbior ZIP")
            performSegue(withIdentifier: "showArchive", sender: cell)
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //let folderName = cloudPicker.sourceType == .folder ? "Folder: \(cloudPicker.folderName)" : cloudPicker.folderName
        let folderName = (Setup.cloudPicker.sourceType == .folder ? "Folder: " : "") +  Setup.cloudPicker.folderName
        // 1
           switch kind {
           // 2
           case UICollectionView.elementKindSectionHeader:
             // 3  \(ZipSectionHeaderView.self)  sectionHeader
             guard
               let headerView = collectionView.dequeueReusableSupplementaryView(
                 ofKind: kind,
                 withReuseIdentifier: "detailSectionHeader",
                 for: indexPath) as? DetailSectionHeaderView
               else {
                 fatalError("Invalid view type")
             }

             //let searchTerm = searches[indexPath.section].searchTerm
             headerView.label.text =  folderName   //searchTerm
             return headerView
           default:
             // 4
             assert(false, "Invalid element type")
           }
    }
}

