//
//  WeatherData.swift
//  Clima
//
//  Created by Vineal Viji Varghese on 11/07/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
struct WeatherData:Codable {
    let name:String
    let main:Main
    let weather:[Wheather]
}

struct Main:Codable {
    let temp: Double
}

struct Wheather:Codable{
    let description:String
    let id:Int
}
