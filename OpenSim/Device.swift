//
//  Device.swift
//  SimPholders
//
//  Created by Luo Sheng on 11/9/15.
//  Copyright © 2015 Luo Sheng. All rights reserved.
//

import Foundation

enum State {
    case shutdown
    case booted
    case unknown
}

enum Availability {
    case available
    case unavailable
}

struct Device {
    private let stateValue: String
    private let availabilityValue: String
    public let name: String
    public let UDID: String
}

extension Device {
    public var applications: [Application]? {
        let applicationPath = URLHelper.deviceURLForUDID(self.UDID).appendingPathComponent("data/Containers/Bundle/Application")
        let contents = try? FileManager.default.contentsOfDirectory(at: applicationPath, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles])
            return contents?
                .filter({ (url) -> Bool in
                    var isDirectoryObj: AnyObject?
                    try? (url as NSURL).getResourceValue(&isDirectoryObj, forKey: URLResourceKey.isDirectoryKey)
                    guard let isDirectory = isDirectoryObj as? Bool else {
                        return false
                    }
                    return isDirectory
                })
                .map { Application(device: self, url: $0) }
                .filter { $0 != nil }
                .map { $0! }
    }
    
    public var state: State {
        switch stateValue {
        case "Booted":
            return .booted
        case "Shutdown":
            return .shutdown
        default:
            return .unknown
        }
    }
    
    public var availability: Availability {
        switch availabilityValue {
        case "(available)":
            return .available
        default:
            return .unavailable
        }
    }
    
    public func containerURLForApplication(_ application: Application) -> URL? {
        let URL = URLHelper.containersURLForUDID(UDID)
        let directories = try? FileManager.default.contentsOfDirectory(at: URL, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
        return directories?.filter({ (dir) -> Bool in
            if let contents = NSDictionary(contentsOf: dir.appendingPathComponent(".com.apple.mobile_container_manager.metadata.plist")),
                let identifier = contents["MCMMetadataIdentifier"] as? String, identifier == application.bundleID {
                return true
            }
            return false
        }).first
    }
}

extension Device: Decodable {
    enum CodingKeys: String, CodingKey {
        case UDID = "udid"
        case name
        case stateValue = "state"
        case availabilityValue = "availability"
    }
}
