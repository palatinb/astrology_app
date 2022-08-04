//
//  HoroscopeSceneViewController.swift
//  astrology_app
//
//  Created by Bence Palatin on 2021. 03. 08.
//

import UIKit
import MapKit


class HoroscopeSceneViewController : UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate {
    @IBOutlet weak var dandtobPicker: UIDatePicker!
    @IBOutlet weak var mapView: MKMapView!
    
    var horoscopemodel = horoscopeModel()
    var res:String = ""
    var responsesCoount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        var  mapRegion : MKCoordinateRegion = MKCoordinateRegion()
        mapRegion.center = CLLocationCoordinate2D(latitude:47.499444,longitude: 19.046255)
        mapRegion.span.latitudeDelta = 0.2;
        mapRegion.span.longitudeDelta = 0.2;
        
        mapView.setRegion(mapRegion, animated: true)
        
        
        let lpgr = UILongPressGestureRecognizer(target: self,
                                                action:#selector(self.handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mapView.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            return
        }
        else if gestureRecognizer.state != UIGestureRecognizer.State.began {
            
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            
            let touchMapCoordinate =  self.mapView.convert(touchPoint, toCoordinateFrom: mapView)
            horoscopemodel.latitude = touchMapCoordinate.latitude
            horoscopemodel.longitude = touchMapCoordinate.longitude
            NetworkManager.fetchTimeZone(model: horoscopemodel){ [self] result in
                
                horoscopemodel.timezone = result
                //print("horoscope timezone: \(horoscopemodel.timezone!)")
            }
            let yourAnnotation =  MKPointAnnotation()
            yourAnnotation.subtitle = "You long pressed here"
            yourAnnotation.coordinate = touchMapCoordinate
            self.mapView.addAnnotation(yourAnnotation)
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if horoscopemodel.latitude != nil {
            horoscopemodel.dateOfBith = FormatDate(inputDate: dandtobPicker.date)
            horoscopemodel.timeOfBirth = FormatTime(inputDate: dandtobPicker.date)
            NetworkManager.fetchHoroscope(model: horoscopemodel){ [self] result in
                
                res = result
                DispatchQueue.main.async {
                    disableAlert()
                    presentAlert(msg: res,needButton: true)
                }
            }
            presentAlert(msg: "Please wait...",needButton: false)
        } else {
            presentAlert(msg: "Please choose your location on the map with a long press.", needButton: true)
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
    
    func FormatDate(inputDate : Date) -> String {
        //print("dátum: \(inputDate)")
        let date = inputDate
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/YYYY"
        let formattedDate = dateFormatterPrint.string(from: date)
        //print(formattedDate)
        return formattedDate
    }
    func FormatTime(inputDate : Date) -> String {
        //print("Idő: \(inputDate)")
        let date = inputDate
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm"
        let formattedTime = dateFormatterPrint.string(from: date)
        //print(formattedTime)
        return formattedTime
    }
}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
