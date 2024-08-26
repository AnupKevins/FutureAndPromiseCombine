//
//  FuturesAndPromises.swift
//  CombineSeries
//
//  Created by Anup kumar sahu on 30/07/24.
//

import Foundation
import SwiftUI
import Combine

class FuturesAndPromisesViewModel: ObservableObject {
    
    @Published var title: String = "new title"
    let url = URL(string: "https://www.google.com")!
    var cancellables = Set<AnyCancellable>()
    init() {
       fetch()
    }
    
    func fetch() {
//        getCombinePublisher()
        getFuturePublisher()
            .sink(receiveCompletion: {
                _ in
            }, receiveValue: { [weak self] returnedValue in
                self?.title = returnedValue
            }).store(in: &cancellables)
        
//        getEscapingClosure { [weak self] returnedValue, error in
//            self?.title = returnedValue
//        }
        
    }
    
    func getCombinePublisher() -> AnyPublisher<String, URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .timeout(1, scheduler: DispatchQueue.main)
            .map({ _ in
                return "New Value"
            })
            .eraseToAnyPublisher()
    }
    
    func getEscapingClosure(completionHandler: @escaping (_ value: String, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            completionHandler("New Value 2", nil)
        }).resume()
    }
    
    func getFuturePublisher() -> Future<String, Error> {
        return Future { promise in
            self.getEscapingClosure { returnedValue, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(returnedValue))
                }
            }
        }
    }
    
    func doSomething(completionHandler: @escaping (_ value: String) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            completionHandler("New String")
        }
    }
    
    func doSomethingInTheFuture() -> Future<String, Never> {
        Future { promise in
            self.doSomething { value in
                promise(.success(value))
            }
        }
    }
}
