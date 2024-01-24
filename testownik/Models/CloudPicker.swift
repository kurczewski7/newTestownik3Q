//
//  CloudPicker.swift
//  SwiftyDocPicker
//
//  Created by Abraham Mangona on 9/14/19.
//  Copyright © 2019 Abraham Mangona. All rights reserved.
//

import UIKit
import MobileCoreServices
import SSZipArchive

protocol CloudPickerDelegate: AnyObject {
    func didPickDocuments(documents: [CloudPicker.Document]?)
    func errorZipStructureMessae(message: String)
}
class CloudPicker: NSObject, UINavigationControllerDelegate, SSZipArchiveDelegate {
    typealias FileExt = (fileName: String, fileExt: String)
    public enum SourceType: Int {
        case filesTxt
        case filesZip
        case folder
//        case empty
    }
    
    typealias ReadFileData = (documents: [Document],  zipFileUrl: URL?, unzipedPathDir: String, documentsUnziped : [CloudPicker.Document],  folderURL: URL?,  sourceUrl: String?)
    var readFileData: ReadFileData = (documents: [Document](),  zipFileUrl: nil, unzipedPathDir: "", documentsUnziped : [CloudPicker.Document](),  folderURL: nil,  sourceUrl: "")
    
    // MARK: Class Document
    class Document: UIDocument {
        var data: Data?
        var myTexts = ""
        var myCodepage = String.Encoding.utf8
        var myPictureData: Data? = nil
        
        override func contents(forType typeName: String) throws -> Any {
            guard let data = data else { return Data() }
            return try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
        }
        override func load(fromContents contents: Any, ofType typeName: String?) throws {
            guard let data = contents as? Data else { return }
            self.data = data
        }
    }
    
    // MARK: Variable
    private var pickerController: UIDocumentPickerViewController?
    private weak var presentationController: UIViewController?
    
    private var folderURL: URL?
    private var zipFileUrl: URL?
    private var documents = [Document]()
    
    var delegate: CloudPickerDelegate?
    var showHidden = false
    var hiddenFiles = 0

    var documentsUnziped : [CloudPicker.Document] = []
    var unzipedPathDir: String = ""
    var folderName = ""
    var sourceType: SourceType = .folder
    var sourceUrl: String? {
        get {
            return (sourceType == .folder ? folderURL : zipFileUrl)?.absoluteString
        }
    }
    var currentDocuments: [Document] {
        get {
            if sourceType == .filesZip {
                return documentsUnziped
            }
            else  {
                return documents
            }
        }
    }
    //private var lastSourceTypeData: SourceType = .folder

