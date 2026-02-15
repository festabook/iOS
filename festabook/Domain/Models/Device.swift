import Foundation

// MARK: - 디바이스 등록 요청
struct DeviceRegistrationRequest: Codable {
    let deviceIdentifier: String
    let fcmToken: String
}

// MARK: - 디바이스 등록 응답
struct DeviceRegistrationResponse: Codable {
    let deviceId: Int
}

// MARK: - 디바이스 토큰 갱신 요청
struct DeviceUpdateRequest: Codable {
    let fcmToken: String
}

// MARK: - 축제 알림 구독 요청
struct FestivalNotificationRequest: Codable {
    let deviceId: Int
}

// MARK: - 축제 알림 구독 응답
struct FestivalNotificationResponse: Codable {
    let festivalNotificationId: Int
}

struct FestivalNotificationSubscription: Decodable {
    let festivalNotificationId: Int
    let organizationName: String
    let festivalName: String

    private enum CodingKeys: String, CodingKey {
        case festivalNotificationId
        case organizationName
        case universityName
        case festivalName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        festivalNotificationId = try container.decode(Int.self, forKey: .festivalNotificationId)
        festivalName = try container.decode(String.self, forKey: .festivalName)
        if let decodedOrganizationName = try? container.decode(String.self, forKey: .organizationName) {
            organizationName = decodedOrganizationName
        } else {
            organizationName = try container.decode(String.self, forKey: .universityName)
        }
    }
}
