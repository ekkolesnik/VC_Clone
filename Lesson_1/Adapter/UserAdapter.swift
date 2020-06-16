//
//  UserAdapter.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 14.06.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit
import RealmSwift

struct ForUserAdapter {
    var id: Int
    var firstName: String
    var lastName: String
    var image: String
}

class UserAdapter {
  
    private var realmNotificationToken: NotificationToken?
    
    func getFriends(then completion: @escaping ([ForUserAdapter]) -> Void) {
        guard let realm = try? Realm () else { return }

        let users = realm.objects ( User.self )
        realmNotificationToken = users.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .update(let realmUsers, _, _, _):
                fallthrough
            case .initial(let realmUsers):
                var friends: [ForUserAdapter] = []
                for realmUsers in realmUsers {
                    friends.append(self.friend(from: realmUsers))
                }
                completion(friends)
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
    }
    
    private func friend(from realmUsers: User) -> ForUserAdapter {
        return ForUserAdapter(id: realmUsers.id, firstName: realmUsers.firstName, lastName: realmUsers.lastName, image: realmUsers.image );
    }
    
}