    // MARK: Metods
    init(presentationController: UIViewController) {
        super.init()
        
        self.presentationController = presentationController
        print("INIT")
//        documents.sort { ($0, $1) -> Bool in
//
//        }
    }
    public func folderAction(for type: SourceType, title: String) -> UIAlertAction? {
         let action = UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.cleadData()
            self.pickerController = UIDocumentPickerViewController(documentTypes: [kUTTypeFolder as String], in: .open)
            self.pickerController!.delegate = self
            self.sourceType = type
            self.presentationController?.present(self.pickerController!, animated: true)
        }
        return action
    }
    public func fileAction(for type: SourceType, title: String, keysOption keys: [CFString]) -> UIAlertAction? {
         let action = UIAlertAction(title: title, style: .default) { [unowned self] _ in    
            if type == .filesZip { self.cleadData() }
            self.pickerController = UIDocumentPickerViewController(documentTypes: keys as [String], in: .open)
            self.pickerController!.delegate = self
            self.pickerController!.allowsMultipleSelection = true
            self.sourceType = type
            self.presentationController?.present(self.pickerController!, animated: true)
        }
        return  action
    }
    public func present(from sourceView: UIView) {
        //let xx = [kUTTypeText, kUTTypeFolder, kUTTypeArchive, kUTTypeFileURL,kUTTypePlainText, kUTTypeZipArchive, kUTTypeGNUZipArchive, kUTTypeUTF8PlainText, kUTTypeUTF16ExternalPlainText, kUTTypeUTF8TabSeparatedText, kUTTypeUTF16PlainText]
        let alertController = UIAlertController(title: "Select From", message: nil, preferredStyle: .actionSheet)
        if let action1 = self.folderAction(for: .folder, title: "Folder") {
            alertController.addAction(action1)
        }
        let keys1 =  [kUTTypeText , kUTTypePlainText, kUTTypeUTF8PlainText, kUTTypeUTF8TabSeparatedText, kUTTypeUTF16PlainText, kUTTypeUTF16ExternalPlainText]
        if let action2 = self.fileAction(for: .filesTxt, title: "Files text", keysOption: keys1) {
            alertController.addAction(action2)
        }
        let keys2 = [kUTTypeArchive, kUTTypeZipArchive,kUTTypeGNUZipArchive]
        if let action3 = self.fileAction(for: .filesZip, title: "Files archive", keysOption: keys2) {
            alertController.addAction(action3)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        self.presentationController?.present(alertController, animated: true)
    }
    //--------------------------
    func getText(fromCloudFilePath filePath: URL) -> (texts: [String], encoding: String.Encoding){
        let value = findEncoding(filePath: filePath)
        var outputStrings: [String] = [String]()
        outputStrings.removeAll()
        let myStrings = value.data.components(separatedBy: .newlines)
        for oneLine in myStrings {
            if !oneLine.isEmpty {
                outputStrings.append(oneLine.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
        //print("CODE:\(value.encoding.description),\(value.encoding.rawValue)")
        
        return (outputStrings, value.encoding)
    }
   //########################>
    private func findEncoding(filePath path: URL) -> (encoding: String.Encoding, data: String) {
        let encodingType: [String.Encoding] = [String.Encoding.utf8, .windowsCP1250, .windowsCP1251, .windowsCP1252, .windowsCP1253, .windowsCP1254, .isoLatin2, .isoLatin1, .ascii, .nonLossyASCII, .unicode, .macOSRoman, .utf16 ]
        //  [.utf8, .windowsCP1250, .isoLatin2, .unicode, .ascii]
        let data: String = "Nie znaleziono"
        var encoding: String.Encoding = .utf8
        
        if let encodId = checkCodePageId(path: path) {
            if let value0 = tryEncodingFile(filePath: path, encoding: encodId) {
                encoding = encodId
                return  (encoding, value0)
            }
        }
        for i in 0..<encodingType.count {
            if let value1 = tryEncodingFile(filePath: path, encoding: encodingType[i]) {
                  return (encodingType[i], value1)
            }
        }
        return  (.utf8, data)
    }
    func checkCodePageId(path: URL)  -> String.Encoding? {
        var encodingType: String.Encoding = .utf8
        
        do {
            let str = try String(contentsOfFile: path.absoluteString ,usedEncoding: &encodingType)
            print(("encoding:\(encodingType.rawValue),\(encodingType.description)\nstr:\(str)\n"))
            
            print("encoding Type:\(encodingType.description),\(encodingType.rawValue)")
            return encodingType
        }
        catch {
            return nil
        }
    }
    private func tryEncodingFile(filePath path: URL, encoding: String.Encoding)  -> String? {
        do {
            //let fff = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let data = try String(contentsOf: path, encoding: encoding)
            //print("DATA!!,encoding\(encoding):\(data)")
            return  data
        }
        catch let error {
            print("NIE ZDEKODOWANO STRINGA:\(encoding),error:\(error)")
            return nil
        }
    }
    func unzip(document: CloudPicker.Document, tmpFolder: String = "Testownik_tmp") -> [Document] {
        let emptyDocs = [Document]()
        let sourcePath = document.fileURL.relativePath
        let pathTmp = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let destPath = pathTmp.appendingPathComponent(tmpFolder, isDirectory: true).relativePath
        let zipFileNames = document.fileURL.lastPathComponent.components(separatedBy: ".")
        var zipName = ""
        
        if zipFileNames.count > 0 {
            for i in 0..<zipFileNames.count-1 {
                zipName += zipFileNames[i]
                zipName += ( i < zipFileNames.count-2 ? "." : "")
            }
        }
        print("zipfileName:\(zipName)")
        print("srcPath \(sourcePath)")
        print("\ndestPath \(destPath)")
        deleteFolder(deleteFilePath: destPath)

        let success = SSZipArchive.unzipFile(atPath: sourcePath, toDestination: destPath, delegate: self)
        let msg = success ? "Rozpakowanie poprawne \(zipName)" : "Błąd rozpakowania"
        print("=====\nmsg=\(msg)")
        print("ZipArchive - Success: \(success)")
        if  !success {
            return emptyDocs
        }
        if let tmpPath =  URL(string: destPath) {
            let subDirDocs = documentsFromLocalURL(pickedURL: tmpPath)
            print("subDirDocs=\(subDirDocs.count)")
            return subDirDocs.count > 0 ? subDirDocs : emptyDocs
        }
        else {  return emptyDocs        }
        //let fullDestPath = zipFileNames.isEmpty ? "" : "\(destPath)/\(zipName)"
        //return success ? getPathDestSubdir(fullDestPath: fullDestPath) : ""
    }
    private func getPathDestSubdir(fullDestPath path: String) -> String {
        let subPath = ""
        //------------
        print("fullDestPath=\(path)")
        if path.contains(" ") {
            print("Invalid zip structure !!!")
            let startSeq = path.startIndex
            //let end = unzipedPathDir.index(unzipedPathDir.endIndex, offsetBy: -2)
            let endSeq = path.lastIndex(of: " ") ?? path.endIndex
            let xxxUrlStr = String(path[startSeq..<endSeq])
            //let yyy = unzipedPathDir.c
            print("xxxUrlStr=\(xxxUrlStr)")
        }
        //-----------
//        if let urlPath = URL(string: path) {
//            let xxxx = documentsFromLocalURL(pickedURL: urlPath)
//            print("xxxx=\(xxxx.count)")
//        }
        
   
       
        
        return path + subPath
        
    }
    private func deleteFolder(deleteFilePath atPath: String) {
        do {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: atPath) {
                try fileManager.removeItem(atPath: atPath)
            }
            else {
                print("File does not exist")
            }
        }
        catch let error as NSError {
            print("Error delete: \(error.localizedDescription)")
        }
    }
    func mergeText(forStrings strings: [String]) -> String {
        var val = ""
            for elem in strings {     val += elem + "\n"        }
        return val
    }
    func cleadData() {
        self.documents.removeAll()
        self.hiddenFiles = 0
    }
    func isPictureDataOk(values: [Substring]) -> Bool {
        var retVal = false
        
        if values.count == 2 {
            switch String(values[1]).uppercased() {
                case "PNG": retVal = false
                case "JPG": retVal = false
                case "BMP": retVal = false
                default:    retVal = false
            }
        }
        return retVal
    }
    func isTextDataOk(values: [Substring])  -> Bool{
        let fileName = values[0]
        var stringNumber = ""
        for  character in fileName {
            if let number = Int(String(character)), number >= 0  {
                stringNumber.append(character)
            }
            else { break }
        }
        return true
        // MARK: hire change
        if let numberLong = Int(stringNumber), numberLong >= 0 {     return true             }
        else {       return false             }
    }
    func splitFilenameAndExtension(fullFileName name: String) -> FileExt  {
        let values = name.split(separator: ".")
        let ext = String(values.last ?? "").uppercased()
        let extCount = ext.count
        let prefixIndex = name.index(name.endIndex, offsetBy: -extCount-1)
        let retVal: FileExt = (String(name.prefix(upTo: prefixIndex)),   ext)
        return retVal
      }
    //-----------------------
    func getImageData(fromUrl url: URL, completionHandler: @escaping(_ imageData: Data?) -> ()) {
        //guard let imageURL = URL(string: url) else { return }
        DispatchQueue.global(qos: .background).async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                if let imgData = data {    completionHandler(imgData)            }
                else {   completionHandler(nil)           }
                }
        }
    }
    deinit {
        print("DEINIT")
    }
}
extension CloudPicker: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {   return    }
         documentFromURL(pickedURL: url)
         delegate?.didPickDocuments(documents: documents)
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        delegate?.didPickDocuments(documents: nil)
    }
    private func documentFromURL(pickedURL: URL) {
        let shouldStopAccessing = pickedURL.startAccessingSecurityScopedResource()
        defer {
            if shouldStopAccessing {
                pickedURL.stopAccessingSecurityScopedResource()
            }
        }
        NSFileCoordinator().coordinate(readingItemAt: pickedURL, error: NSErrorPointer.none) { (folderURL) in
                do {
                    let keys: [URLResourceKey] = [.nameKey, .isDirectoryKey] //isDirectoryKey isRegularFileKey
                    let fileList = FileManager.default.enumerator(at: pickedURL, includingPropertiesForKeys: keys)
                    //print("Folder_URL:\(folderURL.absoluteString)")
          
                    switch sourceType {
                        case .filesTxt:
                            folderName = "Files"
                            var document = Document(fileURL: pickedURL)
                            print("One_File_URL:\(pickedURL.absoluteString)")
                            if isFileUnhided(fileURL: pickedURL, folderURL: folderURL, sourceType: .filesTxt) {
                                fillDocument(forUrl: pickedURL, document: &document)
                                documents.append(document)
                            }
                        
                        case .folder:
                            self.folderURL = folderURL
                            folderName = folderURL.lastPathComponent
                            //----
                            for case let fileURL as URL in fileList! {
                                if !fileURL.isDirectory {
                                    var document = Document(fileURL: fileURL)
                                    if isFileUnhided(fileURL: fileURL, folderURL: folderURL, sourceType: .folder) {
                                        if isTextDataOk(values: fileURL.lastPathComponent.split(separator: ".")) {
                                           fillDocument(forUrl: fileURL, document: &document)
                                           documents.append(document)
                                        }
                                        print("File_URL:\(fileURL.absoluteString)")
                                    }
                                }
                            }
                            //-----
                       
                        case .filesZip:
                            self.zipFileUrl = pickedURL
                            let document = Document(fileURL: pickedURL)
                            print("Opcjia filesZip")
                            if isFileUnhided(fileURL: pickedURL, folderURL: folderURL, sourceType: .filesZip) {
                                print("Befor append document")
                               //fillDocument(forUrl: pickedURL, document: &document)
                                document.myTexts = ""
                           
                                //====>
                                 self.documentsUnziped = unzip(document: document)
                                documents.append(document)
                                guard URL(string: self.unzipedPathDir) != nil  else {
                                    delegate?.errorZipStructureMessae(message: "Invalid zip")
                                    return
                                }

                                // TODO: pętla
                                //unzipedPathDir = unzip(document: document)
//                                if let url = URL(string: unzipedPathDir) {
//                                    documentsUnziped = documentFromZip(pickedURL: url)
//                                }
//                                else    {
//                                    //Setup.displayToast(forView: self, message: "ERROOOOR", seconds: 3)
//                                    delegate?.errorZipStructureMessae(message: "Invalid zip")
//                                }

                            }
                            else {
                              print("Not append document")
                            }
                    }
                 }
//                catch let error {
//                    print("error:  \(error.localizedDescription)")
//                }
        }
    }
    private func documentsFromLocalURL(pickedURL url: URL)  ->  [Document] {
        //let pictType: Set = ["PNG", "JPG", "BMP"]
        var docs = [Document]()
        //var fileNameAndExt = ["",""]
        let shouldStopAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if shouldStopAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        //pictureLibrary.removeAll()
        NSFileCoordinator().coordinate(readingItemAt: url, error: NSErrorPointer.none) { (folderURL) in
            do {
                let keys: [URLResourceKey] = [.nameKey, .isDirectoryKey] //isDirectoryKey isRegularFileKey
                let fileList = FileManager.default.enumerator(at: url, includingPropertiesForKeys: keys)
                for case let fileURL as URL in fileList! {
                    if !fileURL.isDirectory {
                        var document = Document(fileURL: fileURL)
                        let fileNameAndExt = fileURL.lastPathComponent.split(separator: ".")
                        guard !fileURL.lastPathComponent.hasPrefix(".") else {      continue       }
                        if isTextDataOk(values: fileNameAndExt) {
                            //fileURL.lastPathComponent.split(separator: "."))
                            fillDocument(forUrl: fileURL, document: &document)
                            let subfolderPath = document.fileURL.deletingLastPathComponent()
                            self.unzipedPathDir = subfolderPath.absoluteString
                            print("subfolderPath=\(subfolderPath)")
                           docs.append(document)
                        }
                        else  if isPictureDataOk(values: fileNameAndExt) {
                                fillDocument(forUrl: fileURL, document: &document)
                                docs.append(document)
                        }
                        
                            print("File_URL:\(fileURL.absoluteString)")
                        }

                }

             }
        }
        print("DOCS:\(docs.count)")
        docs.sort {
            $0.fileURL.lastPathComponent < $1.fileURL.lastPathComponent
        }
        return docs
    }
    func documentFromZip(pickedURL: URL) -> [Document]{  //pickedURL: URL,
        var documents_tmp = [Document]()
        let shouldStopAccessing = pickedURL.startAccessingSecurityScopedResource()
        defer {
            if shouldStopAccessing {
                pickedURL.stopAccessingSecurityScopedResource()
            }
        }
        //pictureLibrary.removeAll()
        NSFileCoordinator().coordinate(readingItemAt: pickedURL, error: NSErrorPointer.none) { (folderURL) in
                do {
                    
                    let keys: [URLResourceKey] = [.nameKey, .isDirectoryKey] //isDirectoryKey isRegularFileKey
                    let fileList = FileManager.default.enumerator(at: pickedURL, includingPropertiesForKeys: keys)
                    print("Folder_URL:\(folderURL.absoluteString)")
                    
                        for case let fileURL as URL in fileList!    {
                            if !fileURL.isDirectory {
                                var document = Document(fileURL: fileURL)
                                if isFileUnhided(fileURL: fileURL, folderURL: folderURL, sourceType: .folder) {
                                    fillDocument(forUrl: fileURL, document: &document)
                                    documents_tmp.append(document)
                                    //documents_tmp.appenpid(document)
                                    print("File_Zip_URL:\(fileURL.absoluteString)")
                                }
                                else {
                                    print("NO UNHIDE: File_Zip_URL:\(fileURL.absoluteString)")
                                }
                            }
                            else {
                                print("ERROR: NO DIRECTORY: File_Zip_URL:\(fileURL.absoluteString)")
                            }
                        }  }
            
            }
            documents_tmp.sort {
                $0.fileURL.lastPathComponent < $1.fileURL.lastPathComponent
            }
            //pictureLibrary.removeAll()
        return documents_tmp
    }
 
    func fillDocument(forUrl url: URL, document: inout Document) {
        let tmpName = url.lastPathComponent
        let fileSplitName = splitFilenameAndExtension(fullFileName: tmpName)
        //let fileName = fileSplitName.fileName
        let fileExt = fileSplitName.fileExt
        if fileExt.uppercased() == "TXT" {
            print("to jest TXT")
            let val = getText(fromCloudFilePath: url)
            let txts = val.texts
            let txt = mergeText(forStrings: txts)
            document.myTexts = txt
            document.myCodepage = val.encoding
        }
        if fileExt.uppercased() == "PNG" {
            //document.
            print("to jest PNG")
            print("PNG url:\(url)")
            guard let data = try? Data(contentsOf: url) else { return }
            document.myPictureData = data
            
            if !tmpName.isEmpty {
                pictureLibrary.addData(forName: tmpName, value: data)
            }
            print("COUNT PNG:\(pictureLibrary.count)")
        }
        if fileExt.uppercased() == "JPG" {
            print("to jest JPG")
        }
    }
    func compareUrls(fileURL url: URL, folderURL: URL) -> Bool {
        var retVal = true
        let  urlComponents1 = url.deletingLastPathComponent().pathComponents
        let  urlComponents2 = folderURL.pathComponents
        var pos1 = urlComponents1.count - 1
        var pos2 = urlComponents2.count - 1
        for _ in 0..<3 {
            if urlComponents1[pos1] != urlComponents2[pos2] {
               retVal = false
                break
            }
            pos1 -= 1
            pos2 -= 1
        }
        print("----")
        print("----")
        print("folderURL:\(folderURL.deletingPathExtension())")
        print("fileURL:\(url.deletingLastPathComponent())")
        print("retVal:\(retVal)")
        print("=====")

       return retVal
    }
    func isFileUnhided(fileURL url: URL, folderURL: URL, sourceType: SourceType)  -> Bool {
        let name = url.lastPathComponent
        print("isFileUnhided:\(sourceType),\(url.absoluteString)")

        if name.hasPrefix(".")
        {
            print("Hidden file \(name) not selected")
            self.hiddenFiles += 1
            return false
        }
        print("SourceType:\(sourceType)")
        if sourceType == .filesZip {
            return true
        }
        if !compareUrls(fileURL: url, folderURL: folderURL) {
            return false
        }
        let values =  name.split(separator: ".")
        switch sourceType {
            case .filesTxt:
                print("Txt")
                return isTextDataOk(values: values)
            
            case .filesZip:
                print("Zip")
                //return true
                return  values.last?.uppercased() == "ZIP"

            case .folder:
                print("folder, values[0]:\(values[0])")
                return true
        }
    }
}

