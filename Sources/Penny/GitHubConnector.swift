import Vapor
import PennyConnector
import Mint

let GITHUB_MICROSERVICE_BASE_URL = Environment.get("GITHUB_MICROSERVICE_URL") ?? "http://localhost:9000"
let GITHUB_MICROSERVICE_KEY = Environment.get("GITHUB_MICROSERVICE_KEY") ?? "tester"

public struct GitHubLinkRequest: Content {
    public let login: String
    public let source: String
    public let sourceId: String
}

struct GitHubConnector {

    let worker: Container
    let headers: HTTPHeaders = HTTPHeaders([
        ("Authorization", "Bearer \(GITHUB_MICROSERVICE_KEY)"),
        ("Accept", "application/json"),
        ("Content-Type", "application/json"),
    ])

    func requestLink(_ req: GitHubLinkRequest) throws -> Future<AccountLinkRequest> {
        let url = GITHUB_MICROSERVICE_BASE_URL + "/link-request"

        let client = try worker.client()
        return client.post(url, headers: headers, content: req).become()
    }
}