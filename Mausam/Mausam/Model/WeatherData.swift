//
//  WeatherData.swift
//  Mausam
//
//  Created by ASHMIT SHUKLA on 14/06/21.
//

import Foundation
struct WeatherData: Decodable {
    let name : String
    let id : Int
    let main:main
    let weather:[Weather]
}
struct main:Decodable {
    let temp:Double
}
struct Weather:Decodable {
    let id:Int
    let main:String
    let description:String
    let icon:String
}
