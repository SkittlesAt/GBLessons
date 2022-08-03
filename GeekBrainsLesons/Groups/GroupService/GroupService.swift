//
//  GroupService.swift
//  GeekBrainsLesons
//
//  Created by Олег Ганяхин on 21.02.2022.
//

import UIKit
import RealmSwift
import FirebaseDatabase

enum GroupServiceError: Error {
	case parseError
	case requestError(Error)
}

enum ConstantsService {
	static let scheme = "https"
	static let host = "api.vk.com"

	enum TypeMethods: String {
		case groupsGet = "/method/groups.get"
		case deleteGroups = "/method/groups.leave"
	}

	enum TypeRequest: String {
		case get = "GET"
		case post = "POST"
	}
}

/// Протокол сервисного слоя для сценария "Группы"
protocol GroupServiceProtocol {

	/// Загрузить группы
	func loadGroups(completion: @escaping (Result<[DTO.Groups], GroupServiceError>) -> Void)

	/// Удалить группу
	///  - Parameters:
	///  - id: Идентификатор группы
	///  - completion:  Блок, обрабатывающий результат запроса
	func deleteGroup(id: Int, completion: @escaping(Result<DTO.BoolResponse, GroupServiceError>) -> Void)

	/// Загрузить картинку
	func loadImage(url: String, completion: @escaping(UIImage) -> Void)
}


final class GroupService {

	private let session: URLSession = {
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config)
		return session
	}()

	private let decoder = JSONDecoder()
	private let imageService = ImageLoader()
	private let sessionInstance = Session.instance
	private let cacheKey = "groups"
	private let firebaseService = [FirebaseGroups]()
	private let ref = Database.database().reference(withPath: "Groups")
}

extension GroupService: GroupServiceProtocol {

	func loadGroups(completion: @escaping (Result<[DTO.Groups], GroupServiceError>) -> Void) {
		guard let token = sessionInstance.token else { return }

		let params: [String: String] = ["extended": "1"]
		let url = configureUrl(token: token,
							   method: .groupsGet,
							   typeRequest: .get,
							   params: params)

		let task = session.dataTask(with: url) { [weak self] data, response, error in
			guard let self = self else { return }
			if let error = error {
				return print("\(error)")
			}
			guard let data = data else {
				return
			}
			do {
				let result = try self.decoder.decode(DTO.GroupModelVK.self, from: data).response.items
				completion(.success(result))

			} catch {
				print("\(error)")
			}
		}
		task.resume()
	}

	func deleteGroup(id: Int, completion: @escaping(Result<DTO.BoolResponse, GroupServiceError>) -> Void) {
		guard let token = Session.instance.token else { return }

		let params: [String: String] = ["group_id": "\(id)"]

		let url = configureUrl(token: token,
							   method: .deleteGroups,
							   typeRequest: .post,
							   params: params)
		session.dataTask(with: url) { data, response, error in
			if let error = error {
				return completion(.failure(.requestError(error)))
			}

			guard let data = data else {
				return
			}
			do {
				let result = try self.decoder.decode(DTO.BoolResponse.self, from: data)
				completion(.success(result))
			} catch {
				completion(.failure(.parseError))
			}
		}.resume()
	}

	func loadImage(url: String, completion: @escaping(UIImage) -> Void) {
		guard let url = URL(string: url) else { return }
		imageService.loadImage(url: url) { result in
			switch result {
			case .success(let data):
				guard let image = UIImage(data: data) else { return }
				completion(image)
			case .failure(let error):
				print("error \(error)")
			}
		}
	}
}

// MARK: - Private
private extension GroupService {

	func configureUrl(
		token: String,
		method: ConstantsService.TypeMethods,
		typeRequest: ConstantsService.TypeRequest,
		params: [String: String]
	) -> URL {
		var queryItems: [URLQueryItem] = []
		queryItems.append(URLQueryItem(name: "access_token", value: token))
		queryItems.append(URLQueryItem(name: "v", value: "5.131"))

		for (param, value) in params {
			queryItems.append(URLQueryItem(name: param, value: value))
		}

		var urlComponents = URLComponents()
		urlComponents.scheme = ConstantsService.scheme
		urlComponents.host = ConstantsService.host
		urlComponents.path = method.rawValue
		urlComponents.queryItems = queryItems

		guard let url = urlComponents.url else {
			fatalError("URL is invalidate")
		}
		return url
	}
}
