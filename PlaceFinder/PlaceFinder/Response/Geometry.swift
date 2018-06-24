//
//  Geometry.swift
//
//  Created by OPTLPTP146 on 25/02/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Geometry: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let viewport = "viewport"
    static let bounds = "bounds"
    static let location = "location"
    static let locationType = "location_type"
  }

  // MARK: Properties
  public var viewport: Viewport?
  public var bounds: Bounds?
  public var location: Location?
  public var locationType: String?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    viewport = Viewport(json: json[SerializationKeys.viewport])
    bounds = Bounds(json: json[SerializationKeys.bounds])
    location = Location(json: json[SerializationKeys.location])
    locationType = json[SerializationKeys.locationType].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = viewport { dictionary[SerializationKeys.viewport] = value.dictionaryRepresentation() }
    if let value = bounds { dictionary[SerializationKeys.bounds] = value.dictionaryRepresentation() }
    if let value = location { dictionary[SerializationKeys.location] = value.dictionaryRepresentation() }
    if let value = locationType { dictionary[SerializationKeys.locationType] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.viewport = aDecoder.decodeObject(forKey: SerializationKeys.viewport) as? Viewport
    self.bounds = aDecoder.decodeObject(forKey: SerializationKeys.bounds) as? Bounds
    self.location = aDecoder.decodeObject(forKey: SerializationKeys.location) as? Location
    self.locationType = aDecoder.decodeObject(forKey: SerializationKeys.locationType) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(viewport, forKey: SerializationKeys.viewport)
    aCoder.encode(bounds, forKey: SerializationKeys.bounds)
    aCoder.encode(location, forKey: SerializationKeys.location)
    aCoder.encode(locationType, forKey: SerializationKeys.locationType)
  }

}
