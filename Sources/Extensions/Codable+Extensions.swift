//
//  Codable+Extensions.swift
//  GetStreamChat
//
//  Created by Alexey Bukhtin on 02/04/2019.
//  Copyright © 2019 Stream.io Inc. All rights reserved.
//

import Foundation

// MARK: - JSONDecoder Stream

extension JSONDecoder {
    public static let stream: JSONDecoder = {
        let decoder = JSONDecoder()
        
        /// A custom decoding for a date.
        decoder.dateDecodingStrategy = .custom { decoder throws -> Date in
            let container = try decoder.singleValueContainer()
            let string: String = try container.decode(String.self)
            
            if let date = DateFormatter.Stream.iso8601Date(from: string) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
        }
        
        return decoder
    }()
}

// MARK: - JSONEncoder Stream

extension JSONEncoder {
    public static let stream: JSONEncoder = {
        let encoder = JSONEncoder()
        
        /// A custom encoding for the custom ISO8601 date.
        encoder.dateEncodingStrategy = .custom { date, encoder throws in
            var container = encoder.singleValueContainer()
            try container.encode(DateFormatter.Stream.iso8601DateString(from: date))
        }
        
        return encoder
    }()
}

// MARK: - Date Formatter Helper

extension DateFormatter {
    public struct Stream {
        public static func iso8601Date(from string: String) -> Date? {
            if #available(iOS 11, macOS 10.13, *) {
                return Stream.iso8601DateFormatter.date(from: string)
            }
            
            return Stream.dateFormatter.date(from: string)
        }
        
        public static func iso8601DateString(from date: Date) -> String? {
            if #available(iOS 11, macOS 10.13, *) {
                return Stream.iso8601DateFormatter.string(from: date)
            }
            
            return Stream.dateFormatter.string(from: date)
        }
        
        private static let iso8601DateFormatter: ISO8601DateFormatter = {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return formatter
        }()
        
        private static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            return formatter
        }()
    }
}

// MARK: - Helper AnyEncodable

struct AnyEncodable: Encodable {
    private let encodable: Encodable
    
    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }
    
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}