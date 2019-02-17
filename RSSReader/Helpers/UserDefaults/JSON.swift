//
//  JSON.swift
//  RSSReader
//
//  Created by Алексей Папин on 15/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

extension Encodable {
    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }
    
    var toJSON: JSON? {
        do {
            let data = try self.encoder.encode(self)
            return try JSONSerialization.jsonObject(with: data) as? JSON
        } catch {
            return nil
        }
    }
    
    var toJSONString: String? {
        do {
            let data = try self.encoder.encode(self)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

extension Decodable {
    init?(fromJSON JSON: JSON) {
        do {
            let data = try JSONSerialization.data(withJSONObject: JSON, options: [])
            self = try JSONDecoder().decode(Self.self, from: data)
        } catch {
            print("Error serialize: \(error)")
            return nil
        }
    }
    
    init?(fromJSONString JSONString: String?) {
        guard let JSONString = JSONString else { return nil }
        do {
            if let data = JSONString.data(using: .utf8) {
                self = try JSONDecoder().decode(Self.self, from: data)
            } else {
                return nil
            }
        } catch {
            print("Error serialize: \(error)")
            return nil
        }
    }
}

extension Array where Element: Decodable {
    init?(fromJSONArray jsonArray: [JSON]) {
        self = [Element]()
        for json in jsonArray {
            if let element = Element(fromJSON: json) {
                self.append(element)
            } else {
                return nil
            }
        }
    }
}

extension Array where Element: Codable {
    var toJSONArray: JSON {
        var jsonArray = [JSON]()
        self.forEach({ if let json = $0.toJSON { jsonArray.append(json) }})
        return ["\(Element.self)": jsonArray]
    }
}
