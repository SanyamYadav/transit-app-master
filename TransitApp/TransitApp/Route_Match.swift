**
 A `RouteShapeFormat` indicates the format of a route’s shape in the raw HTTP response.
 */
@objc(MBRouteShapeFormat)
public enum RouteShapeFormat: UInt, CustomStringConvertible {
    /**
     The route’s shape is delivered in [GeoJSON](http://geojson.org/) format.
     This standard format is human-readable and can be parsed straightforwardly, but it is far more verbose than `polyline`.
     */
    case geoJSON
    /**
     The route’s shape is delivered in [encoded polyline algorithm](https://developers.google.com/maps/documentation/utilities/polylinealgorithm) format with 1×10<sup>−5</sup> precision.
     This machine-readable format is considerably more compact than `geoJSON` but less precise than `polyline6`.
     */
    case polyline
    /**
     The route’s shape is delivered in [encoded polyline algorithm](https://developers.google.com/maps/documentation/utilities/polylinealgorithm) format with 1×10<sup>−6</sup> precision.
     This format is an order of magnitude more precise than `polyline`.
     */
    case polyline6

    public init?(description: String) {
        let format: RouteShapeFormat
        switch description {
        case "geojson":
            format = .geoJSON
        case "polyline":
            format = .polyline
        case "polyline6":
            format = .polyline6
        default:
            return nil
        }
        self.init(rawValue: format.rawValue)
    }

    public var description: String {
        switch self {
        case .geoJSON:
            return "geojson"
        case .polyline:
            return "polyline"
        case .polyline6:
            return "polyline6"
        }
    }
}

/**
 A `RouteShapeResolution` indicates the level of detail in a route’s shape, or whether the shape is present at all.
 */
@objc(MBRouteShapeResolution)
public enum RouteShapeResolution: UInt, CustomStringConvertible {
    /**
     The route’s shape is omitted.
     Specify this resolution if you do not intend to show the route line to the user or analyze the route line in any way.
     */
    case none
    /**
     The route’s shape is simplified.
     This resolution considerably reduces the size of the response. The resulting shape is suitable for display at a low zoom level, but it lacks the detail necessary for focusing on individual segments of the route.
     */
    case low
    /**
     The route’s shape is as detailed as possible.
     The resulting shape is equivalent to concatenating the shapes of all the route’s consitituent steps. You can focus on individual segments of this route while faithfully representing the path of the route. If you only intend to show a route overview and do not need to analyze the route line in any way, consider specifying `low` instead to considerably reduce the size of the response.
     */
    case full

    public init?(description: String) {
        let granularity: RouteShapeResolution
        switch description {
        case "false":
            granularity = .none
        case "simplified":
            granularity = .low
        case "full":
            granularity = .full
        default:
            return nil
        }
        self.init(rawValue: granularity.rawValue)
    }

    public var description: String {
        switch self {
        case .none:
            return "false"
        case .low:
            return "simplified"
        case .full:
            return "full"
        }
    }
}

/**
 A system of units of measuring distances and other quantities.
 */
@objc(MBMeasurementSystem)
public enum MeasurementSystem: UInt, CustomStringConvertible {

    /**
     U.S. customary and British imperial units.
     Distances are measured in miles and feet.
     */
    case imperial

    /**
     The metric system.
     Distances are measured in kilometers and meters.
     */
    case metric

    public init?(description: String) {
        let measurementSystem: MeasurementSystem
        switch description {
        case "imperial":
            measurementSystem = .imperial
        case "metric":
            measurementSystem = .metric
        default:
            return nil
        }
        self.init(rawValue: measurementSystem.rawValue)
    }

    public var description: String {
        switch self {
        case .imperial:
            return "imperial"
        case .metric:
            return "metric"
        }
    }
}

/**
 A `RouteOptions` object is a structure that specifies the criteria for results returned by the Mapbox Directions API.
 Pass an instance of this class into the `Directions.calculate(_:completionHandler:)` method.
 */
