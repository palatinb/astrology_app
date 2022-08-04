//
//  MatchSceneViewController.swift
//  astrology_app
//
//  Created by Bence Palatin on 2021. 03. 07..
//

import UIKit

class MatchSceneViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var responeTextView: UITextView!
    @IBOutlet weak var responseImageView: UIImageView!
    @IBOutlet weak var boySignTextField: UITextField!
    @IBOutlet weak var girlSignTextField: UITextField!
    
    var boySelectedSign: Dictionary<String, [String : String]>.Element?
    var girlSelectedSign: Dictionary<String, [String : String]>.Element?
    var matchmodel = matchModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreValueLabel.text = ""
        responeTextView.text = ""
        scoreLabel.isHidden = true
        scoreValueLabel.isHidden = true
        responeTextView.isHidden = true
        
        createBoyPickerView()
        dismissBoyPickerView()
        
        createGirlPickerView()
        dismissGirlPickerView()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if matchmodel.boy_sign != "" && matchmodel.girl_sign != "" {
            NetworkManager.fetchMatching(model: matchmodel) { [self] result in
                
                matchmodel.response = result
                //print(self.predRSP)
                
                DispatchQueue.main.async {
                    disableAlert()
                    scoreLabel.isHidden = false
                    scoreValueLabel.isHidden = false
                    responeTextView.isHidden = false
                    let score = matchmodel.response!["score"] as! Int
                    scoreValueLabel.text = String(score)
                    responeTextView.text = (matchmodel.response!["bot_response"] as! String)
                }
            }
            presentAlert(msg: "Please Wait...", needButton: false)
        } else {
            presentAlert(msg: "Please choose the boy and girl sign too.", needButton: true)
        }
    }
    
    func createBoyPickerView() {
        let bpickerView = UIPickerView()
        bpickerView.tag = 2
        bpickerView.delegate = self
        boySignTextField.inputView = bpickerView
    }
    func dismissBoyPickerView() {
        let btoolBar = UIToolbar()
        btoolBar.sizeToFit()
        let bbutton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.boyaction))
        btoolBar.setItems([bbutton], animated: true)
        btoolBar.isUserInteractionEnabled = true
        boySignTextField.inputAccessoryView = btoolBar
    }
    @objc func boyaction() {
        view.endEditing(true)
    }
    
    func createGirlPickerView() {
        let gpickerView = UIPickerView()
        gpickerView.tag = 1
        gpickerView.delegate = self
        girlSignTextField.inputView = gpickerView
    }
    func dismissGirlPickerView() {
        let gtoolBar = UIToolbar()
        gtoolBar.sizeToFit()
        let gbutton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.girlaction))
        gtoolBar.setItems([gbutton], animated: true)
        gtoolBar.isUserInteractionEnabled = true
        girlSignTextField.inputAccessoryView = gtoolBar
    }
    @objc func girlaction() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return signProperties.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(signProperties)[row].key
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 2 {
            boySelectedSign = Array(signProperties)[row]
            matchmodel.boy_sign =  boySelectedSign!.value["value"]
            boySignTextField.text = boySelectedSign!.key
        } else {
            girlSelectedSign = Array(signProperties)[row]
            matchmodel.girl_sign =  girlSelectedSign!.value["value"]
            girlSignTextField.text = girlSelectedSign!.key
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
