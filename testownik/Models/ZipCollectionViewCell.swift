//
//  ZipCollectionViewCell.swift
//  testownik
//
//  Created by Slawek Kurczewski on 24/03/2020.
//  Copyright © 2020 Slawomir Kurczewski. All rights reserved.
//

import UIKit

class ZipCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    func configure(document: CloudPicker.Document) {
        self.titleLabel.text = document.fileURL.lastPathComponent
        self.setGradientBackgroundColor(colorOne: Colors().randomColors.first!, colorTwo: Colors().randomColors.last!)
    }
}

