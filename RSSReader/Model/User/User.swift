//
//  User.swift
//  RSSReader
//
//  Created by Алексей Папин on 14/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit
import CoreData
import PromiseKit

class User: Codable {
    static let entityName = "Users"
    
    let username: String
    let password: String
    var bookmarks: Set<String>
    
    init(username: String, password: String, bookmarks: Set<String>) {
        self.username = username
        self.password = password
        self.bookmarks = bookmarks
    }
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case bookmarks
    }

    func findByUsername(_ username: String) -> Users? {
        let context = CoreStack.shared.persistentContainer.viewContext
        let request = NSFetchRequest<Users>(entityName: User.entityName)
        request.predicate = NSPredicate(format: "username = %@", username)
        request.returnsObjectsAsFaults = false
        let objects = try? context.fetch(request)
        return objects?.first
    }
    
    func updateObject() {
        guard let users = findByUsername(self.username) else {
            return
        }
        users.setValue(self.password, forKey: CodingKeys.password.rawValue)
        users.setValue(self.bookmarks.compactMap({ $0 }).joined(separator: ";"), forKey: CodingKeys.bookmarks.rawValue)
        try! CoreStack.shared.persistentContainer.viewContext.save()
    }
    
    func insertObject() -> Promise<NSManagedObject> {
        return Promise<NSManagedObject> { resolver in
            let context = CoreStack.shared.persistentContainer.viewContext
            let object = NSEntityDescription.insertNewObject(forEntityName: User.entityName, into: context) as! Users
            object.username = self.username
            object.password = self.password
            object.bookmarks = self.bookmarks.compactMap({ $0 }).joined(separator: ";")
            do {
                try context.save()
                resolver.fulfill(object)
            } catch {
                resolver.reject(error)
            }
        }
    }
    
    static func getUser(_ object: NSManagedObject) -> User? {
        guard
            let username = object.value(forKey: CodingKeys.username.rawValue) as? String,
            let password = object.value(forKey: CodingKeys.password.rawValue) as? String,
            let bookmarksString = object.value(forKey: CodingKeys.bookmarks.rawValue) as? String
            else {
                return nil
        }
        let bookmarks = Set(bookmarksString.split(separator: ";").compactMap({ String($0) }))
        return User(username: username, password: password, bookmarks: bookmarks)
    }
    
    static func fetch(_ predicate: NSPredicate? = nil) -> Promise<[User]> {
        return Promise<[User]> { resolver in
            let context = CoreStack.shared.persistentContainer.viewContext
            let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
            request.predicate = predicate
            request.returnsObjectsAsFaults = false
            do {
                let objects = try context.fetch(request)
                resolver.fulfill(objects.compactMap({ User.getUser($0) }))
            } catch {
                resolver.reject(error)
            }
        }
    }
}

extension User: Hashable, Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.username == rhs.username && lhs.password == rhs.password
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.username + self.password)
    }
}
