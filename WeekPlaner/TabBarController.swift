//
//  TabBarController.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 05.07.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(tabBar.items)
        
        for item in tabBar.items! {
            item.accessibilityIdentifier = "tabBar\(item.accessibilityLabel!)"
            item.accessibilityLabel = "tabBar\(item.accessibilityLabel!)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
