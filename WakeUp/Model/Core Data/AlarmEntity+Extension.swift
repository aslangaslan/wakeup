//
//  AlarmEntity+Extensions.swift
//  WakeUp
//
//  Created by Giray Gençaslan on 27.03.2019.
//  Copyright © 2019 Aslan Apps. All rights reserved.
//

import Foundation

extension AlarmEntity {
    
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
