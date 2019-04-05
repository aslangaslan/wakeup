//
//  UserEntity+Extension.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 5.04.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import Foundation

extension UserEntity {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func save() throws {
        do {
            try self.managedObjectContext?.save()
        }
        catch {
            throw error
        }
    }
}
