//
//  CoreDataServiceManager.swift
//  GeekBrainsLesons
//
//  Created by Олег Ганяхин on 21.02.2022.
//

import CoreData

class CoreDataServiceManager {
	lazy var persistantContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "CacheCoreData")
		container.loadPersistentStores { storeDescription, error in
			if let error = error {
				fatalError("error")
			}
		}
		return container
	}()

	var context: NSManagedObjectContext {
		return persistantContainer.viewContext
	}

	func saveContext() {
		let context = persistantContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nsError = error as NSError
				fatalError("error context \(nsError), \(nsError.userInfo), \(nsError.code)")
			}
		}
	}
}
