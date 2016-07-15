//
// Types.swift
//
// Copyright © 2016 Peter Zignego. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

// MARK: - Edited
public struct Edited {
    public let user: String?
    public let ts: String?
    
    internal init(edited:[String: AnyObject]?) {
        user = edited?["user"] as? String
        ts = edited?["ts"] as? String
    }
}

// MARK: - History
public struct History {
    internal(set) public var latest: Date?
    internal(set) public var messages = [Message]()
    public let hasMore: Bool?
    
    internal init(history: [String: AnyObject]?) {
        if let latestStr = history?["latest"] as? String, latestDouble = Double(latestStr) {
            latest = Date(timeIntervalSince1970: TimeInterval(latestDouble))
        }
        if let msgs = history?["messages"] as? [[String: AnyObject]] {
            for message in msgs {
                messages.append(Message(message: message))
            }
        }
        hasMore = history?["has_more"] as? Bool
    }
}

// MARK: - Reaction
public struct Reaction {
    public let name: String?
    internal(set) public var user: String?
    
    internal init(reaction:[String: AnyObject]?) {
        name = reaction?["name"] as? String
    }
    
    internal init(name: String, user: String) {
        self.name = name
        self.user = user
    }
    
    static func reactionsFromArray(_ array: [[String: AnyObject]]?) -> [Reaction] {
        var reactions = [Reaction]()
        if let array = array {
            for reaction in array {
                if let users = reaction["users"] as? [String], name = reaction["name"] as? String {
                    for user in users {
                        reactions.append(Reaction(name: name, user: user))
                    }
                }
            }
        }
        return reactions
    }
    
}

extension Reaction: Equatable {}

public func ==(lhs: Reaction, rhs: Reaction) -> Bool {
    return lhs.name == rhs.name
}

// MARK: - Comment
public struct Comment {
    public let id: String?
    public let user: String?
    internal(set) public var created: Int?
    internal(set) public var comment: String?
    internal(set) public var starred: Bool?
    internal(set) public var stars: Int?
    internal(set) public var reactions = [Reaction]()
    
    internal init(comment:[String: AnyObject]?) {
        id = comment?["id"] as? String
        created = comment?["created"] as? Int
        user = comment?["user"] as? String
        starred = comment?["is_starred"] as? Bool
        stars = comment?["num_stars"] as? Int
        self.comment = comment?["comment"] as? String
    }
    
    internal init(id: String?) {
        self.id = id
        self.user = nil
    }
}

extension Comment: Equatable {}

public func ==(lhs: Comment, rhs: Comment) -> Bool {
    return lhs.id == rhs.id
}

// MARK: - Item
public struct Item {
    public let type: String?
    public let ts: String?
    public let channel: String?
    public let message: Message?
    public let file: File?
    public let comment: Comment?
    public let fileCommentID: String?
    
    internal init(item:[String: AnyObject]?) {
        type = item?["type"] as? String
        ts = item?["ts"] as? String
        channel = item?["channel"] as? String
        
        message = Message(message: item?["message"] as? [String: AnyObject])
        
        // Comment and File can come across as Strings or Dictionaries
        if let commentDictionary = item?["comment"] as? [String: AnyObject] {
            comment = Comment(comment: commentDictionary)
        } else {
            comment = Comment(id: item?["comment"] as? String)
        }

        if let fileDictionary = item?["file"] as? [String: AnyObject] {
            file = File(file: fileDictionary)
        } else {
            file = File(id: item?["file"] as? String)
        }
        
        fileCommentID = item?["file_comment"] as? String
    }
}

extension Item: Equatable {}

public func ==(lhs: Item, rhs: Item) -> Bool {
    return lhs.type == rhs.type && lhs.channel == rhs.channel && lhs.file == rhs.file && lhs.comment == rhs.comment && lhs.message == rhs.message
}

// MARK: - Topic
public struct Topic {
    public let value: String?
    public let creator: String?
    public let lastSet: Int?
    
    internal init(topic: [String: AnyObject]?) {
        value = topic?["value"] as? String
        creator = topic?["creator"] as? String
        lastSet = topic?["last_set"] as? Int
    }
}

// MARK: - Do Not Disturb Status
public struct DoNotDisturbStatus {
    internal(set) public var enabled: Bool?
    internal(set) public var nextDoNotDisturbStart: Int?
    internal(set) public var nextDoNotDisturbEnd: Int?
    internal(set) public var snoozeEnabled: Bool?
    internal(set) public var snoozeEndtime: Int?
    
    internal init(status: [String: AnyObject]?) {
        enabled = status?["dnd_enabled"] as? Bool
        nextDoNotDisturbStart = status?["next_dnd_start_ts"] as? Int
        nextDoNotDisturbEnd = status?["next_dnd_end_ts"] as? Int
        snoozeEnabled = status?["snooze_enabled"] as? Bool
        snoozeEndtime = status?["snooze_endtime"] as? Int
    }
    
}

// MARK - Custom Team Profile
public struct CustomProfile {
    internal(set) public var fields = [String: CustomProfileField]()
    
    internal init(profile: [String: AnyObject]?) {
        if let eventFields = profile?["fields"] as? [AnyObject] {
            for field in eventFields {
                var cpf: CustomProfileField?
                if let fieldDictionary = field as? [String: AnyObject] {
                    cpf = CustomProfileField(field: fieldDictionary)
                } else {
                    cpf = CustomProfileField(id: field as? String)
                }
                if let id = cpf?.id { fields[id] = cpf }
            }
        }
    }
    
    internal init(customFields: [String: AnyObject]?) {
        if let customFields = customFields {
            for key in customFields.keys {
                let cpf = CustomProfileField(field: customFields[key] as? [String: AnyObject])
                self.fields[key] = cpf
            }
        }
    }
    
}

public struct CustomProfileField {
    internal(set) public var id: String?
    internal(set) public var alt: String?
    internal(set) public var value: String?
    internal(set) public var hidden: Bool?
    internal(set) public var hint: String?
    internal(set) public var label: String?
    internal(set) public var options: String?
    internal(set) public var ordering: Int?
    internal(set) public var possibleValues: [String]?
    internal(set) public var type: String?
    
    internal init(field: [String: AnyObject]?) {
        id = field?["id"] as? String
        alt = field?["alt"] as? String
        value = field?["value"] as? String
        hidden = field?["is_hidden"] as? Bool
        hint = field?["hint"] as? String
        label = field?["label"] as? String
        options = field?["options"] as? String
        ordering = field?["ordering"] as? Int
        possibleValues = field?["possible_values"] as? [String]
        type = field?["type"] as? String
    }
    
    internal init(id: String?) {
        self.id = id
    }
    
    internal mutating func updateProfileField(_ profile: CustomProfileField?) {
        id = profile?.id != nil ? profile?.id : id
        alt = profile?.alt != nil ? profile?.alt : alt
        value = profile?.value != nil ? profile?.value : value
        hidden = profile?.hidden != nil ? profile?.hidden : hidden
        hint = profile?.hint != nil ? profile?.hint : hint
        label = profile?.label != nil ? profile?.label : label
        options = profile?.options != nil ? profile?.options : options
        ordering = profile?.ordering != nil ? profile?.ordering : ordering
        possibleValues = profile?.possibleValues != nil ? profile?.possibleValues : possibleValues
        type = profile?.type != nil ? profile?.type : type
    }
}
