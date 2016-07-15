//
// EventDelegate.swift
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

public protocol SlackEventsDelegate: class {
    func clientConnectionFailed(_ error: SlackError)
    func clientConnected()
    func clientDisconnected()
    func preferenceChanged(_ preference: String, value: AnyObject?)
    func userChanged(_ user: User)
    func presenceChanged(_ user: User, presence: String)
    func manualPresenceChanged(_ user: User, presence: String)
    func botEvent(_ bot: Bot)
}

public protocol MessageEventsDelegate: class {
    func messageSent(_ message: Message)
    func messageReceived(_ message: Message)
    func messageChanged(_ message: Message)
    func messageDeleted(_ message: Message?)
}

public protocol ChannelEventsDelegate: class {
    func userTyping(_ channel: Channel, user: User)
    func channelMarked(_ channel: Channel, timestamp: String)
    func channelCreated(_ channel: Channel)
    func channelDeleted(_ channel: Channel)
    func channelRenamed(_ channel: Channel)
    func channelArchived(_ channel: Channel)
    func channelHistoryChanged(_ channel: Channel)
    func channelJoined(_ channel: Channel)
    func channelLeft(_ channel: Channel)
}

public protocol DoNotDisturbEventsDelegate: class {
    func doNotDisturbUpdated(_ dndStatus: DoNotDisturbStatus)
    func doNotDisturbUserUpdated(_ dndStatus: DoNotDisturbStatus, user: User)
}

public protocol GroupEventsDelegate: class {
    func groupOpened(_ group: Channel)
}

public protocol FileEventsDelegate: class {
    func fileProcessed(_ file: File)
    func fileMadePrivate(_ file: File)
    func fileDeleted(_ file: File)
    func fileCommentAdded(_ file: File, comment: Comment)
    func fileCommentEdited(_ file: File, comment: Comment)
    func fileCommentDeleted(_ file: File, comment: Comment)
}

public protocol PinEventsDelegate: class {
    func itemPinned(_ item: Item, channel: Channel?)
    func itemUnpinned(_ item: Item, channel: Channel?)
}

public protocol StarEventsDelegate: class {
    func itemStarred(_ item: Item, star: Bool)
}

public protocol ReactionEventsDelegate: class {
    func reactionAdded(_ reaction: String, item: Item, itemUser: String)
    func reactionRemoved(_ reaction: String, item: Item, itemUser: String)
}

public protocol TeamEventsDelegate: class {
    func teamJoined(_ user: User)
    func teamPlanChanged(_ plan: String)
    func teamPreferencesChanged(_ preference: String, value: AnyObject?)
    func teamNameChanged(_ name: String)
    func teamDomainChanged(_ domain: String)
    func teamEmailDomainChanged(_ domain: String)
    func teamEmojiChanged()
}

public protocol SubteamEventsDelegate: class {
    func subteamEvent(_ userGroup: UserGroup)
    func subteamSelfAdded(_ subteamID: String)
    func subteamSelfRemoved(_ subteamID: String)
}

public protocol TeamProfileEventsDelegate: class {
    func teamProfileChanged(_ profile: CustomProfile)
    func teamProfileDeleted(_ profile: CustomProfile)
    func teamProfileReordered(_ profile: CustomProfile)
}
