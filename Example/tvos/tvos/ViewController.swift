//
//  ViewController.swift
//  tvos
//
//  Created by Cornelius Horstmann on 05.06.17.
//  Copyright © 2017 Piwik. All rights reserved.
//

import UIKit
import PiwikTracker

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        PiwikTracker.shared.track(view: ["start"])
        PiwikTracker.shared.dispatch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
