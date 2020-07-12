//
//  WeatherManager.swift
//  Clima
//
//  Created by Vineal Viji Varghese on 11/07/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager,weather:WeatherModel)
    func didFailWithError(error:Error)
}
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=332f0faaa9bdd03b58199b1d5c56dc24&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String)  {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString!)
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather:weather)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ weatherData:Data) -> WeatherModel?{
        let decode = JSONDecoder()
        do{
            let decodedData = try decode.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name =  decodedData.name
            let weather = WeatherModel(conditionID: id, cityName: name, temprature: temp)
            print(weather.conditionName)
            print(weather.temprature)
            print(weather.tempratureString)
            return weather
        }catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