@objc(MBRouteOptions)
open class RouteOptions: NSObject, NSSecureCoding, NSCopying{
    // MARK: Creating a Route Options Object
    /**
     Initializes a route options object for routes between the given waypoints and an optional profile identifier.
     - parameter waypoints: An array of `Waypoint` objects representing locations that the route should visit in chronological order. The array should contain at least two waypoints (the source and destination) and at most 25 waypoints. (Some profiles, such as `MBDirectionsProfileIdentifierAutomobileAvoidingTraffic`, [may have lower limits](https://www.mapbox.com/api-documentation/#directions).)
     - parameter profileIdentifier: A string specifying the primary mode of transportation for the routes. This parameter, if set, should be set to `MBDirectionsProfileIdentifierAutomobile`, `MBDirectionsProfileIdentifierAutomobileAvoidingTraffic`, `MBDirectionsProfileIdentifierCycling`, or `MBDirectionsProfileIdentifierWalking`. `MBDirectionsProfileIdentifierAutomobile` is used by default.
     */
    @objc public init(waypoints: [Waypoint], profileIdentifier: MBDirectionsProfileIdentifier? = nil) {
        assert(waypoints.count >= 2, "A route requires at least a source and destination.")
        assert(waypoints.count <= 25, "A route may not have more than 25 waypoints.")

        self.waypoints = waypoints
        self.profileIdentifier = profileIdentifier ?? .automobile
        self.allowsUTurnAtWaypoint = ![MBDirectionsProfileIdentifier.automobile.rawValue, MBDirectionsProfileIdentifier.automobileAvoidingTraffic.rawValue].contains(self.profileIdentifier.rawValue)
    }

    /**
     Initializes a route options object for routes between the given locations and an optional profile identifier.
     - note: This initializer is intended for `CLLocation` objects created using the `CLLocation.init(latitude:longitude:)` initializer. If you intend to use a `CLLocation` object obtained from a `CLLocationManager` object, consider increasing the `horizontalAccuracy` or set it to a negative value to avoid overfitting, since the `Waypoint` class’s `coordinateAccuracy` property represents the maximum allowed deviation from the waypoint.
     - parameter locations: An array of `CLLocation` objects representing locations that the route should visit in chronological order. The array should contain at least two locations (the source and destination) and at most 25 locations. Each location object is converted into a `Waypoint` object. This class respects the `CLLocation` class’s `coordinate` and `horizontalAccuracy` properties, converting them into the `Waypoint` class’s `coordinate` and `coordinateAccuracy` properties, respectively.
     - parameter profileIdentifier: A string specifying the primary mode of transportation for the routes. This parameter, if set, should be set to `MBDirectionsProfileIdentifierAutomobile`, `MBDirectionsProfileIdentifierAutomobileAvoidingTraffic`, `MBDirectionsProfileIdentifierCycling`, or `MBDirectionsProfileIdentifierWalking`. `MBDirectionsProfileIdentifierAutomobile` is used by default.
     */
    @objc public convenience init(locations: [CLLocation], profileIdentifier: MBDirectionsProfileIdentifier? = nil) {
        let waypoints = locations.map { Waypoint(location: $0) }
        self.init(waypoints: waypoints, profileIdentifier: profileIdentifier)
    }

    /**
     Initializes a route options object for routes between the given geographic coordinates and an optional profile identifier.
     - parameter coordinates: An array of geographic coordinates representing locations that the route should visit in chronological order. The array should contain at least two locations (the source and destination) and at most 25 locations. Each coordinate is converted into a `Waypoint` object.
     - parameter profileIdentifier: A string specifying the primary mode of transportation for the routes. This parameter, if set, should be set to `MBDirectionsProfileIdentifierAutomobile`, `MBDirectionsProfileIdentifierAutomobileAvoidingTraffic`, `MBDirectionsProfileIdentifierCycling`, or `MBDirectionsProfileIdentifierWalking`. `MBDirectionsProfileIdentifierAutomobile` is used by default.
     */
    @objc public convenience init(coordinates: [CLLocationCoordinate2D], profileIdentifier: MBDirectionsProfileIdentifier? = nil) {
        let waypoints = coordinates.map { Waypoint(coordinate: $0) }
        self.init(waypoints: waypoints, profileIdentifier: profileIdentifier)
    }

