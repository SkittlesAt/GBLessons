//
//  MyGroupsViewController.swift
//  GeekBrainsLesons
//
//  Created by Vitalii Sukhoroslov on 31.10.2021.
//

import UIKit
import RealmSwift
import FirebaseDatabase

protocol MyGroupDelegate: AnyObject {
    func groupDidSelect(_ group: GroupModel)
}

class MyGroupsViewController: UITableViewController {
    
	private var myGroups: [DTO.Groups] = []

	private let service = GroupService()

	private var token: NotificationToken?
	private let firebaseService = [FirebaseGroups]()
	private let ref = Database.database().reference(withPath: "Groups")

    override func viewDidLoad() {
        super.viewDidLoad()
		fetchGroups()
    }

    // MARK: - Table view data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myGroups.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard
			let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell",
													 for: indexPath) as? MyGroupsViewCell
		else {
			return UITableViewCell()
		}

		cell.configure(group: myGroups[indexPath.row])

		return cell
	}

	override func tableView(_ tableView: UITableView,
							commit editingStyle: UITableViewCell.EditingStyle,
							forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let group = myGroups[indexPath.row]
			let id = group.id
			leaveGroup(id: id, indexPath: indexPath)
		}
	}

//	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		guard let group = myGroups?[indexPath.row] else { return }
//		let fireCom = FirebaseGroups(groupName: group.name, groudId: group.id)
//		print(fireCom)
//		let groupRef = self.ref.child(group.name.lowercased())
//		groupRef.setValue(fireCom.toAnyObject())
//	}


// MARK: - addGroupDelegate
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        // Получаем ссылку на контроллер с которого осуществлен переход
        guard
			let vc = segue.source as? AllGroupViewController
		else {
			return
		}
//        vc.delegate = self
        // Получаем название группы и картинку и кладем в мои группы для последущей отрисовки
        if let indexPath = vc.tableView.indexPathForSelectedRow {
            let group = vc.groups[indexPath.row]
            vc.delegate?.groupDidSelect(group)
        }
    }
}

// MARK: - MyGroupDelegate
private extension MyGroupsViewController {

//	func createNotificationToken() {
//		token = myGroups?.observe { [weak self] result in
//			guard let self = self else { return }
//			switch result {
//			case .initial(let groupsData):
//				print("\(groupsData.count) groups")
//			case .update(_ ,
//						 deletions: let deletions,
//						 insertions: let insertions ,
//						 modifications: let modifications):
//
//				let deletionsIndexPath = deletions.map { IndexPath(row: $0, section: 0) }
//				let insertionsIndexPath = insertions.map { IndexPath(row: $0, section: 0) }
//				let modificationsIndexPath = modifications.map { IndexPath(row: $0, section: 0) }
//
//				DispatchQueue.main.async {
//					self.tableView.beginUpdates()
//
//					self.tableView.deleteRows(at: deletionsIndexPath, with: .automatic)
//
//					self.tableView.insertRows(at: insertionsIndexPath, with: .automatic)
//
//					self.tableView.reloadRows(at: modificationsIndexPath, with: .automatic)
//
//					self.tableView.endUpdates()
//				}
//			case .error(let error):
//				print("\(error)")
//			}
//		}
//	}

	func leaveGroup(id: Int, indexPath: IndexPath) {
		service.deleteGroup(id: id) { [weak self] result in
			switch result {
			case .success(_):
				self?.myGroups.remove(at: indexPath.row)
				DispatchQueue.main.async {
					self?.tableView.deleteRows(at: [indexPath], with: .automatic)
				}
			case .failure(_):
				DispatchQueue.main.async {
					self?.showAlert()

				}
			}
		}
	}
	
	func fetchGroups() {
		service.loadGroups { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let groups):
				self.myGroups = groups
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			case .failure(_):
				self.showAlert()
			}
		}
	}
	
	func showAlert() {
		let alert = UIAlertController(title: "Ошибка",
									  message: "Не удалось покинуть группу",
									  preferredStyle: .actionSheet)
		let button = UIAlertAction(title: "Ok", style: .cancel, handler: nil)

		alert.addAction(button)

		present(alert, animated: true, completion: nil)
	}
}
