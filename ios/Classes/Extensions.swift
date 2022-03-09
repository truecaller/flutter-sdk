//
//  Extensions.swift
//  truecaller_sdk
//
//  Created by Sreedeepkesav M S on 02/03/22.
//

import Foundation
import TrueSDK

extension TCTrueProfileResponse {
    var toDict: [String: AnyHashable] {
        var dict = [String: AnyHashable]()
        dict["payload"] = payload
        dict["signature"] = signature
        dict["signatureAlgorithm"] = signatureAlgorithm
        dict["requestNonce"] = requestNonce
        return dict
    }
}

extension TCTrueProfile {
    var toDict: [String: AnyHashable] {
        var dict = [String: AnyHashable]()
        dict["firstName"] = firstName
        dict["lastName"] = lastName
        dict["isVerified"] = isVerified
        dict["isAmbassador"] = isAmbassador
        dict["phoneNumber"] = phoneNumber
        dict["countryCode"] = countryCode
        dict["street"] = street
        dict["city"] = city
        dict["facebookID"] = facebookID
        dict["twitterID"] = twitterID
        dict["email"] = email
        dict["url"] = url
        dict["avatarURL"] = avatarURL
        dict["jobTitle"] = jobTitle
        dict["companyName"] = companyName
        dict["requestTime"] = requestTime
        dict["genderValue"] = gender.rawValue
        return dict
    }
}

extension TCError {
    var toDict: [String: AnyHashable] {
        var dict = [String: AnyHashable]()
        dict["code"] = getCode()
        dict["message"] = description
        return dict
    }
}

extension Dictionary {
    var tojsonString: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}
