import UIKit


protocol DefaultValue {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

extension Bool: DefaultValue {
    static let defaultValue = false
}

extension Bool {
    enum Flase: DefaultValue {
        static let defaultValue = false
    }
    enum True: DefaultValue {
        static let defaultValue = true
    }
}

@propertyWrapper
struct Default<T: DefaultValue> {
    var wrappedValue: T.Value
}

extension Default: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }
}

struct Video: Decodable {
    let id: Int
    let title: String

    @Default<Bool.True> var commentEnabled: Bool
}

let json = """
    {"id": 12345, "title": "My First Video", "commentEnabled": 111}
    """

let decoder = JSONDecoder()
do {
    let data = Data(json.utf8)
    let video = try decoder.decode(Video.self, from: data)
    print(video.commentEnabled)
    print(video)
} catch {
    print("Failed to decode JSON")
}
