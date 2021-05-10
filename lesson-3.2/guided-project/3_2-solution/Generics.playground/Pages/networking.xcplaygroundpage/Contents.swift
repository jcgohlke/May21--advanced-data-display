/*
 Copyright © 2020 Apple Inc.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit
import PlaygroundSupport

protocol APIRequest {
  associatedtype Response
  
  var urlRequest: URLRequest { get }
  func decodeResponse(data: Data) throws -> Response
}

struct PhotoInfo: Codable {
  var title: String
  var description: String
  var url: URL
  var copyright: String?
  
  enum CodingKeys: String, CodingKey {
    case title
    case description = "explanation"
    case url
    case copyright
  }
}

func sendRequest<Request: APIRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
  let task = URLSession.shared.dataTask(with: request.urlRequest) { data, response, error in
    if let data = data {
      do {
        let decodedResponse = try request.decodeResponse(data: data)
        completion(.success(decodedResponse))
      } catch {
        completion(.failure(error))
      }
    } else if let error = error {
      completion(.failure(error))
    }
  }
  
  task.resume()
}

struct PhotoInfoAPIRequest: APIRequest {
  var apiKey: String
  
  var urlRequest: URLRequest {
    var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
    urlComponents.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
    
    return URLRequest(url: urlComponents.url!)
  }
  
  func decodeResponse(data: Data) throws -> PhotoInfo {
    let photoInfo = try JSONDecoder().decode(PhotoInfo.self, from: data)
    return photoInfo
  }
}

struct ImageAPIRequest: APIRequest {
  enum ResponseError: Error {
    case invalidImageData
  }
  
  let url: URL
  
  var urlRequest: URLRequest {
    return URLRequest(url: url)
  }
  
  func decodeResponse(data: Data) throws -> UIImage {
    guard let image = UIImage(data: data) else {
      throw ResponseError.invalidImageData
    }
    
    return image
  }
}

PlaygroundPage.current.needsIndefiniteExecution = true
let photoInfoRequest = PhotoInfoAPIRequest(apiKey: "DEMO_KEY")
sendRequest(photoInfoRequest) { result in
  switch result {
    case .success(let photoInfo):
      print(photoInfo)
      let imageRequest = ImageAPIRequest(url: photoInfo.url)
      sendRequest(imageRequest) { imageResult in
        switch imageResult {
          case .success(let image):
            image
          case .failure(let error):
            print(error)
        }
        PlaygroundPage.current.finishExecution()
      }
    case .failure(let error):
      print(error)
      PlaygroundPage.current.finishExecution()
  }
}

// Non-generic implementations
func fetchPhotoInfo(completion: @escaping (Result<PhotoInfo, Error>) -> Void) {
  var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
  urlComponents.queryItems = [URLQueryItem(name: "api_key", value: "DEMO_KEY")]
  
  let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
    let jsonDecoder = JSONDecoder()
    if let data = data {
      do {
        let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
        completion(.success(photoInfo))
      } catch {
        completion(.failure(error))
      }
    } else if let error = error {
      completion(.failure(error))
    }
  }
  
  task.resume()
}

enum PhotoInfoError: Error, LocalizedError {
    case imageDataMissing
}

func fetchImage(from url: URL, completion: @escaping
   (Result<UIImage, Error>) -> Void) {
    var urlComponents = URLComponents(url: url,
       resolvingAgainstBaseURL: true)
    urlComponents?.scheme = "https"
  
    let task = URLSession.shared.dataTask(with:
       urlComponents!.url!) { (data, response, error) in
        if let data = data, let image = UIImage(data: data) {
            completion(.success(image))
        } else if let error = error {
            completion(.failure(error))
        } else {
            completion(.failure(PhotoInfoError.imageDataMissing))
        }
    }
  
    task.resume()
}