//  extension CloudPicker:  {}
extension URL {
    var isDirectory: Bool! {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory
    }
}

//--------

//    class func image(for url: URL, completionHandler: @escaping(_ image: UIImage?) -> ()) {
//      DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
//        if let data = self.cache.object(forKey: url.absoluteString as NSString) {
//          DispatchQueue.main.async { completionHandler(UIImage(data: data as Data)) }
//          return
//        }
//
//        guard let data = NSData(contentsOf: url) else {
//          DispatchQueue.main.async { completionHandler(nil) }
//          return
//        }
//
//        self.cache.setObject(data, forKey: url.absoluteString as NSString)
//        DispatchQueue.main.async { completionHandler(UIImage(data: data as Data)) }
//      }
//    }

//--------


//    private func getTextEncoding(filePath path: URL, defaultEncoding: String.Encoding = .windowsCP1250) -> (encoding: String.Encoding, data: String) {
//        var data: String = "brakUJE"
//
//        let val = tryEncodingFile(filePath: path, encoding: defaultEncoding)
//        data = val.isOk ? val.data : "brakUJE"
//
//        if data == "brakUJE" {
//            print("BRAKUJE: \(path)")
//        }
//        return  (defaultEncoding, data)
//    }


//-------->
//    private func tryEncodingFile999(filePath path: URL, encoding: String.Encoding)  -> (isOk: Bool, data: String) {
//        var texts: [String] = ["brak danych"]
//        var encodingType: String.Encoding = .isoLatin2
//
////        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
//
//            do {
//                let yy = "DDDD"
//                let xxx = try String(contentsOfFile: path.absoluteString, usedEncoding: &encodingType)
//                print(("encoding:\(encodingType.rawValue)"))
//
//
//                let data = try String(contentsOf: path, encoding: encoding)
//                //let data = try String(contentsOfFile: path.absoluteString ,encoding: encoding)
//
//                //let myData = data.components(separatedBy: .newlines)
//                //texts = myData
//                print("text-Cs:\(texts)")
//                return (isOk: true, data: data)
//            }
//            catch let error {
//                print("ENCODE:\(encodingType)")
//                print(error.localizedDescription)
//                return (isOk: false, data: "Error:\(error)")
//            }
// //       }
//
//    }
