//
//  UpdateStore.swift
//  TrivAI
//
//  Created by Ryan Ho on 03/04/23.
//

import Combine
import SwiftUI

class UpdateStore: ObservableObject {
   var willChange = PassthroughSubject<Void, Never>()

   var updates: [Update] {
      didSet {
         willChange.send()
      }
   }

   init(updates: [Update] = []) {
      self.updates = updates
   }
}
