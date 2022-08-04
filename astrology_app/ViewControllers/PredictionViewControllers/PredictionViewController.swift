//
//  PredictionViewController.swift
//  astrology_app
//
//  Created by Bence Palatin on 2021. 03. 06..
//

import UIKit

class PredictionViewController : UIViewController {
    @IBOutlet weak var signImageView: UIImageView!
    @IBOutlet weak var signNameLabel: UILabel!
    @IBOutlet weak var signDateLabel: UILabel!
    @IBOutlet weak var signElementValueLabel: UILabel!
    @IBOutlet weak var signStabilityValueLabel: UILabel!
    @IBOutlet weak var signPlanetValueLabel: UILabel!
    @IBOutlet weak var signPolarityValueLabel: UILabel!
    @IBOutlet weak var predictionTitle: UINavigationItem!
    @IBOutlet weak var predTextView: UITextView!
    
    var predictionObject = predictionModel()
    var matchObject = matchModel()
    var horoscopeObject = horoscopeModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icon = "horoscope_icon_\(predictionObject.selectedSign.lowercased())"
        signImageView.image = UIImage(named: icon)
        signNameLabel.text = predictionObject.selectedSign
        signDateLabel.text = predictionObject.selectedSignProperties["date"]!
        signElementValueLabel.text = predictionObject.selectedSignProperties["element"]!
        signStabilityValueLabel.text = predictionObject.selectedSignProperties["stability"]!
        signPlanetValueLabel.text = predictionObject.selectedSignProperties["planet"]!
        signPolarityValueLabel.text = predictionObject.selectedSignProperties["polarity"]!
        predictionTitle.title = predictionObject.selectedSign
        predTextView.text = (predictionObject.response!["bot_response"] as! String)
        
        
    }
    
    
    @IBAction func backToSignSelector(_ sender: UIBarButtonItem) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
