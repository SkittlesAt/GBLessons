//
//  FriendsModel.swift
//  GeekBrainsLesons
//
//  Created by Олег Ганяхин on 17.02.2022.
//

import RealmSwift
import Foundation

struct FriendsModel: Decodable {
	let response: ResponseFriends
}

struct ResponseFriends: Decodable {
	let count: Int
	let items: [Friends]
}

class Friends: Object, Decodable {
	@objc dynamic var id: Int = 0
	@objc dynamic var firstName: String = ""
	@objc dynamic var lastName: String = ""
	@objc dynamic var photo50: String = ""

	enum CodingKeys: String, CodingKey {
		case id
		case firstName = "first_name"
		case lastName = "last_name"
		case photo50 = "photo_50"
	}
}
