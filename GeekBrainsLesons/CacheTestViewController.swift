//
//  CacheTestViewController.swift
//  GeekBrainsLesons
//
//  Created by Олег Ганяхин on 21.02.2022.
//
//
//import UIKit
//import SwiftKeychainWrapper
//import RealmSwift
//
//class TestRealm: Object {
//
//	@objc dynamic var id = 0
//	@objc dynamic var name = ""
//	@objc dynamic var age = 0
//
//	let petsModel = List<TestPet>()
//
//	override class func primaryKey() -> String? {
//		return "id"
//	}
//
//	override class func indexedProperties() -> [String] {
//		return ["name"]
//	}
//
//	override class func ignoredProperties() -> [String] {
//		return ["age"]
//	}
//}
//
//class TestPet: Object {
//	@objc dynamic var name = ""
//	let owners = LinkingObjects(fromType: TestRealm.self, property: "petsModel")
//}
//
//class CacheTestViewController: UIViewController {
//
//	let userDefault = UserDefaults.standard
//	let keyChainService = KeychainWrapper.standard
//	let coreDataService = CoreDataServiceManager()
//
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		print("ViewDidLoad")
////		keyChainService.set("red", forKey: ColorString.userDefaultKey)
////		userDefault.set("red", forKey: ColorString.userDefaultKey)
////		saveUser()
//		fetchUser()
//	}
//
//	override func viewDidAppear(_ animated: Bool) {
//		super.viewDidAppear(animated)
//		guard let backgroundColor = userDefault.string(forKey: ColorString.userDefaultKey) else { return }
////		guard let backgroundColor = keyChainService.string(forKey: ColorString.userDefaultKey) else { return }
//
//		let color = ColorString.init(rawValue: backgroundColor)?.color
//		view.backgroundColor = color
//	}
//}
//
//extension CacheTestViewController {
//	func saveUser() {
//		let context = coreDataService.persistantContainer.viewContext
//		let newHuman = Human(context: context)
//		newHuman.name = "Alena"
//		newHuman.birthday = Date()
//		newHuman.gender = false
//		coreDataService.saveContext()
//		print(context)
//	}
//
//	func fetchUser() {
//		let context = coreDataService.persistantContainer.viewContext
//		let newHuman = Human(context: context)
//		newHuman.name = "Alena"
//		newHuman.birthday = Date()
//		newHuman.gender = false
//		context.delete(newHuman)
//
//		let result = try! context.fetch(Human.fetchRequest()) as! [Human]
//		let human = result.first
//		print(human)
//	}
//}
//
//enum ColorString: String {
//	case red = "red"
//	case blue = "blue"
//	case yellow = "yellow"
//
//	static let userDefaultKey = "color"
//
//	var color: UIColor {
//		switch self {
//		case .red: return .red
//		case .yellow: return .yellow
//		case .blue: return .blue
//		}
//	}
//}
