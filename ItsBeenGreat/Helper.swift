//
//  Helper.swift
//  ItsBeenGreat
//
//  Created by Jiang, Tony on 12/29/17.
//  Copyright © 2017 Jiang, Tony. All rights reserved.
//

import UIKit

let moods = ["Professional","Sarcastic","Revengeful"]

enum Professional: String {
    case fallen = "have fallen out of love with you"
    case cheated = "Unfortunately, you cheated on"
    case changed = "feel that you have changed"
    case tired = "am tired of being with you"
    case crazy = "believe you are flat out crazy"
    case drinker = "feel you drink too much"
    case smother = "You are smothering"
    case found = "have found someone else"
    case notReady = "am not ready for a relationship"
    case discover = "need time for self-discovery"
    case notRight = "This relationship doesn't feel right"
}

enum Sarcastic: String {
    case fallen = "don't feel a drop of love with you"
    case cheated = "This one's obvious. You cheated on"
    case changed = "feel that you have changed like a dumbass, sound about right?"
    case tired = "am tired of being with you, and being associated with you"
    case crazy = "believe you're missing a few screws upstairs"
    case drinker = "feel the amount you drink can't be healthy"
    case smother = "You're suffocating"
    case found = "have found a better catch in the sea"
    case notReady = "am not ready to be tied down"
    case discover = "need time to explore personal hobbies"
    case notRight = "Love shouldn't be this hard"
}

enum Revengeful: String {
    case fallen = "don't give a rat's ass about you anymore"
    case cheated = "You must have the IQ of a donut for deciding it would be a good idea to cheat on"
    case changed = "don't even recognize you anymore because you've made changes for the absolute worse"
    case tired = "have had better conversations with a dog"
    case crazy = "believe you're just flat out batshit gaga stick my head in a blender crazy"
    case drinker = "feel you drink like a fish"
    case smother = "You're choking the life out of"
    case found = "have decided to upgrade"
    case notReady = "am not ready to settle"
    case discover = "need distance from you to boost my social proof"
    case notRight = "Something doesn't smell right in this relationship"
}
