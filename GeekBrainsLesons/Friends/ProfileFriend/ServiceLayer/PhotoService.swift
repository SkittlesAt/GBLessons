//
//  PhotoService.swift
//  GeekBrainsLesons
//
//  Created by Олег Ганяхин on 24.02.2022.
//

import UIKit

enum PhotosError: Error {
	case parseError
	case requestError(Error)
}

enum TypeMethods: String {
	case photosGetAll = "/method/photos.getAll"
}

enum TypeRequest: String {
	case get = "GET"
	case post = "POST"
}

class PhotoService {
	private let session: URLSession = {
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config)
		return session
	}()

	private var imageService = ImageLoader()
	private let cacheService: PhotoCacheProtocol = PhotoCache()

	private let decoder = JSONDecoder()

	func loadPhoto(idFriend: String,
				   completion: @escaping (Result<[InfoPhotoFriend], PhotosError>) -> Void) {
		guard let token = Session.instance.token else { return }

		let params: [String: String] = ["owner_id": idFriend,
										"extended": "1",
										"count": "200"
		]

		let url = configureUrl(token: token,
							   method: .photosGetAll,
							   httpMethod: .get,
							   params: params)
		print(url)

		session.dataTask(with: url) { data, response, error in
			if let error = error {
				return completion(.failure(.requestError(error)))
			}
			guard let data = data else {
				return
			}
			do {
				let result = try self.decoder.decode(PhotoFriendsModel.self, from: data).response.items
				completion(.success(result))
			} catch {
				completion(.failure(.parseError))
			}
		}.resume()
	}

	func loadImage(url: String, completion: @escaping(UIImage) -> Void) {
		guard let url = URL(string: url) else { return }

		if let image = cacheService.getImage(for: url) {
			completion(image)
			return
		}

		imageService.loadImage(url: url) { result in
			switch result {
			case .success(let data):
				guard let image = UIImage(data: data) else { return }
//				self.cacheService.saveImage(image, for: url)
				completion(image)
			case .failure(let error):
				print("error \(error)")
			}
		}
	}
}

// MARK: - Private
private extension PhotoService {
	func configureUrl(token: String,
					  method: TypeMethods,
					  httpMethod: TypeRequest,
					  params: [String: String]
	) -> URL {
		var queryItems: [URLQueryItem] = []
		queryItems.append(URLQueryItem(name: "access_token", value: token))
		queryItems.append(URLQueryItem(name: "v", value: "5.131"))

		for (name, value) in params {
			queryItems.append(URLQueryItem(name: name, value: value))
		}

		var urlComponents = URLComponents()
		urlComponents.scheme = "https"
		urlComponents.host = "api.vk.com"
		urlComponents.path = method.rawValue
		urlComponents.queryItems = queryItems

		guard let url = urlComponents.url else { fatalError() }

		return url
	}
}
