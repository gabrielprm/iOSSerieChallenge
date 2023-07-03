//
//  SeriesListPresenterTest.swift
//  iOSSeriesChallengeTests
//
//  Created by Gabriel do Prado Moreira on 02/07/23.
//

import XCTest
@testable import iOSSeriesChallenge

final class SeriesListPresenterTest: XCTestCase {

    var sut: SeriesListPresenter?
    
    func makeSUT() -> (SeriesListPresenter, SeriesListServiceMock, SeriesListCoordinatorSpy, SeriesListViewControllerSpy) {
        let coordinator = SeriesListCoordinatorSpy()
        let service = SeriesListServiceMock()
        let controller = SeriesListViewControllerSpy()
        let sut = SeriesListPresenter(service: service, coordinator: coordinator)
        sut.viewController = controller
        
        return (sut, service, coordinator, controller)
    }
    
    func testFetchSeries_WhenFetchCompleted_ShoudlReturnSuccess() {
        let(sut, _, _, controller) = makeSUT()
        
        sut.fetchSeries()
        
        XCTAssertEqual(controller.showLoaderCount, 1)
        XCTAssertEqual(controller.hideLoaderCount, 1)
        XCTAssertEqual(controller.displaySeriesCount, 1)
    }
    
    func testFetchSeries_WhenHTTPRequestFailure_ShouldReturnError() {
        let(sut, service, _, controller) = makeSUT()
        service.serviceSeriesListError = .httpResponse
        
        sut.fetchSeries()
        
        XCTAssertEqual(controller.showLoaderCount, 1)
        XCTAssertEqual(controller.hideLoaderCount, 1)
    }
    
    func testDownloadImage_WhenImageDownloaded_ShouldReturnImage() {
        let (sut, _, _, _) = makeSUT()
        let expectation = expectation(description: "Image Download Success")
        sut.downloadImage(url: "") { image in
            XCTAssertEqual(image, UIImage(data: Data()))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testDownloadImage_WhenImageFailed_ShouldReturnNil() {
        let (sut, service, _, _) = makeSUT()
        service.isMeantToFailure = true
        let expectation = expectation(description: "Image Download Nil")
        
        sut.downloadImage(url: "") { result in
            XCTAssertNil(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    
    func testSearchSerie_WhenQuerySearched_ShouldReturnSuccess() {
        let (sut, service, _, controller) = makeSUT()
        
        sut.searchSerie(query: "girls")
        
        XCTAssertEqual(controller.showLoaderCount, 1)
        XCTAssertEqual(controller.hideLoaderCount, 1)
        XCTAssertEqual(controller.displaySeriesCount, 1)
    }
    
    func testUpdateSeriesData_WhenDataUpdateRequest_ShouldDisplaySeries() {
        let (sut, _, _, controller) = makeSUT()
        lazy var showImageMock = ShowImage(imageUrl: "")
        lazy var showModelMock = ShowModel(id: 1, name: "XShow", image: showImageMock)
        lazy var embeddedShowMock = EmbeddedShow(show: showModelMock)
        
        sut.allSeriesModel = [embeddedShowMock]
        
        sut.updateSeriesData()
        
        XCTAssertEqual(controller.displaySeriesCount, 1)
        XCTAssert(controller.series != nil)
        XCTAssertEqual(controller.series, [embeddedShowMock])
        XCTAssertEqual(sut.currentDataIndex, 1)
        
    }
    
    func testNavigateToDetailsPage_WhenSerieSelected_ShouldPresentNextScene() {
        let (sut, _, coordinator, _) = makeSUT()
        
        sut.navigateToDetailsPage(id: 101)
        
        XCTAssertEqual(coordinator.openDetailsPageCount, 1)
        XCTAssertEqual(coordinator.id, 101)
    }
    
    func testSetDataToDisplay_WhenDataHasLessThan20Items_ShouldReturnData() {
        let (sut, _, _, _) = makeSUT()
        lazy var showImageMock = ShowImage(imageUrl: "")
        lazy var showModelMock = ShowModel(id: 1, name: "XShow", image: showImageMock)
        lazy var embeddedShowMock = EmbeddedShow(show: showModelMock)
        
        let returnedData = sut.setDataToDisplay(fullData: [embeddedShowMock])
        
        XCTAssertEqual(returnedData.count, [embeddedShowMock].count)
        XCTAssertEqual(returnedData, [embeddedShowMock])
    }
    
    func testSetDataToDisplay_WhenDataHasMoreThan20Items_ShouldReturnADataSet() {
        let (sut, _, _, _) = makeSUT()
        lazy var showImageMock = ShowImage(imageUrl: "")
        lazy var showModelMock = ShowModel(id: 1, name: "XShow", image: showImageMock)
        lazy var embeddedShowMock = EmbeddedShow(show: showModelMock)
        
        var embeddedShowArray: [EmbeddedShow] = []
        
        for _ in 1...30 {
            embeddedShowArray.append(embeddedShowMock)
        }
        
        let expectedResult = embeddedShowArray[0..<20]
        
        let returnedData = sut.setDataToDisplay(fullData: embeddedShowArray)
        
        XCTAssertEqual(returnedData.count, expectedResult.count)
        XCTAssertEqual(returnedData, Array(expectedResult))
    }
}

class SeriesListCoordinatorSpy: SeriesListCoordinating {
    private(set) var openDetailsPageCount = 0
    private(set) var id = 0
    func openDetailsPage(id: Int) {
        openDetailsPageCount += 1
        self.id = id
    }
}

class SeriesListServiceMock: SeriesListServicing {
    var isMeantToFailure = false
    
    var serviceSeriesListError: ServiceSeriesListErrors = .httpResponse
    
    lazy var showImageMock = ShowImage(imageUrl: "")
    lazy var showModelMock = ShowModel(id: 1, name: "XShow", image: showImageMock)
    lazy var embeddedShowMock = EmbeddedShow(show: showModelMock)
    lazy var homeSeriesModelMock = HomeSeriesListModel(_embedded: embeddedShowMock)
    
    func fetchAllSeries(completion: @escaping fetchSeriesCompletionHandler) {
        if !isMeantToFailure {
            completion(.success([homeSeriesModelMock]))
        } else {
            completion(.failure(serviceSeriesListError))
        }
    }
    
    func searchSeries(query: String, completion: @escaping searchSeriesCompletionHandler) {
        if !isMeantToFailure {
            completion(.success([embeddedShowMock]))
        } else {
            completion(.failure(serviceSeriesListError))
        }
    }
    
    func downloadImage(from url: URL, completion: @escaping downloadImageCompletionHandler) {
        if !isMeantToFailure {
            completion(.success(Data()))
        } else {
            completion(.failure(serviceSeriesListError))
        }
    }
}

class SeriesListViewControllerSpy: SeriesListDisplaying {
    private(set) var displaySeriesCount = 0
    private(set) var series: [EmbeddedShow]?
    
    func displaySeries(series: [EmbeddedShow]) {
        displaySeriesCount += 1
        self.series = series
    }
    
    private(set) var showLoaderCount = 0
    func showLoader() {
        showLoaderCount += 1
    }
    
    private(set) var hideLoaderCount = 0
    func hideLoader() {
        hideLoaderCount += 1
    }
}
