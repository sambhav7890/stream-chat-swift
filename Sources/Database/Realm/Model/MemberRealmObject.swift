//
//  MemberRealmObject.swift
//  StreamChatRealm
//
//  Created by Alexey Bukhtin on 20/11/2019.
//  Copyright © 2019 Stream.io Inc. All rights reserved.
//

import Foundation
import RealmSwift
import StreamChatCore

public final class MemberRealmObject: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var user: UserRealmObject?
    @objc dynamic var role = ""
    @objc dynamic var created = Date.default
    @objc dynamic var updated = Date.default
    @objc dynamic var isInvited = false
    @objc dynamic var inviteAccepted: Date?
    @objc dynamic var inviteRejected: Date?
    
    public var asMember: Member? {
        guard let user = user?.asUser, let role = Member.Role(rawValue: role) else {
            return nil
        }
        
        return Member(user,
                      role: role,
                      created: created,
                      updated: updated,
                      isInvited: isInvited,
                      inviteAccepted: inviteAccepted,
                      inviteRejected: inviteRejected)
    }
    
    required init() {
        super.init()
    }
    
    public init(member: Member, channel: Channel) {
        id = "\(channel.cid)_\(member.user.id)"
        user = UserRealmObject(member.user)
        role = member.role.rawValue
        created = member.created
        updated = member.updated
        isInvited = member.isInvited
        inviteAccepted = member.inviteAccepted
        inviteRejected = member.inviteRejected
    }
}
