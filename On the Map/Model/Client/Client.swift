//
//  Client.swift
//  On the Map
//
//  Created by Jae Paek on 4/19/20.
//  Copyright © 2020 Jae Paek. All rights reserved.
//

import Foundation

class Client {
    struct Auth {
        static var requestToken = ""
        static var sessionId = ""
    }
    
    struct Location {
        static var objectId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case session
        case getStudentInformation
        case setStudentInformation
        case updateStudentInformation(String)
        
        
        var stringValue: String {
            switch self {
            case .session:
                return Endpoints.base + "/session"
            case .getStudentInformation:
                return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=100"
            case .setStudentInformation:
                return Endpoints.base + "/StudentLocation"
            case .updateStudentInformation(let objectId):
                return Endpoints.base + "/StudentLocation/\(objectId)"
            }
            
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OnTheMapResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(error)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            print(data)
            let newData: Data
            if data.starts(with: Data("{".utf8)) {
                print("Valid JSON")
                newData = data
            }
            else {
                print("Invalid JSON")
                let range = 5..<data.count
                newData = data.subdata(in: range)
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OnTheMapResponse.self, from: newData) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OnTheMapResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let udacityCredential = UdacityLoginRequest(username: username, password: password)
        let body = LoginRequest(udacity: udacityCredential)
        taskForPOSTRequest(url: Endpoints.session.url, responseType: LoginResponse.self, body: body) { response, error in
            if let response = response {
                if let error = response.error {
                    print(error)
                    completion(false, LoginError.error(message: error))
                }
                else {
                    print(response)
                    Auth.sessionId = response.session!.id
                    completion(true, nil)
                }
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(false, error)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            Auth.sessionId = ""
            completion(true, nil)
        }
        task.resume()

    }
    
    class func getStudentInformation(completion: @escaping ([StudentInformation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentInformation.url, responseType: StudentInformationResponse.self, completion: {response, error in
            if let response = response {
                completion(response.results, nil)
            }
            else {
                completion([], error)
            }
        })
    }
    
    class func setStudentInformation(location: StudentInformation, completion: @escaping(Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.setStudentInformation.url, responseType: LocationResponse.self, body: location, completion: {response, error in
            if let response = response {
                Location.objectId = response.objectId
                var studentLocation = location
                studentLocation.objectId = response.objectId
                studentLocation.createdAt = response.createdAt
                studentLocation.updatedAt = response.createdAt
                StudentModel.students.insert(studentLocation, at: 0)
                print(StudentModel.students)
                completion(true, nil)
            }
            else {
                completion(false, error)
            }
        })
    }
    
    class func updateStudentInformation(location: StudentInformation, completion: @escaping(Bool, Error?) -> Void) {
        
        taskForPUTRequest(url: Endpoints.updateStudentInformation(Location.objectId).url, responseType: LocationResponse.self, body: location, completion: {response, error in
            if let response = response {
                print(response)
                StudentModel.students = StudentModel.students.filter{ $0.objectId != Location.objectId}
                StudentModel.students.insert(location, at: 0)
                completion(true, nil)
            }
            else {
                completion(false, error)
            }
        })
    }
    
    class func createLocationObject(latitude: Double, longitude: Double, location: String, url: String) -> StudentInformation {
        let studentInformation = StudentInformation(firstName: "Joseph", lastName: "Johnson", longitude: longitude, latitude: latitude, mapString: location, mediaURL: url, uniqueKey: Auth.sessionId, objectId: nil, createdAt: nil, updatedAt: nil)
        return studentInformation
    }
    
    
    
    enum LoginError: LocalizedError {
        case error(message: String)
        
        var errorDescription: String?{
            switch self {
            case let .error(message):
                return message
            }
            
        }
    }
    
    
}
