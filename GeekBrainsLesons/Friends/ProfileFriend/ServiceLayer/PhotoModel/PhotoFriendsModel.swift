//
//  PhotoFriendsModel.swift
//  GeekBrainsLesons
//
//  Created by Олег Ганяхин on 24.02.2022.
//

import Foundation
import RealmSwift

struct PhotoFriendsModel: Codable {
	let response: ResponsePhoto
}

struct ResponsePhoto: Codable {
	let count: Int
	let items: [InfoPhotoFriend]
}

struct InfoPhotoFriend: Codable {
	let sizes: [Size]
	let text: String
}

struct Size: Codable {
	let url: String
	let type: SizeType

	enum SizeType: String, Codable {
		case m = "m"
		case s = "s"
		case y = "y"
		case x = "x"
		case z = "z"
		case w = "w"
		case o = "o"
		case p = "p"
		case q = "q"
		case r = "r"
	}
}