    public required init?(coder decoder: NSCoder) {
        guard let waypoints = decoder.decodeObject(of: [NSArray.self, Waypoint.self], forKey: "waypoints") as? [Waypoint] else {
            return nil
        }
        self.waypoints = waypoints

        allowsUTurnAtWaypoint = decoder.decodeBool(forKey: "allowsUTurnAtWaypoint")

        guard let profileIdentifier = decoder.decodeObject(of: NSString.self, forKey: "profileIdentifier") as String? else {
            return nil
        }
        self.profileIdentifier = MBDirectionsProfileIdentifier(rawValue: profileIdentifier)

        includesAlternativeRoutes = decoder.decodeBool(forKey: "includesAlternativeRoutes")
        includesSteps = decoder.decodeBool(forKey: "includesSteps")

        guard let shapeFormat = RouteShapeFormat(description: decoder.decodeObject(of: NSString.self, forKey: "shapeFormat") as String? ?? "") else {
            return nil
        }
        self.shapeFormat = shapeFormat

        guard let routeShapeResolution = RouteShapeResolution(description: decoder.decodeObject(of: NSString.self, forKey: "routeShapeResolution") as String? ?? "") else {
            return nil
        }
        self.routeShapeResolution = routeShapeResolution

        guard let descriptions = decoder.decodeObject(of: NSString.self, forKey: "attributeOptions") as String?,
            let attributeOptions = AttributeOptions(descriptions: descriptions.components(separatedBy: ",")) else {
            return nil
        }
        self.attributeOptions = attributeOptions

        includesExitRoundaboutManeuver = decoder.decodeBool(forKey: "includesExitRoundaboutManeuver")
        
        if let locale = decoder.decodeObject(of: NSLocale.self, forKey: "locale") as Locale? {
            self.locale = locale
        }

        includesSpokenInstructions = decoder.decodeBool(forKey: "includesSpokenInstructions")
        
        if let distanceMeasurementSystem = MeasurementSystem(description: decoder.decodeObject(of: NSString.self, forKey: "distanceMeasurementSystem") as String? ?? "") {
            self.distanceMeasurementSystem = distanceMeasurementSystem
        }
        
        includesVisualInstructions = decoder.decodeBool(forKey: "includesVisualInstructions")

        let roadClassesToAvoidDescriptions = decoder.decodeObject(of: NSString.self, forKey: "roadClassesToAvoid") as String?
        roadClassesToAvoid = RoadClasses(descriptions: roadClassesToAvoidDescriptions?.components(separatedBy: ",") ?? []) ?? []
    }

    open static var supportsSecureCoding = true

    public func encode(with coder: NSCoder) {
        coder.encode(waypoints, forKey: "waypoints")
        coder.encode(allowsUTurnAtWaypoint, forKey: "allowsUTurnAtWaypoint")
        coder.encode(profileIdentifier, forKey: "profileIdentifier")
        coder.encode(includesAlternativeRoutes, forKey: "includesAlternativeRoutes")
        coder.encode(includesSteps, forKey: "includesSteps")
        coder.encode(shapeFormat.description, forKey: "shapeFormat")
        coder.encode(routeShapeResolution.description, forKey: "routeShapeResolution")
        coder.encode(attributeOptions.description, forKey: "attributeOptions")
        coder.encode(includesExitRoundaboutManeuver, forKey: "includesExitRoundaboutManeuver")
        coder.encode(locale, forKey: "locale")
        coder.encode(includesSpokenInstructions, forKey: "includesSpokenInstructions")
        coder.encode(distanceMeasurementSystem.description, forKey: "distanceMeasurementSystem")
        coder.encode(includesVisualInstructions, forKey: "includesVisualInstructions")
        coder.encode(roadClassesToAvoid.description, forKey: "roadClassesToAvoid")
    }


    /**
     Returns response objects that represent the given JSON dictionary data.
     - parameter json: The API response in JSON dictionary format.
     - returns: A tuple containing an array of waypoints and an array of routes.
     */
    internal func response(from json: JSONDictionary) -> ([Waypoint]?, [Route]?) {
        var namedWaypoints: [Waypoint]?
        if let jsonWaypoints = (json["waypoints"] as? [JSONDictionary]) {
            namedWaypoints = zip(jsonWaypoints, self.waypoints).map { (api, local) -> Waypoint in
                let location = api["location"] as! [Double]
                let coordinate = CLLocationCoordinate2D(geoJSON: location)
                let possibleAPIName = api["name"] as? String
                let apiName = possibleAPIName?.nonEmptyString
                return Waypoint(coordinate: coordinate, name: local.name ?? apiName)
            }
        }
        
        let waypoints = namedWaypoints ?? self.waypoints
        
        let routes = (json["routes"] as? [JSONDictionary])?.map {
            Route(json: $0, waypoints: waypoints, routeOptions: self)
        }
        return (waypoints, routes)
    }
    
