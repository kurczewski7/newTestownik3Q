//
//  DetailViewController.swift
//  SwiftyDocPicker
//
//  Created by Slawek Kurczewski on 04/03/2020.
//  Copyright © 2020 Abraham Mangona. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, GesturesDelegate {
    func addAllRequiredGestures(sender: Gestures) {
        sender.addCustomGesture(.tap, forView: self.view)
    }
    func swipeRefreshLabel(sender: UISwipeGestureRecognizer, directions: [UISwipeGestureRecognizer.Direction]) {
    }
    func tapRefreshUI(sender: UITapGestureRecognizer) {
    }
    func forcePressRefreshUI(sender: ForcePressGestureRecognizer) {    
    }
    
    // MARK: Parameters for segue value
    var gestures = Gestures()
    var cloudPickerValue: CloudPicker!
    var documentsValue : [CloudPicker.Document] = []
    //var dataValue: Data? = nil
    var indexpathRow: Int = 0
    var imageOffSwitch = false
    var pictureValue: UIImage?
    var totalItem: Int {
        get {            return documentsValue.count        }
    }
    var fileExtensionValue = "" {
        didSet {
            imageOffSwitch = fileExtensionValue == "TXT"
            refreshView()
        }
    }
    // MARK: IBOutlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var picture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestures.setView(forView: view)
        gestures.delegate  = self
        gestures.addSwipeGestureToView(direction: .right)
        gestures.addSwipeGestureToView(direction: .left)
        refreshTextContent(forRow: indexpathRow)
        print("=================\nDetailViewController, self.indexpathRow :\(self.indexpathRow)")
    }
    // MARK: - Gesture delegate methods
    @IBAction func switchPicture(_ sender: UIBarButtonItem) {
        imageOffSwitch.toggle()
        refreshView()
    }
    func longPressRefreshUI(sender: UILongPressGestureRecognizer) {
    }

    func pinchRefreshUI(sender: UIPinchGestureRecognizer) {
        print("pinchRefreshUI")
    }
    func eadgePanRefreshUI() {
        print("eadgePanRefreshUI")
    }
    func swipeRefreshUI(direction: UISwipeGestureRecognizer.Direction) {
        var newRow = self.indexpathRow
        switch direction {
            case .right:
                 newRow -= newRow > 0 ? 1 : 0
                refreshTextContent(forRow: newRow)
                print("Swipe to right")
            case .left:
                 newRow += (newRow < self.totalItem - 1) ? 1 : 0
                refreshTextContent(forRow: newRow)
                print("Swipe  & left ")
            default:
                print("Swipe unrecognized")
            }
         self.indexpathRow =  newRow
    }
    func refreshView() {
        textView?.isHidden = !imageOffSwitch
        picture?.isHidden = imageOffSwitch
    }
    func refreshTextContent(forRow newRow: Int) {
        // let newRow = self.indexpathRow
        if newRow < documentsValue.count {
            let document = documentsValue[newRow]
            self.textView?.text = document.myTexts
            self.descriptionLabel?.text = document.fileURL.lastPathComponent + "   (\(newRow+1)/\(self.totalItem))"
            self.fileExtensionValue = self.cloudPickerValue.splitFilenameAndExtension(fullFileName: document.fileURL.lastPathComponent).fileExt
            if let data = document.myPictureData {
               self.picture?.image = UIImage(data:  data)
            }
        }
        self.indexpathRow = newRow
    }
}

