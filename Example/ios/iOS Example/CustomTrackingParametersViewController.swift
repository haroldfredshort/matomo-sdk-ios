import UIKit
import PiwikTracker

class CustomTrackingParametersViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PiwikTracker.shared.track(view: ["menu","custom tracking parameters"])
    }
    
    @IBAction func didTapSendDownloadEvent(_ sender: UIButton) {
        let downloadURL = URL(string: "https://builds.piwik.org/piwik.zip")!
        let event = Event(tracker: PiwikTracker.shared, action: ["menu", "custom tracking parameters"], url: downloadURL, customTrackingParameters: ["download": downloadURL.absoluteString])
        PiwikTracker.shared.track(event)
    }

}

