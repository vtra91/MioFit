struct RMAPIResponse: Decodable {
    let info: RMInfo
    let results: [RMchar]
}

struct RMInfo: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
struct Location: Decodable {
    let name: String
    let url: String
}

struct Origin: Decodable {
    let name: String
    let url: String
}

struct RMchar: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
