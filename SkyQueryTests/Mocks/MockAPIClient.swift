//
//  MockAPIClient.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 10/06/2025.
//

import XCTest
@testable import SkyQuery

final class MockAPIClient: APIClientProtocol {
    var performRequestCalled = false
    var endpointPassed: APIEndpoint?
    var resultToReturn: Any?
    var errorToThrow: Error?

    func performRequest<T>(_ endpoint: APIEndpoint) async throws -> T where T : Decodable {
        performRequestCalled = true
        endpointPassed = endpoint

        if let error = errorToThrow {
            throw error
        }
        if let result = resultToReturn as? T {
            return result
        }
        fatalError("Result to return is not of expected type")
    }
}
