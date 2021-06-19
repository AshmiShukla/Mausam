//
//  ViewController.swift
//  Mausam
//
//  Created by ASHMIT SHUKLA on 29/05/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    
    
//    var Weather:WeatherManager
    var location=CLLocationManager()
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var citySearch: UITextField!
    
    var Weather=WeatherManager()
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var tempStickers: UIImageView!
    @IBOutlet weak var city: UILabel!
    
    
    override func viewDidLoad() {
        location.delegate=self
        citySearch.delegate=self
        Weather.delegate=self
        location.requestWhenInUseAuthorization()
        location.requestLocation()
        super.viewDidLoad()
        
    }
    
    @IBAction func currlocation(_ sender: UIButton) {
        location.requestWhenInUseAuthorization()
        location.requestLocation()
    }
    
}

//MARK: - UITextFieldDelegate

extension ViewController:UITextFieldDelegate{
    

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField.text == "")
        {
            textField.placeholder="Type Something...."
                return false
        }
        else
        {
            return true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        citySearch.endEditing(true)

        return true

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        print(citySearch.text!)
        if let city=citySearch.text{
            Weather.fetchWeather(city: city)}
        citySearch.placeholder="Search..."
        citySearch.text=""
    }
    @IBAction func searchcity(_ sender: UITextField) {

    }
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        citySearch.endEditing(true)

    }
}

//MARK: - WeatherManager

extension ViewController:WeatherManagerDelegate{
    func didUpdateWeather(weatherManager:WeatherManager,weather: WeatherModel) {
//        temp.text=weather.temperature
        DispatchQueue.main.async {
            self.temp.text=weather.temperature
            self.tempStickers.image=UIImage(systemName: weather.condtion)
            self.city.text=weather.name
        }
    }
    func didReturnError(error: Error) {
        print(error)
    }
}
//MARK: - Location
extension ViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location=locations.last{
            self.location.stopUpdatingLocation()
            let lat=location.coordinate.latitude
            let lon=location.coordinate.longitude
            Weather.fetchWeather1(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
