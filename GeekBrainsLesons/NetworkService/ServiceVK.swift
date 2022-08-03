//
//  ServiceVK.swift
//  GeekBrainsLesons
//
//  Created by Олег Ганяхин on 14.02.2022.
//

import Foundation

enum ApiMethods: String {
	case friendsGet = "/method/friends.get"
}

enum Constants: String {
	case scheme = "https"
	case host = "api.vk.com"
}

enum HtttpMethods: String {
	case get = "GET"
	case post = "POST"
}

enum ServiceError: Error, Equatable {
	case parseError
	case serverError
}

class FriendServiceVK {

	private let session: URLSession  = {
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config)
		return session
	}()

	func loadFriends(completion: @escaping(Result<FriendsModel, ServiceError>) -> ()) {

		guard let token = Session.instance.token else { return }

		var urlComponents = URLComponents()
		urlComponents.scheme = Constants.scheme.rawValue
		urlComponents.host = Constants.host.rawValue
		urlComponents.path = ApiMethods.friendsGet.rawValue
		urlComponents.queryItems = [
			URLQueryItem(name: "access_token", value: token),
			URLQueryItem(name: "v", value: "5.131"),
			URLQueryItem(name: "fields", value: "photo_50")
		]
		
		guard let url = urlComponents.url else { return }
		print(url)


		let task = session.dataTask(with: url) { data, response, error in
			if let error = error {
				print("\(error)")
			}

			guard let data = data else { return }
			let jsonDecoder = JSONDecoder()

			do {
				let result = try jsonDecoder.decode(FriendsModel.self, from: data)
				print(result)
				return completion(.success(result))
			} catch {
				completion(.failure(.parseError))
			}
		}
		task.resume()
	}
}

//func loadJson() {
//	var urlComponents = URLComponents()
//	urlComponents.scheme = "https"
//	urlComponents.host = "api.openweathermap.org"
//	urlComponents.path = "/data/2.5/forecast/daily"
//	urlComponents.queryItems = [
//		URLQueryItem(name: "q", value: "Moscow"),
//		URLQueryItem(name: "cnt", value: "16"),
//		URLQueryItem(name: "appid", value: "968c1d4e4fa88aed01f1081ec389f6a5")
//	]
//	guard let url = urlComponents.url else { return }
//	let request = URLRequest(url: url)
//	let task = session.dataTask(with: request) { data, response, error in
//		if let error = error {
//			print(error)
//		}
//		guard let data = data else {
//			return
//		}
//
//		do {
//			let json = try JSONSerialization.jsonObject(with: data,
//														 options: JSONSerialization.ReadingOptions.fragmentsAllowed)
//			print(json)
//		} catch {
//			print("")
//		}
//	}
//	task.resume()
//}
//}
