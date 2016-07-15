//
// SlackWebAPIErrorDispatcher.swift
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

public enum SlackError: ErrorProtocol {
    case accountInactive
    case alreadyArchived
    case alreadyInChannel
    case alreadyPinned
    case alreadyReacted
    case alreadyStarred
    case badClientSecret
    case badRedirectURI
    case badTimeStamp
    case cantArchiveGeneral
    case cantDelete
    case cantDeleteFile
    case cantDeleteMessage
    case cantInvite
    case cantInviteSelf
    case cantKickFromGeneral
    case cantKickFromLastChannel
    case cantKickSelf
    case cantLeaveGeneral
    case cantLeaveLastChannel
    case cantUpdateMessage
    case channelNotFound
    case complianceExportsPreventDeletion
    case editWindowClosed
    case fileCommentNotFound
    case fileDeleted
    case fileNotFound
    case fileNotShared
    case groupContainsOthers
    case invalidArrayArg
    case invalidAuth
    case invalidChannel
    case invalidCharSet
    case invalidClientID
    case invalidCode
    case invalidFormData
    case invalidName
    case invalidPostType
    case invalidPresence
    case invalidTS
    case invalidTSLatest
    case invalidTSOldest
    case isArchived
    case lastMember
    case lastRAChannel
    case messageNotFound
    case messageTooLong
    case migrationInProgress
    case missingDuration
    case missingPostType
    case nameTaken
    case noChannel
    case noComment
    case noItemSpecified
    case noReaction
    case noText
    case notArchived
    case notAuthed
    case notEnoughUsers
    case notInChannel
    case notInGroup
    case notPinned
    case notStarred
    case overPaginationLimit
    case paidOnly
    case permissionDenied
    case postingToGeneralChannelDenied
    case rateLimited
    case requestTimeout
    case restrictedAction
    case snoozeEndFailed
    case snoozeFailed
    case snoozeNotActive
    case tooLong
    case tooManyEmoji
    case tooManyReactions
    case tooManyUsers
    case unknownError
    case unknownType
    case userDisabled
    case userDoesNotOwnChannel
    case userIsBot
    case userIsRestricted
    case userIsUltraRestricted
    case userListNotSupplied
    case userNotFound
    case userNotVisible
    // Client
    case clientNetworkError
    case clientJSONError
    // HTTP
    case tooManyRequests
    case unknownHTTPError
}

internal struct ErrorDispatcher {
    
    static func dispatch(_ error: String) -> SlackError {
        switch error {
        case "account_inactive":
            return .accountInactive
        case "already_in_channel":
            return .alreadyInChannel
        case "already_pinned":
            return .alreadyPinned
        case "already_reacted":
            return .alreadyReacted
        case "already_starred":
            return .alreadyStarred
        case "bad_client_secret":
            return .badClientSecret
        case "bad_redirect_uri":
            return .badRedirectURI
        case "bad_timestamp":
            return .badTimeStamp
        case "cant_delete":
            return .cantDelete
        case "cant_delete_file":
            return .cantDeleteFile
        case "cant_delete_message":
            return .cantDeleteMessage
        case "cant_invite":
            return .cantInvite
        case "cant_invite_self":
            return .cantInviteSelf
        case "cant_kick_from_general":
            return .cantKickFromGeneral
        case "cant_kick_from_last_channel":
            return .cantKickFromLastChannel
        case "cant_kick_self":
            return .cantKickSelf
        case "cant_leave_general":
            return .cantLeaveGeneral
        case "cant_leave_last_channel":
            return .cantLeaveLastChannel
        case "cant_update_message":
            return .cantUpdateMessage
        case "compliance_exports_prevent_deletion":
            return .complianceExportsPreventDeletion
        case "channel_not_found":
            return .channelNotFound
        case "edit_window_closed":
            return .editWindowClosed
        case "file_comment_not_found":
            return .fileCommentNotFound
        case "file_deleted":
            return .fileDeleted
        case "file_not_found":
            return .fileNotFound
        case "file_not_shared":
            return .fileNotShared
        case "group_contains_others":
            return .groupContainsOthers
        case "invalid_array_arg":
            return .invalidArrayArg
        case "invalid_auth":
            return .invalidAuth
        case "invalid_channel":
            return .invalidChannel
        case "invalid_charset":
            return .invalidCharSet
        case "invalid_client_id":
            return .invalidClientID
        case "invalid_code":
            return .invalidCode
        case "invalid_form_data":
            return .invalidFormData
        case "invalid_name":
            return .invalidName
        case "invalid_post_type":
            return .invalidPostType
        case "invalid_presence":
            return .invalidPresence
        case "invalid_timestamp":
            return .invalidTS
        case "invalid_ts_latest":
            return .invalidTSLatest
        case "invalid_ts_oldest":
            return .invalidTSOldest
        case "is_archived":
            return .isArchived
        case "last_member":
            return .lastMember
        case "last_ra_channel":
            return .lastRAChannel
        case "message_not_found":
            return .messageNotFound
        case "msg_too_long":
            return .messageTooLong
        case "migration_in_progress":
            return .migrationInProgress
        case "missing_duration":
            return .missingDuration
        case "missing_post_type":
            return .missingPostType
        case "name_taken":
            return .nameTaken
        case "no_channel":
            return .noChannel
        case "no_comment":
            return .noComment
        case "no_reaction":
            return .noReaction
        case "no_item_specified":
            return .noItemSpecified
        case "no_text":
            return .noText
        case "not_archived":
            return .notArchived
        case "not_authed":
            return .notAuthed
        case "not_enough_users":
            return .notEnoughUsers
        case "not_in_channel":
            return .notInChannel
        case "not_in_group":
            return .notInGroup
        case "not_pinned":
            return .notPinned
        case "not_starred":
            return .notStarred
        case "over_pagination_limit":
            return .overPaginationLimit
        case "paid_only":
            return .paidOnly
        case "perimssion_denied":
            return .permissionDenied
        case "posting_to_general_channel_denied":
            return .postingToGeneralChannelDenied
        case "rate_limited":
            return .rateLimited
        case "request_timeout":
            return .requestTimeout
        case "snooze_end_failed":
            return .snoozeEndFailed
        case "snooze_failed":
            return .snoozeFailed
        case "snooze_not_active":
            return .snoozeNotActive
        case "too_long":
            return .tooLong
        case "too_many_emoji":
            return .tooManyEmoji
        case "too_many_reactions":
            return .tooManyReactions
        case "too_many_users":
            return .tooManyUsers
        case "unknown_type":
            return .unknownType
        case "user_disabled":
            return .userDisabled
        case "user_does_not_own_channel":
            return .userDoesNotOwnChannel
        case "user_is_bot":
            return .userIsBot
        case "user_is_restricted":
            return .userIsRestricted
        case "user_is_ultra_restricted":
            return .userIsUltraRestricted
        case "user_list_not_supplied":
            return .userListNotSupplied
        case "user_not_found":
            return .userNotFound
        case "user_not_visible":
            return .userNotVisible
        default:
            return .unknownError
        }
    }
}
