//
//  TabBarControler.swift
//  testownik
//
//  Created by Sławek K on 24/08/2023.
//  Copyright © 2023 Slawomir Kurczewski. All rights reserved.
//

import UIKit

class TabBarControler: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBar.items?.count == 4 {
            self.tabBar.items?[3].badgeValue = "77 %"
            self.tabBar.items?[3].title = Setup.placeHolderRatings
        }
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
