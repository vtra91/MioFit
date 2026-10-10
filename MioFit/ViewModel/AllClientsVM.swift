import Combine
import SwiftUI

class AllClientsVM: ObservableObject {
    @Published var characters: [RMchar] = []
    let networkManager = NetworkManager()
    
    
    func collectRMCharacters() {
        if let rawUrl = URL(string: "https://rickandmortyapi.com/api/character") {
            let realUrl = URLRequest(url: rawUrl)
            
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

