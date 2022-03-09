//
//  Constants.swift
//  truecaller_sdk
//
//  Created by Sreedeepkesav M S on 02/03/22.
//

import Foundation

struct Constants {
    struct ChannelNames {
        static let methodChannel = "tc_method_channel"
        static let eventChannel = "tc_event_channel"
    }
    
    struct String {
        static let data = "data"
        static let result = "result"
        static let success = "success"
        static let failure = "failure"
    }
    
    struct Error {
        static let methodNotImplemented = "Method not implemented"
    }
}
