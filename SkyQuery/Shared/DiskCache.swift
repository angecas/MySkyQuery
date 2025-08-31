//
//  DiskCache.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 09/06/2025.
//

import Foundation

struct DiskCache<T: Codable> {
    private let fileName: String

    init(fileName: String) {
        self.fileName = fileName
    }

    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(fileName)
    }

    func load() throws -> T {
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(T.self, from: data)
    }

    func save(_ value: T) throws {
        let data = try JSONEncoder().encode(value)
        try data.write(to: fileURL, options: [.atomicWrite])
    }

    func exists() -> Bool {
        FileManager.default.fileExists(atPath: fileURL.path)
    }
}
