//
//  WeatherOnSwiftUITests.swift
//  WeatherOnSwiftUITests
//
//  Created by Dmitrii Zverev on 22/8/2022.
//

import XCTest
@testable import WeatherOnSwiftUI

class WeatherOnSwiftUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testJSON() throws {
        let str = """
         {
             "coord": {
                 "lon": -80.6081,
                 "lat": 28.0836
             },
             "weather": [
                 {
                     "id": 800,
                     "main": "Clear",
                     "description": "clear sky",
                     "icon": "01n"
                 }
             ],
             "base": "stations",
             "main": {
                 "temp": 290.3,
                 "feels_like": 288.56,
                 "temp_min": 288.71,
                 "temp_max": 292.15,
                 "pressure": 1015,
                 "humidity": 63
             },
             "visibility": 10000,
             "wind": {
                 "speed": 2.57,
                 "deg": 230
             },
             "clouds": {
                 "all": 1
             },
             "dt": 1612577101,
             "sys": {
                 "type": 1,
                 "id": 4922,
                 "country": "US",
                 "sunrise": 1612526834,
                 "sunset": 1612566343
             },
             "timezone": -18000,
             "id": 4163971,
             "name": "Melbourne",
             "cod": 200
         }
        """
        let jsonData = str.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let weatherData: WeatherData = try decoder.decode(WeatherData.self, from: jsonData)
        XCTAssertTrue(weatherData.name == "Melbourne")

        self.testIfAllGood(with: weatherData)
    }
    
    func testIfAllGood(with weatherData: WeatherData) {
        XCTAssertNotNil(weatherData)
    }
    
    func testRepository() async {
        let repo1 = HistorySearchStorage(userDefaultsKey: "test")
        
        // Checking Repo cleared
        await repo1.clearCache()
        XCTAssertTrue(repo1.getSearchHistory().isEmpty)

        // Checking saving works
        let count1 = repo1.getSearchHistory().count
        await repo1.save(data: .example)
        let count2 = repo1.getSearchHistory().count
        XCTAssertTrue(count1 == count2 - 1)
        XCTAssertTrue(!repo1.getSearchHistory().isEmpty)

        // Checking adding same element doesn't add but just update existing
        XCTAssertTrue(repo1.getSearchHistory().first?.name != "test")
        var example2 = WeatherData.example
        example2.name = "test"
        await repo1.save(data: example2)
        XCTAssertTrue(count2 == repo1.getSearchHistory().count)
        XCTAssertTrue(repo1.getSearchHistory().first?.name == "test")

        // Checking Repo userDefaultsKey works
        let repo2 = HistorySearchStorage(userDefaultsKey: "test2")
        await repo2.clearCache()
        XCTAssertTrue(!repo1.getSearchHistory().isEmpty)
    }
    
    func testApi() async {
        let serviceManager = ServiceManager()
        let promiseValidData = expectation(description: "Object from API is correct")
        do {
            let data = try await serviceManager.loadData(apiPath: .update(id: 4163971))
            promiseValidData.fulfill()
            self.testIfAllGood(with: data)
        } catch {
            print("Error:", error)
            XCTFail(error.localizedDescription)
        }
        wait(for: [promiseValidData], timeout: 10)
    }
    
    func testApiFail() async {
        let serviceManager = ServiceManager()
        let promiseInvalidData = expectation(description: "Object from API is NOT correct")
        do {
            let data = try await serviceManager.loadData(apiPath: .update(id: 0))
            self.testIfAllGood(with: data)
        } catch {
            print("Error:", error)
            promiseInvalidData.fulfill()
        }
        wait(for: [promiseInvalidData], timeout: 10)
    }
    
    func testImageLoaderWorks() async {
        guard let  rainUrl = WeatherData.example.getImageUrl() else {
            XCTFail("Incodrrect url")
            return
        }
        let promiseValidData = expectation(description: "Data was loaded")
        let promiseValidDataIsImage = expectation(description: "Data is Image")
        do {
            let (data, _) = try await URLSession.shared.data(from: rainUrl)
            promiseValidData.fulfill()
            let image = UIImage(data: data)
            if image != nil {
                promiseValidDataIsImage.fulfill()
            }
        } catch {
            print("Error:", error)
            XCTFail(error.localizedDescription)
        }
        wait(for: [promiseValidData, promiseValidDataIsImage], timeout: 5)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
