import Foundation

/// PiwikUserDefaults is a wrapper for the UserDefaults with properties
/// mapping onto values stored in the UserDefaults.
/// All getter and setter are sideeffect free and automatically syncronize
/// after writing.
internal struct PiwikUserDefaults {
    let userDefaults: UserDefaults

    init(suiteName: String?) {
        userDefaults = UserDefaults(suiteName: suiteName)!
    }
    
    var totalNumberOfVisits: Int {
        get {
            return userDefaults.integer(forKey: PiwikUserDefaults.Key.totalNumberOfVisits)
        }
        set {
            userDefaults.set(newValue, forKey: PiwikUserDefaults.Key.totalNumberOfVisits)
            userDefaults.synchronize()
        }
    }
    
    var firstVisit: Date? {
        get {
            return userDefaults.object(forKey: PiwikUserDefaults.Key.firstVistsTimestamp) as? Date
        }
        set {
            userDefaults.set(newValue, forKey: PiwikUserDefaults.Key.firstVistsTimestamp)
            userDefaults.synchronize()
        }
    }
    
    var previousVisit: Date? {
        get {
            return userDefaults.object(forKey: PiwikUserDefaults.Key.previousVistsTimestamp) as? Date
        }
        set {
            userDefaults.set(newValue, forKey: PiwikUserDefaults.Key.previousVistsTimestamp)
            userDefaults.synchronize()
        }
    }
    
    var currentVisit: Date? {
        get {
            return userDefaults.object(forKey: PiwikUserDefaults.Key.currentVisitTimestamp) as? Date
        }
        set {
            userDefaults.set(newValue, forKey: PiwikUserDefaults.Key.currentVisitTimestamp)
            userDefaults.synchronize()
        }
    }
    
    var optOut: Bool {
        get {
            return userDefaults.bool(forKey: PiwikUserDefaults.Key.optOut)
        }
        set {
            userDefaults.set(newValue, forKey: PiwikUserDefaults.Key.optOut)
            userDefaults.synchronize()
        }
    }
    
    var clientId: String? {
        get {
            return userDefaults.string(forKey: PiwikUserDefaults.Key.clientID)
        }
        set {
            userDefaults.setValue(newValue, forKey: PiwikUserDefaults.Key.clientID)
            userDefaults.synchronize()
        }
    }
    
    var visitorUserId: String? {
        get {
            return userDefaults.string(forKey: PiwikUserDefaults.Key.visitorUserID);
        }
        set {
            userDefaults.setValue(newValue, forKey: PiwikUserDefaults.Key.visitorUserID);
            userDefaults.synchronize()
        }
    }
}

extension PiwikUserDefaults {
    internal mutating func migrateFromNilSuite() {
        guard !userDefaults.bool(forKey: "didMigrateFromNilSuite") else {
            // no migration necessary
            return
        }
        totalNumberOfVisits = UserDefaults.standard.integer(forKey: PiwikUserDefaults.Key.totalNumberOfVisits)
        firstVisit = UserDefaults.standard.object(forKey: PiwikUserDefaults.Key.firstVistsTimestamp) as? Date
        previousVisit = UserDefaults.standard.object(forKey: PiwikUserDefaults.Key.previousVistsTimestamp) as? Date
        currentVisit = UserDefaults.standard.object(forKey: PiwikUserDefaults.Key.currentVisitTimestamp) as? Date
        optOut = UserDefaults.standard.bool(forKey: PiwikUserDefaults.Key.optOut)
        clientId = UserDefaults.standard.string(forKey: PiwikUserDefaults.Key.clientID)
        visitorUserId = UserDefaults.standard.string(forKey: PiwikUserDefaults.Key.visitorUserID)
        userDefaults.set(true, forKey: "didMigrateFromNilSuite")
    }
}

extension PiwikUserDefaults {
    internal struct Key {
        static let totalNumberOfVisits = "PiwikTotalNumberOfVistsKey"
        static let currentVisitTimestamp = "PiwikCurrentVisitTimestampKey"
        static let previousVistsTimestamp = "PiwikPreviousVistsTimestampKey"
        static let firstVistsTimestamp = "PiwikFirstVistsTimestampKey"
        
        // Note:    To be compatible with previous versions, the clientID key retains its old value,
        //          even though it is now a misnomer since adding visitorUserID makes it a bit confusing.
        static let clientID = "PiwikVisitorIDKey"
        static let visitorUserID = "PiwikVisitorUserIDKey"
        static let optOut = "PiwikOptOutKey"
    }
}
