//
//  PredictionSceneViewController.swift
//  astrology_app
//
//  Created by Bence Palatin on 2021. 03. 06..
//

import UIKit

class PredictionSceneViewController : UIViewController {
    @IBOutlet weak var predTypeSelection: UISegmentedControl!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dailyView: UIView!
    @IBOutlet weak var dailyDatePicker: UIDatePicker!
    @IBOutlet weak var weeklyView: UIView!
    @IBOutlet weak var WeekSelection: UISegmentedControl!
    @IBOutlet weak var NumerologyView: UIView!
    @IBOutlet weak var numerologyNameInput: UITextField!
    @IBOutlet weak var numerologyDatePicker: UIDatePicker!
    @IBOutlet weak var ZodiacSelectorButton: UIButton!
    @IBOutlet weak var NumerologyButton: UIButton!
    
    let predTypes = ["Daily Sun Prediction","Daily Moon Prediction", "Weekly Sun Prediction", "Weekly Moon Prediction", "Numerology"]
    var predictionObject = predictionModel()
    var filledData : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(predictionObject.description)
        
        predTypeSelection.removeAllSegments()
        
        for index in 0..<predTypes.count {
            predTypeSelection.insertSegment(withTitle: predTypes[index], at: index, animated: false)
        }
        dailyDatePicker.minimumDate = Date()
        dailyDatePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        //print(predictionObject.description)
        predTypeSelection.selectedSegmentIndex = 0
        typeLabel.text = predTypeSelection.titleForSegment(at: predTypeSelection.selectedSegmentIndex)
        predictionObject.predType = GetPredictionType(value: predTypeSelection.selectedSegmentIndex)
        predictionObject.selectedInterval = "thisweek"
        NumerologyButton.isHidden = true
        numerologyDatePicker.maximumDate = Date()
    }
    
    @IBAction func weekSegmentControlValueChanged(sender: UISegmentedControl) {
        if WeekSelection.selectedSegmentIndex == 0 {
            predictionObject.selectedInterval = "thisweek"
        } else {
            predictionObject.selectedInterval = "nextweek"
        }
        //print(predictionObject.description)
    }
    
    @IBAction func typeSegmentControlValueChanged(sender: UISegmentedControl) {
        typeLabel.text = predTypeSelection.titleForSegment(at: predTypeSelection.selectedSegmentIndex)
        if predTypeSelection.selectedSegmentIndex < 2 {
            dailyView.isHidden = false
            weeklyView.isHidden = true
            NumerologyView.isHidden = true
            NumerologyButton.isHidden = true
            ZodiacSelectorButton.isHidden = false
        } else if predTypeSelection.selectedSegmentIndex < 4 {
            dailyView.isHidden = true
            weeklyView.isHidden = false
            NumerologyView.isHidden = true
            NumerologyButton.isHidden = true
            ZodiacSelectorButton.isHidden = false
        } else {
            dailyView.isHidden = true
            weeklyView.isHidden = true
            NumerologyView.isHidden = false
            ZodiacSelectorButton.isHidden = true
            NumerologyButton.isHidden = false
        }
        predictionObject.predType = GetPredictionType(value: predTypeSelection.selectedSegmentIndex)
        //print(predictionObject.description)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? ZodiacSignViewController {
            vc.predictionObject = predictionObject
        }
        if let vc = segue.destination as? NumerologyViewController {
            vc.predictionObject = predictionObject
        }
    }
    
    @IBAction func numerologyButtonPressed(_ sender: UIButton) {
        //print("Name: \(numerologyNameInput.text!) - Index: \(predTypeSelection.selectedSegmentIndex)")
        if numerologyNameInput.text! != "" && predTypeSelection.selectedSegmentIndex == 4 {
            predictionObject.name = numerologyNameInput.text!
            predictionObject.selectedDate = FormatDate(inputDate: numerologyDatePicker.date)
            
            //print(predictionObject.description)
            NetworkManager.fetchPrediction(model: predictionObject) { [self] result in
                //feldolgozni a json-t itt
                
                predictionObject.response = result
                //print(self.predRSP)
                DispatchQueue.main.async {
                    //disableAlert()
                    performSegue(withIdentifier: "numerologyPreviewSegue", sender: self)
                }
            }
            presentAlert(msg: "Please Wait...", needButton: false)
        } else {
            presentAlert(msg: "Please fill your name in the box.", needButton: true)
        }
    }
    @IBAction func ZodiacButtonPressed(_ sender: UIButton) {
        if predTypeSelection.selectedSegmentIndex < 4 {
            if predTypeSelection.selectedSegmentIndex < 2 {
                predictionObject.selectedDate = FormatDate(inputDate: dailyDatePicker.date)
            }
        }
        //print(predictionObject.description)
        self.performSegue(withIdentifier: "zodiacSegue", sender: self)
    }
    
    func FormatDate(inputDate : Date) -> String {
        //print("dátum: \(inputDate)")
        let date = dailyDatePicker.date
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/YYYY"
        let formattedDate = dateFormatterPrint.string(from: date)
        //print(formattedDate)
        return formattedDate
    }
    
    func GetPredictionType(value : Int) -> String{
        switch value {
        case 0:
            return "dailysun"
        case 1:
            return "dailymoon"
        case 2:
            return "weeklysun"
        case 3:
            return "weeklymoon"
        case 4:
            return "numerology"
        default:
            return ""
        }
    }
    func presentAlert(msg: String, needButton: Bool) {
        let myAlert = UIAlertController(title: "", message:msg, preferredStyle: UIAlertController.Style.alert);
        if needButton {
            let okAction = UIAlertAction(title:"Ok", style:UIAlertAction.Style.default, handler:nil);
            myAlert.addAction(okAction);
        }
        self.present(myAlert, animated:true, completion:nil);
    }
    func disableAlert(){
        self.dismiss(animated: true, completion: nil)
    }
}

