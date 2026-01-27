import Foundation

protocol FestivalRepository {
    func searchFestivals(keyword: String) async throws -> [Festival]
    func getFestivalDetail() async throws -> FestivalDetail
    func getLineups() async throws -> [Lineup]
}

struct FestivalRepositoryLive: FestivalRepository {
    let api: APIClient
    
    func searchFestivals(keyword: String) async throws -> [Festival] {
        let queryItems = [URLQueryItem(name: "keyword", value: keyword)]
        return try await api.get(Endpoints.Festivals.search, query: queryItems, requiresFestivalId: false)
    }
    
    func getFestivalDetail() async throws -> FestivalDetail {
        return try await api.get(Endpoints.Festivals.detail)
    }
    
    func getLineups() async throws -> [Lineup] {
        return try await api.get(Endpoints.Festivals.lineups)
    }
}
