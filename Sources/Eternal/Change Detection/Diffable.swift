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

/// A protocol for allowing the check of properties that are different
public protocol Diffable {
    /// Returns the properties that differed between two object
    ///
    ///  The protocol implements a standard way to diff objects by using reflexion,
    ///  but the class or struct properties should conform to `DiffEquatable`.
    ///  Some Foundation types already conform to that protocol and can be used without
    ///  any further declarations:
    ///
    ///  `Boolean`, `Int`, `Double`, `Float`, `String`,
    ///  `Data`, `Date`, `Array<Equatable>`
    ///
    ///  On top of these types, all optionals are supported as long as the wrapped
    ///  values implements `DiffEquatable`.
    ///
    ///  - note: If a special logic must be used or you wish to avoid using reflexion, then override this
    ///  method and provide your custom logic. You must also implement the function `propertiesMap`
    ///
    /// - Parameter other: The other object to compare to
    /// - Throws: Can throw `EError` if the properties are not of the supported type or conform to `DiffEquatable`.
    /// - Returns: A list of properties names that have changed values between objects
    func difference(with other: Self) throws -> [String]

    /// Returns all the properties of an object with their values as a dictionary
    var propertiesMap: [String: Any] { get }
}

extension Diffable {

    public var propertiesMap: [String: Any] {
        let mirror = Mirror(reflecting: self)
        var properties: [String: Any] = [:]
        for property in mirror.children {
            guard let label = property.label else {
                continue
            }
            properties[label] =  property.value
        }
        return properties
    }

    public func difference(with other: Self) throws -> [String] {
        let selfProperties = self.propertiesMap
        let otherProperties = other.propertiesMap

        guard selfProperties.count == otherProperties.count else {
            throw EError.UnexpectedError(debugDescription: "Same class instances have different property count")
        }

        var keysWithDifference: [String] = []
        for (key, selfValue) in selfProperties {
            guard let otherValue = otherProperties[key] else {
                throw EError.UnexpectedError(debugDescription: "Property not found in other object \(key)")
            }

            func checkEquality(lhs: Any, rhs: Any) throws -> Bool {
                // Check that both objects are of the same type
                guard type(of: lhs) == type(of: rhs) else {
                    throw EError.UnexpectedError(debugDescription: "Properties \(key) type \(type(of: lhs.self)) and \(type(of: rhs.self)) missmatch.")
                }

                // Check nullability
                let lhsIsNull: Bool
                if let lhsOptional = lhs as? OptionalProtocol {
                    lhsIsNull = lhsOptional.isNull
                } else {
                    lhsIsNull = false
                }
                let rhsIsNull: Bool
                if let rhsOptional = rhs as? OptionalProtocol {
                    rhsIsNull = rhsOptional.isNull
                } else {
                    rhsIsNull = false
                }
                if lhsIsNull || rhsIsNull {
                    return lhsIsNull == rhsIsNull
                }

                // Check equality
                guard let selfValue = lhs as? DiffEquatable else {
                    throw EError.UnexpectedError(debugDescription: "Unexpected property \(key) type \(type(of: lhs.self)). Make sure the property type conforms to `DiffEquatable`")
                }

                return selfValue.checkDiffEquality(other: rhs)
            }

            if try checkEquality(lhs: selfValue, rhs: otherValue) == false {
                keysWithDifference.append(key)
            }
        }

        return keysWithDifference
    }
}

/// A protocol to be implemented by optionals
protocol OptionalProtocol {
    /// If the optional is nil
    var isNull: Bool { get }
}

extension Optional : OptionalProtocol {
    var isNull: Bool {
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }
}

/// A protocol to check equalities when diffing objects
public protocol DiffEquatable {
    /// A protocol to check equalities when diffing objects.
    func checkDiffEquality(other: Any) -> Bool
}

extension Bool: DiffEquatable {
    public func checkDiffEquality(other: Any) -> Bool {
        return self == other as! Bool
    }
}

extension Int: DiffEquatable {
    public func checkDiffEquality(other: Any) -> Bool {
        return self == other as! Int
    }
}

extension Float: DiffEquatable {
    public func checkDiffEquality(other: Any) -> Bool {
        return self == other as! Float
    }
}

extension Double: DiffEquatable {
    public func checkDiffEquality(other: Any) -> Bool {
        return self == other as! Double
    }
}

extension String: DiffEquatable {
    public func checkDiffEquality(other: Any) -> Bool {
        return self == other as! String
    }
}

extension Data: DiffEquatable {
    public func checkDiffEquality(other: Any) -> Bool {
        return self == other as! Data
    }
}

extension Date: DiffEquatable {
    public func checkDiffEquality(other: Any) -> Bool {
        return self == other as! Date
    }
}

extension Array: DiffEquatable where Element : Equatable {
    public func checkDiffEquality(other: Any) -> Bool {
        return self == other as! [Element]
    }
}
