//
// StencilSwiftKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Stencil

enum Filters {
  enum Error: Swift.Error {
    case invalidInputType
    case invalidOption(option: String)
  }

  /// Parses filter arguments for a boolean value, where true can by any one of: "true", "yes", "1", and
  /// false can be any one of: "false", "no", "0". If optional is true it means that the argument on the filter is
  /// optional and it's not an error condition if the argument is missing or not the right type
  ///
  /// - Parameters:
  ///   - arguments: an array of argument values, may be empty
  ///   - index: the index in the arguments array
  ///   - required: If true, the argument is required and function throws if missing.
  ///               If false, returns nil on missing args.
  /// - Throws: Filters.Error.invalidInputType
  static func parseBool(from arguments: [Any?], at index: Int = 0, required: Bool = true) throws -> Bool? {
    guard index < arguments.count, let boolArg = arguments[index] as? String else {
      if required {
        throw Error.invalidInputType
      } else {
        return nil
      }
    }

    switch boolArg.lowercased() {
    case "false", "no", "0":
      return false
    case "true", "yes", "1":
      return true
    default:
      throw Error.invalidInputType
    }
  }

  /// Parses filter arguments for an enum value (with a String rawvalue).
  ///
  /// - Parameters:
  ///   - arguments: an array of argument values, may be empty
  ///   - index: the index in the arguments array
  ///   - default: The default value should no argument be provided
  /// - Throws: Filters.Error.invalidInputType
  static func parseEnum<T>(from arguments: [Any?], at index: Int = 0, default: T) throws -> T
    where T: RawRepresentable, T.RawValue == String {

    guard index < arguments.count else { return `default` }
    let arg = arguments[index].map(String.init(describing:)) ?? `default`.rawValue

    guard let result = T(rawValue: arg) else {
      throw Filters.Error.invalidOption(option: arg)
    }

    return result
  }
}
