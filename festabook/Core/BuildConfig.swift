// FestabookiOS/Config/BuildConfig.swift
import Foundation

enum BuildConfig {
    /// 기본 웹 베이스 URL
    private static let defaultDevImageBaseURL = "https://dev.festabook.app"
    private static let defaultProdImageBaseURL = "https://festabook.app"
    private static let defaultDevAPIBaseURL = "https://dev.api.festabook.app"
    private static let defaultProdAPIBaseURL = "https://api.festabook.app"
    
    static var apiBaseURL: URL {
        let configured = string(for: "API_BASE_URL")
        let rawURLString = configured.isEmpty ? defaultAPIBaseURL : configured
        let normalizedURLString = normalizeAPIBaseURL(rawURLString)
        return URL(string: normalizedURLString)!
    }

    /// 베이스 URL (이미지 경로 등에 사용)
    static var baseURL: String {
        let configured = string(for: "IMAGE_BASE_URL")
        return configured.isEmpty ? defaultImageBaseURL : configured
    }

    static var naverMapClientId: String { string(for: "NAVER_MAP_CLIENT_ID") }

    private static var defaultAPIBaseURL: String {
        #if DEBUG
        return defaultDevAPIBaseURL
        #else
        return defaultProdAPIBaseURL
        #endif
    }

    private static var defaultImageBaseURL: String {
        #if DEBUG
        return defaultDevImageBaseURL
        #else
        return defaultProdImageBaseURL
        #endif
    }

    private static func string(for key: String) -> String {
        // 여러 방법으로 시도
        if let value = Bundle.main.object(forInfoDictionaryKey: key) as? String, !value.isEmpty {
            return value
        }
        
        // 프로세스 환경 변수에서도 시도
        if let value = ProcessInfo.processInfo.environment[key], !value.isEmpty {
            return value
        }
        
        return ""
    }

    private static func normalizeAPIBaseURL(_ value: String) -> String {
        var normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if normalized.hasSuffix("/api/") {
            normalized.removeLast(5)
        } else if normalized.hasSuffix("/api") {
            normalized.removeLast(4)
        }
        if normalized.hasSuffix("/") {
            normalized.removeLast()
        }
        return normalized
    }
}

enum ImageURLResolver {
    private static var baseURL: URL {
        return URL(string: BuildConfig.baseURL + "/")!
    }

    static func resolve(_ path: String?) -> String? {
        guard let path = path, !path.isEmpty else { return nil }

        let lowercased = path.lowercased()
        if lowercased.hasPrefix("http://") || lowercased.hasPrefix("https://") {
            return path
        }

        let trimmed = path.hasPrefix("/") ? String(path.dropFirst()) : path
        return baseURL.appendingPathComponent(trimmed).absoluteString
    }
}
