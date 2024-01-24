//
//  TestDescriptionViewController.swift
//  testownik
//
//  Created by Slawek Kurczewski on 21/04/2020.
//  Copyright © 2020 Slawomir Kurczewski. All rights reserved.
//

import UIKit

class TestDescriptionViewController: UIViewController {
    var isLikeValue: Bool = false
    var userNameTextFieldValue = ""
    var userDescriptionTextFieldValue = ""
    var categoryLabelValue = ""
    var autoNameLabelValue = ""
    var folderUrlLabelValue = ""
    
    @IBOutlet weak var iLikeImage: UIImageView!
    @IBOutlet weak var imageDescLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userDescriptionTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var autoNameLabel: UILabel!
    @IBOutlet weak var folderUrlLabel: UILabel!
    
    var isLike: Bool = false {
        didSet {
                let image = isLike ? UIImage(named: "thumbs_up_big")?.tintColor(.green) : UIImage(named: "thumbs_down_big")?.tintColor(.red)
                if let image = image {
                    iLikeImage?.image = image
                }
                else {
                    print("Null image")
                }
                imageDescLabel?.text = isLike ? "Favorite test" : "Unfavorite test"
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isLike = isLikeValue
        userNameTextField.text = userNameTextFieldValue
        userDescriptionTextField.text = userDescriptionTextFieldValue
        categoryLabel.text = categoryLabelValue
        autoNameLabel.text = autoNameLabelValue
        folderUrlLabel.text = folderUrlLabelValue
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
