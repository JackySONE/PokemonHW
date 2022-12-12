//
//  PokemonDetailUIIntergrationTests.swift
//  PokemonAppTests
//
//  Created by 賴彥宇 on 2022/12/12.
//

import XCTest
import Pokemon
import PokemonIOS
import PokemonApp

final class PokemonDetailUIIntergrationTests: XCTestCase {
    
    func test_load_actions_request_details_from_loader() {
        let url = anyURL()
        let (sut, loader) = makeSUT(url: url)
        XCTAssertTrue(loader.messages.isEmpty)
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.messages, [.load(url)])
    }
    
    func test_on_load_success_renders_details() {
        let (sut, loader) = makeSUT(url: anyURL())
        let pokemonDetail = makeDetail()
        
        sut.loadViewIfNeeded()
        loader.loadCompletes(with: .success(pokemonDetail))
        loader.completeImageLoading()
        
        assertThat(sut, hasViewConfiguredFor: pokemonDetail)
    }
    
    func test_renders_image_from_remote() {
        let (sut, loader) = makeSUT(url: anyURL())
        let detail = makeDetail()
        let imageData = makeImageData()
        
        sut.loadViewIfNeeded()
        loader.loadCompletes(with: .success(detail))
        XCTAssertEqual(sut.renderedImage, .none)
        
        loader.completeImageLoading(with: imageData)
        XCTAssertEqual(sut.renderedImage, imageData)
    }
}

private extension PokemonDetailUIIntergrationTests {
    func makeSUT(url: URL, file: StaticString = #file, line: UInt = #line) -> (PokemonDetailViewController, LoaderSpy) {
        let loader = LoaderSpy()
        let sut = PokemonDetailUIComposer.pokemonDetailComposedWith(url: url,
                                                                    pokemonDetailLoader: loader,
                                                                    imageLoader: loader)
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    class LoaderSpy: PokemonDetailLoader, ImageDataLoader {
        
        enum Message: Equatable {
            case load(URL)
        }
        
        private(set) var messages: [Message] = []
        
        typealias Result = PokemonDetailLoader.Result
        
        private var loadCompletions: [(Result) -> Void] = []
        func load(url: URL, completion: @escaping (Result) -> Void) {
            messages.append(.load(url))
            loadCompletions.append(completion)
        }
        
        func loadCompletes(with result: Result, at index: Int = 0) {
            loadCompletions[index](result)
        }
        
        private struct TaskSpy: ImageDataLoaderTask {
            let cancelCallback: () -> Void
            func cancel() {
                cancelCallback()
            }
        }
        
        private var imageRequests = [(url: URL, completion: (ImageDataLoader.Result) -> Void)]()
        
        var loadedImageURLs: [URL] {
            return imageRequests.map { $0.url }
        }
        
        private(set) var cancelledImageURLs = [URL]()
        
        func load(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
            imageRequests.append((url, completion))
            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }
        
        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(imageData))
        }
        
        func completeImageLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            imageRequests[index].completion(.failure(error))
        }
    }
    
    private func makeDetail() -> PokemonDetail {
        
        let properties = [PokemonDetail.Properties(name: "type1"),
                          PokemonDetail.Properties(name: "type2")]
        
        let detailModel = PokemonDetail(
            id: 123,
            imageURL: anyURL(),
            height: 30,
            weight: 34,
            properties: properties)
        
        return detailModel
    }
    
    func assertThat(_ sut: PokemonDetailViewController, hasViewConfiguredFor item: PokemonDetail, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(sut.idText, String(item.id), file: file, line: line)
        XCTAssertEqual(sut.heightText, String(item.height), file: file, line: line)
        XCTAssertEqual(sut.weightText, String(item.weight), file: file, line: line)
    }
    
    func makeImageData(withColor color: UIColor = .systemTeal) -> Data {
        return makeImage(withColor: color).pngData()!
    }
    
    func makeImage(withColor color: UIColor = .systemTeal) -> UIImage {
        return UIImage.make(withColor: color)
    }
}

private extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}


extension PokemonDetailViewController {
    
    var idText: String? {
        return idLabel.text
    }
    
    var heightText: String? {
        return heightLabel.text
    }
    
    var weightText: String? {
        return weightLabel.text
    }
    
    var renderedImage: Data? {
        return imageView.image?.pngData()
    }
}

func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}
