//
//  MockHelper.swift
//  SkyQueryTests
//
//  Created by Angélica Rodrigues on 10/06/2025.
//

import Foundation

class MockHelper {
    
    static func loadMockFromJSON<T: Codable>(named fileName: String, responseType: T.Type, for testClass: AnyClass) throws -> T {
        let bundle = Bundle(for: testClass)
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            fatalError("Missing file: \(fileName).json")
        }
        let data = try Data(contentsOf: url)
        let decoded = try JSONDecoder().decode(responseType.self, from: data)
        return decoded
    }
}
