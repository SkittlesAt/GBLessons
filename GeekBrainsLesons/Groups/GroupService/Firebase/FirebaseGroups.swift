//
//  FirebaseGroups.swift
//  GeekBrainsLesons
//
//  Created by Олег Ганяхин on 21.03.2022.
//

import Firebase

class FirebaseGroups {
	let groupName: String

	let groupId: Int

	let ref: DatabaseReference?

	init(groupName: String, groudId: Int) {
		self.ref = nil
		self.groupId = groudId
		self.groupName = groupName
	}

	init?(snapshot: DataSnapshot) {
		guard
			let value = snapshot.value as? [String: Any],
			let id = value["groupId"] as? Int,
			let name = value["groupName"] as? String
		else {
			return nil
		}
		self.ref = snapshot.ref
		self.groupName = name
		self.groupId = id
	}

	func toAnyObject() -> [String: Any] {
		["groupId": groupId,
		 "groupName": groupName]
	}
}
