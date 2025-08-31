//
//  APIClientProtocol.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 05/06/2025.
//


import Foundation
import Foundation


// MARK: - Endpoits Protocol

protocol APIEndpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: - API Client Protocol
protocol APIClientProtocol {
    func performRequest<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

// MARK: - API Client Implementation
final class APIClient: APIClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func performRequest<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }
        print("Request URL: \(url.absoluteString)")

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        let (data, response) = try await session.data(for: request)
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON response:\n\(jsonString)")
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error:", error)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON:\n\(jsonString)")
            }
            throw error
        }
    }
}
