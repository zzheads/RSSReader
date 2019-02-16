//
//  RSSFeedItem.swift
//  RSSReader
//
//  Created by Алексей Папин on 16/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import FeedKit
import CoreData
import PromiseKit

class RSSEntry: NSObject, NSFetchRequestResult {
    static let entityName = "RSSEntries"
    
    public let id: String
    public var title: String?
    public var content: String?
    public var link: String?
    public var author: String?
    public var comments: String?
    public var pubDate: Date?

    init(id: String, title: String?, content: String?, link: String?, author: String?, comments: String?, pubDate: Date?) {
        self.id = id
        self.title = title
        self.link = link
        self.author = author
        self.comments = comments
        self.pubDate = pubDate
        self.content = content
        super.init()
    }
    
    convenience init(_ rssFeed: RSSFeedItem) {
        self.init(id: UUID().uuidString, title: rssFeed.title, content: rssFeed.description, link: rssFeed.link, author: rssFeed.author, comments: rssFeed.comments, pubDate: rssFeed.pubDate)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case link
        case author
        case comments
        case pubDate
    }
    
    func update(with object: NSManagedObject) {
        guard let id = object.value(forKey: CodingKeys.id.rawValue) as? String, self.id == id else {
            print("Can not update \(self) with \(object), id's is not equal")
            return
        }
        self.title = object.value(forKey: CodingKeys.title.rawValue) as? String
        self.link = object.value(forKey: CodingKeys.link.rawValue) as? String
        self.author = object.value(forKey: CodingKeys.author.rawValue) as? String
        self.comments = object.value(forKey: CodingKeys.comments.rawValue) as? String
        self.pubDate = object.value(forKey: CodingKeys.pubDate.rawValue) as? Date
        self.content = object.value(forKey: CodingKeys.content.rawValue) as? String
    }
    
    func insertNewObject(into context: NSManagedObjectContext) -> NSManagedObject {
        let object = NSEntityDescription.insertNewObject(forEntityName: RSSEntry.entityName, into: context)
        object.update(with: self)
        return object
    }
    
    func insertObject() -> Promise<NSManagedObject> {
        return Promise<NSManagedObject> { resolver in
            do {
                let context = CoreStack.shared.persistentContainer.viewContext
                let object = self.insertNewObject(into: context)
                try context.save()
                resolver.fulfill(object)
            } catch {
                resolver.reject(error)
            }
        }
    }

    func fetch() -> NSManagedObject? {
        let context = CoreStack.shared.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: RSSEntry.entityName)
        request.predicate = NSPredicate(format: "id = %@", self.id)
        request.returnsObjectsAsFaults = false
        guard let foundObjects = try? context.fetch(request) else {
            return nil
        }
        return foundObjects.first
    }
    
    func insertOrUpdateObject() -> Promise<NSManagedObject> {
        return Promise<NSManagedObject> { resolver in
            do {
                let context = CoreStack.shared.persistentContainer.viewContext
                var result: NSManagedObject
                if let foundObject = fetch() {
                    foundObject.update(with: self)
                    result = foundObject
                } else {
                    let newObject = NSEntityDescription.insertNewObject(forEntityName: RSSEntry.entityName, into: context)
                    newObject.update(with: self)
                    result = newObject
                }
                try context.save()
                resolver.fulfill(result)
            } catch {
                resolver.reject(error)
            }
        }
    }
    
    static func getEntry(_ object: NSManagedObject) -> RSSEntry? {
        guard let id = object.value(forKey: "id") as? String else {
            return nil
        }
        let title = object.value(forKey: CodingKeys.title.rawValue) as? String
        let link = object.value(forKey: CodingKeys.link.rawValue) as? String
        let author = object.value(forKey: CodingKeys.author.rawValue) as? String
        let comments = object.value(forKey: CodingKeys.comments.rawValue) as? String
        let pubDate = object.value(forKey: CodingKeys.pubDate.rawValue) as? Date
        let content = object.value(forKey: CodingKeys.content.rawValue) as? String
        return RSSEntry(id: id, title: title, content: content, link: link, author: author, comments: comments, pubDate: pubDate)
    }
    
    static func fetch(predicate: NSPredicate? = nil) -> Promise<[RSSEntry]> {
        return Promise<[RSSEntry]> { resolver in
            let context = CoreStack.shared.persistentContainer.viewContext
            let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
            request.predicate = predicate
            request.returnsObjectsAsFaults = false
            do {
                let objects = try context.fetch(request)
                resolver.fulfill(objects.compactMap({ RSSEntry.getEntry($0) }))
            } catch {
                resolver.reject(error)
            }
        }
    }
}

extension NSManagedObject {
    func update(with entry: RSSEntry) {
        self.setValue(entry.id, forKey: RSSEntry.CodingKeys.id.rawValue)
        self.setValue(entry.title, forKey: RSSEntry.CodingKeys.title.rawValue)
        self.setValue(entry.content, forKey: RSSEntry.CodingKeys.content.rawValue)
        self.setValue(entry.link, forKey: RSSEntry.CodingKeys.link.rawValue)
        self.setValue(entry.author, forKey: RSSEntry.CodingKeys.author.rawValue)
        self.setValue(entry.comments, forKey: RSSEntry.CodingKeys.comments.rawValue)
        self.setValue(entry.pubDate, forKey: RSSEntry.CodingKeys.pubDate.rawValue)
    }
}

extension Array where Element == RSSEntry {
    func insertObjects() -> Promise<[NSManagedObject]> {
        return Promise<[NSManagedObject]> { resolver in
            let context = CoreStack.shared.persistentContainer.viewContext
            let result = self.compactMap({ $0.insertNewObject(into: context) })
            do {
                try context.save()
                resolver.fulfill(result)
            } catch {
                resolver.reject(error)
            }
        }
    }
    
    func insertOrUpdateObjects() -> Promise<[NSManagedObject]> {
        return Promise<[NSManagedObject]> { resolver in
            do {
                let context = CoreStack.shared.persistentContainer.viewContext
                var result = [NSManagedObject]()
                for entry in self {
                    if let found = entry.fetch() {
                        found.update(with: entry)
                        result.append(found)
                    } else {
                        let newObject = entry.insertNewObject(into: context)
                        result.append(newObject)
                    }
                }
                try context.save()
                resolver.fulfill(result)
            } catch {
                resolver.reject(error)
            }
        }
    }
}

extension RSSEntry: TypeProtocol {
    var sectionHeader: String {
        guard let pubDate = self.pubDate else {
            return ""
        }
        return Date.formatter.string(from: pubDate)
    }
    
    var sectionId: String {
        guard let pubDate = self.pubDate else {
            return ""
        }
        let formatter = Date.formatter
        formatter.dateFormat = "yyMMdd"
        return formatter.string(from: pubDate)
    }
    
    var rowId: String {
        return self.sectionId
    }
    
    var row: RowProtocol {
        return Row<RSSEntry, RSSEntryCell>(self)
    }
}
