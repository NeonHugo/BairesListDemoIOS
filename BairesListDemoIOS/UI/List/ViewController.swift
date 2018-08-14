//
//  ViewController.swift
//  BairesListDemoIOS
//
//  Created by NeoNHugo on 8/13/18.
//  Copyright © 2018 NeoNHugo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var list: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var events = [Event]()
    var eventsFilters = [Event]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createEvents()
        setupSearchBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func createEvents(){

        eventsFilters = events
        
        let post: String = """
                {
                    "startDate": "2018-08-01",
                    "endDate": "2018-08-30",
                    "includeSuggested": "true"
                }
        """
        
        submitPost(post: post)
    }
    
    private func setupSearchBar(){
        searchBar.delegate = self
        searchBar.placeholder = "Event"
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterResults()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterResults()
    }
    
    func filterResults(){
        let opc = searchBar.selectedScopeButtonIndex
        let searchText = searchBar.text ?? ""
        
        switch opc {
        case 1:
            eventsFilters = events.filter { event in
                let isMatchingSearchText =  (event.middleLabel.lowercased().contains(searchText.lowercased())
                    || searchText.count == 0) && event.status == 1
                return isMatchingSearchText
            }
        case 2:
            eventsFilters = events.filter { event in
                let isMatchingSearchText =  (event.middleLabel.lowercased().contains(searchText.lowercased())
                    || searchText.count == 0) && event.like == 1
                return isMatchingSearchText
            }
        default:
            eventsFilters = events.filter { event in
                let isMatchingSearchText =  event.middleLabel.lowercased().contains(searchText.lowercased())
                    || searchText.count == 0
                return isMatchingSearchText
            }
        }
        
        list.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableCell
        
        print(eventsFilters[indexPath.row].image)
        
        cell.middleText.text = eventsFilters[indexPath.row].middleLabel
        cell.bottomText.text = eventsFilters[indexPath.row].bottomLabel
                
        cell.img.downloadImage(from: eventsFilters[indexPath.row].image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = eventsFilters[indexPath.row].status
        
        if (view != 1){
            eventsFilters[indexPath.row].status = 1
        }
    }
    
    func submitPost(post: String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "webservices.vividseats.com"
        urlComponents.path = "/rest/mobile/v1/home/cards"
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        // Specify this request as being a POST method
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["X-Mobile-Platform"] = "iOs"
        
        request.allHTTPHeaderFields = headers
        
        request.httpBody = post.data(using: .utf8)!
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                
                let jsonData = utf8Representation.data(using: .utf8)!
                self.events = try! JSONDecoder().decode([Event].self, from: jsonData)
                
                self.eventsFilters = self.events
                
                DispatchQueue.main.async {
                    self.filterResults()
                }
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    
}

class Event : Codable {
    var topLabel : String
    var middleLabel : String
    var bottomLabel : String
    var eventCount : Int
    var targetId : Int
    var image : String
    var like : Int = 0
    var status : Int = 0
    
    init(topLabel : String, middleLabel : String, bottomLabel : String, eventCount : Int, targetId : Int, image : String) {
        
        self.topLabel = topLabel
        self.middleLabel = middleLabel
        self.bottomLabel = bottomLabel
        self.eventCount = eventCount
        self.targetId = targetId
        self.image = image
    }
    
    private enum CodingKeys: String, CodingKey {
        case topLabel
        case middleLabel
        case bottomLabel
        case eventCount
        case targetId
        case image
    }
}


