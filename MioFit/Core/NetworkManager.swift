import Foundation
import SwiftUI

enum NetworkError: LocalizedError {
    case invalidURL
    case httpError(code: Int, message: String?)
    case invalidResponse
    case dataError
    case decodingError(DecodingError)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Указанная ссылка не верна"
        case .httpError(code: let code, message: let message):
            switch code {
            case 401: return "Требуется авторизация"
            case 403: return "Доступ запрещен"
            case 404: return "Не найдено"
            case 500...599: return "Ошибка сервера"
            default:
                let detail = message ?? "Нет деталей"
                return "Неопознанная HTTP ошибка: \(code)_\(detail)"
            }
        case .invalidResponse:
            return "Тип полученных данных не верен"
        case .dataError:
            return "Ошибка данных"
        case .decodingError(let error):
                    switch error {
                    case .typeMismatch(let type, let context):
                        let path = context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        return "Ошибка декодирования: Ожидали тип \(type) по пути '\(path)'"
                        
                    case .valueNotFound(let type, let context):
                        let path = context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        return "Ошибка декодирования: Не нашли значение \(type) по пути '\(path)'"
                        
                    case .keyNotFound(let key, let context):
                        let path = context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        let fullPath = path.isEmpty ? key.stringValue : "\(path).\(key.stringValue)"
                        return "Ошибка декодирования: Отсутствует ключ '\(fullPath)'"
                        
                    case .dataCorrupted(let context):
                        return "Ошибка декодирования: JSON поврежден (\(context.debugDescription))"
                        
                    @unknown default:
                        return "Неизвестная ошибка декодирования: \(error.localizedDescription)"
                    }
        }
    }
}

class NetworkManager {
    
    func fetch<T:Decodable>(url: URLRequest, completion: @escaping (Result<T, NetworkError>)  -> Void) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    completion(.failure(.invalidURL))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    let serverMessage = data.flatMap { String(data: $0, encoding: .utf8) }
                    completion(.failure(.httpError(code: httpResponse.statusCode, message: serverMessage)))
                    return
                }
                guard let data = data, !data.isEmpty else {
                    completion(.failure(.dataError))
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch let error as DecodingError {
                    completion(.failure(.decodingError(error)))
                }
                catch {
                    completion(.failure(.dataError))
                }
            }.resume()
    }
}