    // MARK: NSCopying
    open func copy(with zone: NSZone? = nil) -> Any {
        let copy = RouteOptions(waypoints: waypoints, profileIdentifier: profileIdentifier)
        copy.allowsUTurnAtWaypoint = allowsUTurnAtWaypoint
        copy.includesAlternativeRoutes = includesAlternativeRoutes
        copy.includesSteps = includesSteps
        copy.shapeFormat = shapeFormat
        copy.routeShapeResolution = routeShapeResolution
        copy.attributeOptions = attributeOptions
        copy.includesExitRoundaboutManeuver = includesExitRoundaboutManeuver
        copy.locale = locale
        copy.includesSpokenInstructions = includesSpokenInstructions
        copy.distanceMeasurementSystem = distanceMeasurementSystem
        copy.includesVisualInstructions = includesVisualInstructions
        copy.roadClassesToAvoid = roadClassesToAvoid
        return copy
    }
    
    
    @objc(isEqualToRouteOptions:)
    open func isEqual(to routeOptions: RouteOptions?) -> Bool {
        guard let other = routeOptions else { return false }
        guard waypoints == other.waypoints,
            profileIdentifier == other.profileIdentifier,
            allowsUTurnAtWaypoint == other.allowsUTurnAtWaypoint,
            includesSteps == other.includesSteps,
            shapeFormat == other.shapeFormat,
            routeShapeResolution == other.routeShapeResolution,
            attributeOptions == other.attributeOptions,
            includesExitRoundaboutManeuver == other.includesExitRoundaboutManeuver,
            locale == other.locale,
            includesSpokenInstructions == other.includesSpokenInstructions,
            includesVisualInstructions == other.includesVisualInstructions,
            roadClassesToAvoid == other.roadClassesToAvoid,
            distanceMeasurementSystem == other.distanceMeasurementSystem else { return false }
        return true
    }
}

// MARK: Support for Directions API v4
/**
 A `RouteShapeFormat` indicates the format of a route’s shape in the raw HTTP response.
 */
@objc(MBInstructionFormat)
public enum InstructionFormat: UInt, CustomStringConvertible {
    /**
     The route steps’ instructions are delivered in plain text format.
     */
    case text
    /**
     The route steps’ instructions are delivered in HTML format.
     Key phrases are boldfaced.
     */
    case html

    public init?(description: String) {
        let format: InstructionFormat
        switch description {
        case "text":
            format = .text
        case "html":
            format = .html
        default:
            return nil
        }
        self.init(rawValue: format.rawValue)
    }

    public var description: String {
        switch self {
        case .text:
            return "text"
        case .html:
            return "html"
        }
    }
}

/**
 A `RouteOptionsV4` object is a structure that specifies the criteria for results returned by the Mapbox Directions API v4.
 Pass an instance of this class into the `Directions.calculate(_:completionHandler:)` method.
 */
 
 
@objc(MBRouteOptionsV4)
open class RouteOptionsV4: RouteOptions {
    // MARK: Specifying the Response Format
    /**
     The format of the returned route steps’ instructions.
     By default, the value of this property is `text`, specifying plain text instructions.
     */
     
    @objc open var instructionFormat: InstructionFormat = .text

    /**
     A Boolean value indicating whether the returned routes and their route steps should include any geographic coordinate data.
     If the value of this property is `true`, the returned routes and their route steps include coordinates; if the value of this property is `false, they do not.
     The default value of this property is `true`.
     */
    @objc open var includesShapes: Bool = true

    override var path: String {
        assert(!queries.isEmpty, "No query")

        let profileIdentifier = self.profileIdentifier.rawValue.replacingOccurrences(of: "/", with: ".")
        let queryComponent = queries.joined(separator: ";")
        return "v4/directions/\(profileIdentifier)/\(queryComponent).json"
    }

    override var params: [URLQueryItem] {
        return [
            URLQueryItem(name: "alternatives", value: String(includesAlternativeRoutes)),
            URLQueryItem(name: "instructions", value: String(describing: instructionFormat)),
            URLQueryItem(name: "geometry", value: includesShapes ? String(describing: shapeFormat) : String(false)),
            URLQueryItem(name: "steps", value: String(includesSteps)),
        ]
    }

    override func response(from json: JSONDictionary) -> ([Waypoint]?, [Route]?) {
        let sourceWaypoint = Waypoint(geoJSON: json["origin"] as! JSONDictionary)!
        let destinationWaypoint = Waypoint(geoJSON: json["destination"] as! JSONDictionary)!
        let intermediateWaypoints = (json["waypoints"] as! [JSONDictionary]).flatMap { Waypoint(geoJSON: $0) }
        let waypoints = [sourceWaypoint] + intermediateWaypoints + [destinationWaypoint]
        let routes = (json["routes"] as? [JSONDictionary])?.map {
            RouteV4(json: $0, waypoints: waypoints, routeOptions: self)
        }
        return (waypoints, routes)
    }
}

extension Locale {
    fileprivate var usesMetric: Bool {
        guard let measurementSystem = (self as NSLocale).object(forKey: .measurementSystem) as? String else {
            return false
        }
        return measurementSystem == "Metric"
    }
}
