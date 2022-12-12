//
//  PokemonDetailViewPresenterTests.swift
//  PokemonTests
//
//  Created by 賴彥宇 on 2022/12/12.
//

import XCTest
import Pokemon

class PokemonDetailViewPresenterTests: XCTestCase {
    
    func test_on_init_does_not_message_view() {
        let (_, view) = makeSUT()
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    func test_on_start_loading_hides_error_and_starts_loading_state() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoading()
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        
        XCTAssertEqual(message?.isLoading, true)
        XCTAssertNil(message?.id)
        XCTAssertNil(message?.height)
        XCTAssertNil(message?.weight)
        XCTAssertNil(message?.types)
        XCTAssertNil(message?.image)
        XCTAssertNil(message?.errorMessage)
    }
    
    func test_on_load_pokemonDetail_error_sets_message_and_stops_loading() {
        let (sut, view) = makeSUT()
        let error = anyNSError()
        
        sut.didFinishLoading(with: error)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertNil(message?.id)
        XCTAssertNil(message?.height)
        XCTAssertNil(message?.weight)
        XCTAssertNil(message?.types)
        XCTAssertNil(message?.image)
        XCTAssertEqual(message?.errorMessage, error.localizedDescription)
    }
    
    func test_on_load_pokemonDetail_success_with_failed_image_download_renders_details_and_stops_loading() {
        let (sut, view) = makeSUT()
        let pokemonDetail = makePokemoDetail()
        let error = anyNSError()
        
        sut.didFinishLoadingImageData(with: error, for: pokemonDetail)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.id, String(pokemonDetail.id))
        XCTAssertEqual(message?.height, String(pokemonDetail.height))
        XCTAssertEqual(message?.weight, String(pokemonDetail.weight))
        if let types = message?.types {
            types.enumerated().forEach { index, name in
                XCTAssertEqual(name, pokemonDetail.properties[index].name)
            }
        }
        XCTAssertNil(message?.image)
        XCTAssertNil(message?.errorMessage)
    }
    
    func test_on_load_pokemonDetail_and_image_success_displays_image_on_successful_transformation() {
        let transformedData = SomeImage()
        let (sut, view) = makeSUT(imageTransformer: { _ in transformedData })
        let pokemonDetail = makePokemoDetail()
        
        sut.didFinishLoadingImageData(with: anyData(), for: pokemonDetail)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.id, String(pokemonDetail.id))
        XCTAssertEqual(message?.height, String(pokemonDetail.height))
        XCTAssertEqual(message?.weight, String(pokemonDetail.weight))
        if let types = message?.types {
            types.enumerated().forEach { index, name in
                XCTAssertEqual(name, pokemonDetail.properties[index].name)
            }
        }
        XCTAssertEqual(message?.image, transformedData)
        XCTAssertNil(message?.errorMessage)
    }
}

extension PokemonDetailViewPresenterTests {
    func makeSUT(imageTransformer: @escaping (Data) -> SomeImage? = { _ in nil }, file: StaticString = #file, line: UInt = #line) -> (sut: PokemonDetailViewPresenter<ViewSpy, SomeImage>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = PokemonDetailViewPresenter<ViewSpy, SomeImage>(view: view, imageTransformer: imageTransformer)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    func makePokemoDetail() -> PokemonDetail {
        return PokemonDetail(id: 123,
                             imageURL: anyURL(),
                             height: 40, weight: 20,
                             properties: [PokemonDetail.Properties(name: "type1")])
    }
    
    struct SomeImage: Equatable { }
    
    class ViewSpy: PokemonDetailView {
        
        private(set) var messages: [PokemonDetailViewModel<SomeImage>] = []
        
        func display(_ model: PokemonDetailViewModel<SomeImage>) {
            messages.append(model)
        }
    }
    
}
