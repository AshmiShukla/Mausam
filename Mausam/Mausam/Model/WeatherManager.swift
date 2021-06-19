//
//  WeatherManager.swift
//  Mausam
//
//  Created by ASHMIT SHUKLA on 03/06/21.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func didUpdateWeather(weatherManager:WeatherManager,weather:WeatherModel)
    func didReturnError(error:Error)
    }
struct  WeatherManager {
    var delegate:WeatherManagerDelegate?
    
    let Weatherurl="https://api.openweathermap.org/data/2.5/weather?appid=bb8a831d09bb46a1949287379a6f9234&units=metric"
    
    func fetchWeather(city:String)  {
        let urlString="\(Weatherurl)&q=\(city)"
        //        print(urlString)
        performRequest(urlString: urlString)
    }
    func fetchWeather1(latitude:CLLocationDegrees,longitude:CLLocationDegrees)  {
        let urlString="\(Weatherurl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString :String)  {
        //Create url
        if let  url=URL(string: urlString){
            
            //create Session
            let session = URLSession(configuration: .default)
            //Give session a task
            let task = session.dataTask(with: url) { Data, response, error in
                if error != nil
                {
                    print(error!)
                    
                    self.delegate?.didReturnError(error: error!)
                    return
                
                }
                if let safeData = Data{
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString!)
                    if let WeatherModel=self.parseJson(weatherData: safeData){
                        self.delegate?.didUpdateWeather(weatherManager:self,weather:WeatherModel)
                    }
                }
            }
            //start task
            task.resume()
        }
        
    }
    func parseJson(weatherData:Data)->WeatherModel?  {
        let decoder=JSONDecoder()
        do{
           let decodedata=try decoder.decode(WeatherData.self, from: weatherData)
//            print(decodedata.weather.)
//            print(decodedata.id)
            let id=decodedata.weather[0].id
            let temp=decodedata.main.temp
            let cityName=decodedata.name
            let Model=WeatherModel(name: cityName, id: id, temp: temp)
//            print(Model.condtion)
//            print(Model.temperature)
            return Model
            
//            let condition=getWeatherCondition(id: id)
//            print(condition)
            
        }
        catch{
//            print(error)
            self.delegate?.didReturnError(error: error)
            return nil
        }
    }
}
