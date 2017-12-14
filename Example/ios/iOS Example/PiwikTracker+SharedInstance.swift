//
//  PiwikTracker+SharedInstance.swift
//  ios
//
//  Created by Cornelius Horstmann on 14.12.17.
//  Copyright © 2017 Mattias Levin. All rights reserved.
//

import Foundation
import PiwikTracker

extension PiwikTracker {
    static let shared: PiwikTracker = {
        let piwikTracker = PiwikTracker(siteId: "23", baseURL: URL(string: "https://demo2.piwik.org/piwik.php")!)
        piwikTracker.logger = DefaultLogger(minLevel: .info)
        piwikTracker.migrateFromFourPointFourSharedInstance()
        return piwikTracker
    }()
    
    private func migrateFromFourPointFourSharedInstance() {
        guard !UserDefaults.standard.bool(forKey: "migratedFromFourPointFourSharedInstance") else { return }
        copyFromOldSharedInstance()
        UserDefaults.standard.set(true, forKey: "migratedFromFourPointFourSharedInstance")
    }
}
