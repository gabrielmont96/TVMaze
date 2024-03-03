//
//  NetworkService.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import Foundation

protocol Executor {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
    var configuration: URLSessionConfiguration { get }
}

class NetworkService<T: NetworkAPI> {
    
    var executor: Executor = URLSession.shared
    
    func request<V: Decodable>(target: T, expecting: V.Type) async -> Result<V, NetworkError> {
        executor.configuration.timeoutIntervalForRequest = 5
        
        do {
            let urlRequest = try NetworkRequestFactory(target: target).build()
            let (data, response) = try await executor.data(for: urlRequest)
            guard response.isSuccess() else {
                return .failure(.api(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -999,
                                     message: String(data: data, encoding: .utf8)))
            }
            let decodedResponse = try JSONDecoder().decode(expecting, from: data)
            return .success(decodedResponse)
        } catch let error as NetworkError {
            return .failure(error)
        } catch let error as DecodingError {
            return .failure(.parse(error))
        } catch let error as URLError {
            return .failure(.network(error))
        } catch {
            return .failure(.unknown(error))
        }
    }
}

extension URLSession: Executor {}
