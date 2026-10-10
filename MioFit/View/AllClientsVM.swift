import Foundation
import SwiftUI

class AllClientsVM: ObservableObject {
    @Published var characters: [RMchar] = []
    дт б
    func collectRMCharacters() {
        if let rawUrl = URL(string: "https://rickandmortyapi.com/api/character") {
            let realUrl = URLRequest(url: rawUrl)
            init(networkManager: NetworkManager = NetworkManager.shared) {
                    self.networkManager = networkManager
                }
            
            
            networkManager.fetch(url: realUrl) { [weak self] (result: Result<RMAPIResponse, NetworkError>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let apiResponse):
                        self?.characters = apiResponse.results
                    case .failure(let error):
                        print("Ошибка загрузки: \(error)")
                        self?.characters =  []
                    }
                }
            }
        }
}
}

