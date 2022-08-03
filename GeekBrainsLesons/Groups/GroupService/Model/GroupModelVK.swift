//
//  GroupModelVK.swift
//  GeekBrainsLesons
//
//  Created by Олег Ганяхин on 21.02.2022.
//

import Foundation

struct DTO: Codable {
	struct BoolResponse: Codable {
		var response: Int
	}

	struct GroupModelVK: Codable {
		let response: ResponseGroup
	}

	struct ResponseGroup: Codable {
		let count: Int
		let items: [Groups]
	}

	struct Groups: Codable {
		let id: Int
		let name: String
		let photo50: String
		let isMember: Int

		enum CodingKeys: String, CodingKey {
			case id
			case name
			case photo50 = "photo_50"
			case isMember = "is_member"
		}
	}
}
