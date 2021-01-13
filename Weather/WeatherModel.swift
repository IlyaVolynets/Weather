//
//  WeatherModel.swift
//  Weather
//
//  Created by Ilya Volynets on 1/12/21.
//  Copyright © 2021 Ilya Volynets. All rights reserved.
//

import RealmSwift

class Weather: Object {
    
    @objc dynamic var cityName = ""
    @objc dynamic var cityTemperature = ""
    
}
