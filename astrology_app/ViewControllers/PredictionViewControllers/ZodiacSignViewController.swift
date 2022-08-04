//
//  ZodiacSignViewController.swift
//  astrology_app
//
//  Created by Bence Palatin on 2021. 03. 06..
//

import UIKit

class ZodiacSignViewController : UIViewController {
    
    var predictionObject = predictionModel()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? PredictionViewController {
            vc.predictionObject = predictionObject
        }
    }
    @IBAction func CancelPredictions(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func horoscopeButtonPressed(_ sender: UIButton) {
        
        predictionObject.selectedSign = sender.titleLabel!.text!
        predictionObject.selectedSignProperties = signProperties[predictionObject.selectedSign]!
        predictionObject.zodiac = predictionObject.selectedSignProperties["value"]
        //print(predictionObject.description)
        NetworkManager.fetchPrediction(model: predictionObject) { [self] result in
            
            predictionObject.response = result
            //print(self.predRSP)
            DispatchQueue.main.async {
                performSegue(withIdentifier: "zodiacSignSelected", sender: self)
            }
        }
        presentAlert(msg: "Please wait...")
    }
    func presentAlert(msg: String) {
        let myAlert = UIAlertController(title: "", message:msg, preferredStyle: UIAlertController.Style.alert);
        self.present(myAlert, animated:true, completion:nil);
    }
    func disableAlert(){
        self.dismiss(animated: true, completion: nil)
    }
}
