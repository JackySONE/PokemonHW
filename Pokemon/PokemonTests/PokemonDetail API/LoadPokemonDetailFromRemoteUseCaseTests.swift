//
//  LoadPokemonDetailFromRemoteUseCaseTests.swift
//  PokemonTests
//
//  Created by 賴彥宇 on 2022/12/12.
//

import XCTest
import Pokemon

final class LoadPokemonDetailFromRemoteUseCaseTests: XCTestCase {
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = anyURL()
        let (sut, client) = makeSUT()

        sut.load(url: url) { _ in }
        sut.load(url: url) { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let json = makeDetailJSON([:])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversSuccessWithDetailOn200HTTPResponseWithDetail() {
        let (sut, client) = makeSUT()

        let deteail = makeDetail()

        expect(sut, toCompleteWith: .success(deteail.model), when: {
            let json = makeDetailJSON(deteail.json)
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: RemotePokemonDetailLoader? = RemotePokemonDetailLoader(client: client)

        var capturedResults = [RemotePokemonDetailLoader.Result]()
        sut?.load(url: anyURL()) { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: makeDetailJSON([:]))

        XCTAssertTrue(capturedResults.isEmpty)
    }
}

extension LoadPokemonDetailFromRemoteUseCaseTests {
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (PokemonDetailLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePokemonDetailLoader(client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, client)
    }
    
    private func expect(_ sut: PokemonDetailLoader, toCompleteWith expectedResult: Result<PokemonDetail, RemotePokemonDetailLoader.Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load(url: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)

            case let (.failure(receivedError as RemotePokemonDetailLoader.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        waitForExpectations(timeout: 0.1)
    }
    
    private func makeDetailJSON(_ items: [String: Any]) -> Data {
        let json = items
        
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func makeDetail() -> (model: PokemonDetail, json: [String: Any]) {
        
        let properties = [PokemonDetail.Properties(name: "type1"),
                          PokemonDetail.Properties(name: "type2")]
        
        let detailModel = PokemonDetail(
            id: 123,
            imageURL: anyURL(),
            height: 30,
            weight: 34,
            properties: properties)

        let json = [
            "id": detailModel.id,
            "sprites": [
                "front_default": detailModel.imageURL.absoluteString
            ],
            "height": detailModel.height,
            "weight": detailModel.weight,
            "types": detailModel.properties.map { ["type": ["name": $0.name]]}
        ] as [String: Any]

        return (detailModel, json)
    }
}
