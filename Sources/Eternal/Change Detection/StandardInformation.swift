//
// Eternal
//
// Copyright (c) 2020 Joseph El Mallah - https://github.com/joseph-elmallah/Eternal
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

/// Constitute a collection of informations about a device
public struct DeviceInformation: Diffable, Codable {

    /// The system version
    public let systemVersion: String
    /// The device model
    public let model: String

    /// The current device informations
    public init() {
        self.init(systemVersion: UIDevice.current.systemVersion, model: UIDevice.current.model)
    }

    /// A device information with custom parameters
    /// - Parameters:
    ///   - systemVersion: The operation system version
    ///   - model: The model of the device
    public init(systemVersion: String, model: String) {
        self.systemVersion = systemVersion
        self.model = model
    }
}

/// Constitute a collection of informations about a bundle
public struct BundleInformation: Diffable, Codable, DiffIdentifiable {
    public let diffIdentifier: String
    /// The version of the bundle
    public let version: String?
    /// The build number of the bundle
    public let buildNumber: String?

    /// Provides information about the passed bundle
    /// - Parameter bundle: The bundle to use for the info
    /// - Throws: `EError.UsageError` in case the bundle has no identifier
    public init(bundle: Bundle) throws {
        guard let id = bundle.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String else {
            throw EError.UsageError(debugDescription: "The provided bundle has no identifier")
        }
        diffIdentifier = id
        version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        buildNumber = bundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

    /// Custom bundle information
    /// - Parameters:
    ///   - identifier: The identifier of the bundle
    ///   - version: The version of the bundle
    ///   - buildNumber: The build number of the bundle
    public init(identifier: String, version: String?, buildNumber: String?) {
        self.diffIdentifier = identifier
        self.version = version
        self.buildNumber = buildNumber
    }

    /// The main bundle information
    public static var main: BundleInformation {
        try! BundleInformation(bundle: .main)
    }
}
