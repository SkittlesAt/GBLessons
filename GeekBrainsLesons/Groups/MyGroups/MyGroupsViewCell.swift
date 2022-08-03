//
//  MyGroupsViewCell.swift
//  GeekBrainsLesons
//
//  Created by Vitalii Sukhoroslov on 31.10.2021.
//

import UIKit

class MyGroupsViewCell: UITableViewCell {
    @IBOutlet weak var nameGroup: UILabel!
    @IBOutlet weak var avatarGroup: UIImageView!
	private let service = GroupService()

	var id: Int?

	/// Сконфигурировать ячейку
	/// - Parameter group: Группа
	func configure(group: DTO.Groups) {

		nameGroup.text = group.name
		id = group.id
		service.loadImage(url: group.photo50) { [weak self] image in
			guard let self = self else { return }
			DispatchQueue.main.async {
				self.avatarGroup.image = image
			}
		}
	}
}
