//
//  Model.swift
//  UpworkTest
//
//  Created by SELCUK YILDIZ on 13.01.23.
//

import Foundation
import CoreLocation



enum CustomError : Error {
    case badFormattedURL 
}


struct Results: Codable {
    let results: [User]
}

struct User: Codable, Identifiable, Hashable {
   
    var id : String {
        login.uuid
    }
    
    
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob: Dob
    let registered: Registered
    let phone: String
    let cell: String
    let picture: Picture
    let nat: String
    var fav : Bool?
    
    var fullName : String {
        name.first + " " + name.last
    }
    
    var fullAddress : String {
     location.state + ", " +  location.city + ", " + location.street.name + " / " + "\(location.street.number)"
        
    }
    
    var registrationDateString : String {
        let dateString = "1986-02-08T21:36:42.860Z"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: date ?? Date())
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(login.uuid)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.login.uuid == rhs.login.uuid
    }
    
    
    func isNear(of user : User) -> Bool {
        let userLocation = CLLocation(latitude: user.location.coordinates.latitude.toDouble(), longitude: user.location.coordinates.longitude.toDouble())
        let myLocation = CLLocation(latitude: location.coordinates.latitude.toDouble(), longitude: location.coordinates.longitude.toDouble())
        
        
        return  myLocation.distance(from: userLocation) < 2500000

    }
    
    

}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct Location: Codable {
    let street: Street
    let city: String
    let state: String
    let country: String
    let coordinates: Coordinates
    let timezone: Timezone
}

struct Street: Codable {
    let number: Int
    let name: String
}

struct Coordinates: Codable {
    let latitude: String
    let longitude: String
}

struct Timezone: Codable {
    let offset: String
    let description: String
}

struct Login: Codable {
    let uuid: String
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
}

struct Dob: Codable {
    let date: String
    let age: Int
}

struct Registered: Codable {
    let date: String
    let age: Int
}

struct ID: Codable {
    
    let name: String
    let value: String?
}

struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}



struct DummyModels {
    static let user = User(gender: "male", name: Name(title: "Mr", first: "Joshua", last: "Singh"), location: Location(street: Street(number: 3110, name: "Hillsborough Road"), city: "Palmerston North", state: "Bay of Plenty", country: "New Zealand", coordinates: Coordinates(latitude: "53.7091", longitude: "-147.6261"), timezone: Timezone(offset: "+5:45", description: "Kathmandu")), email: "joshua.singh@example.com", login: Login(uuid: "9ab4691f-19fe-4a6d-9a4b-e0d01a34c61b", username: "crazypanda930", password: "palmtree", salt: "eJ95NA2e", md5: "6f7887666e7a56cc61f803aeb7191280", sha1: "9a131260a163a5b60b9be5eaa32534db9fd43c48", sha256: "2284c0a3aae1f959208c01275d6521c6f804a60dc030d56f5e72d596c5848770"), dob: Dob(date: "1946-03-28T16:02:30.843Z", age: 76), registered: Registered(date: "2019-10-17T11:23:47.390Z", age: 3), phone: "(062)-374-0716", cell: "(735)-970-2103", picture: Picture(large: "https://randomuser.me/api/portraits/men/5.jpg", medium: "https://randomuser.me/api/portraits/med/men/5.jpg", thumbnail: "https://randomuser.me/api/portraits/thumb/men/5.jpg"), nat: "NZ")
}



enum SortOption : String, CaseIterable {
    case name
    case gender
}


extension String {
    
    func toDouble() -> Double {
        Double(self) ?? 0
    }
}
