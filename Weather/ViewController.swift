//
//  ViewController.swift
//  Weather
//
//  Created by Ilya Volynets on 1/2/21.
//  Copyright © 2021 Ilya Volynets. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController{
    
    let realm = try! Realm()
    var weatherArray : Results<Weather>!

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        weatherArray = realm.objects(Weather.self)
        
        self.weatherCollectionView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellWithReuseIdentifier: "WeatherCell")
        self.weatherCollectionView.dataSource = self
        self.weatherCollectionView.delegate = self
    }
    
    
    
    @IBAction func addButton(_ sender: UIButton) {
        
        let value = Weather(value: [cityLabel.text!, temperatureLabel.text!])
        try! realm.write {
            realm.add(value)
            weatherCollectionView.reloadData()
       }
    }
    
}

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        
        let urlString = "https://api.weatherapi.com/v1/current.json?key=063a9294bb3548148f4185429211001&q=\(searchBar.text!)"
        
        let url = URL(string: urlString)
        var locationName : String?
        var temperature : Double?
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let location = json["location"]{
                    locationName = location["name"] as? String
                }
                    
                if let current = json["current"]{
                    temperature = current["temp_c"] as? Double
                }
                DispatchQueue.main.async {
                    self.cityLabel.text = locationName
                    self.temperatureLabel.text = "\(temperature!)"
                }
                
            }
            catch let jsonError{
                print(jsonError)
            
            }
        }
        
        task.resume()
        
    }
}

extension ViewController: UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        let wtr = weatherArray[indexPath.row]
        
        cell.printLabel.text = "Город:\(wtr.cityName)   Температура: \(wtr.cityTemperature)"
        
        
        return cell
    }
   
}
