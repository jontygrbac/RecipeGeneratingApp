//
//  WhatCanICookTests.swift
//  WhatCanICookTests
//
//  Created by Jonty Grbac on 15/10/2023.
//

import XCTest
@testable import WhatCanICook

final class WhatCanICookTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    

    func testDietCount() {
        let profile = Profile()
        XCTAssertEqual(profile.diet.count, 0, "Diet count is not 0 on creation")
    }
    
    
    func testDefaults() {
        let profile = Profile()
        XCTAssertEqual(profile.dietTypes.count, 5, "Diet types count is not 5 on creation")
    }
    
    func testConstants() {
        XCTAssertEqual(Constants.OPEN_API_KEY, "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")
    }
    
    func testSavedRecipeCount() {
        let saved = Saved()
        XCTAssertEqual(saved.savedRecipes.count, 0, "SavedRecipes count is not 0 on creation")
    }
    
    func testAllergiesCount() {
        let preferences = PreferencesView()
        XCTAssertEqual(preferences.allergies.count, 0, "Preferences count is not 0 on creation")
    }
    
    func testFridgeToggleView() {
        let fridge = Fridge()
        XCTAssertEqual(fridge.toggleView, false, "ToggleView should be false by default")
    }
    
    func testFridgeOptions() {
        let fridge = Fridge()
        XCTAssertEqual(fridge.options[0], "Breakfast", "Breakfast should be the first index")
    }
    
    func testToggleReturn() {
        let fridge = Fridge()
        XCTAssertEqual(fridge.toggleReturn, false, "Toggle Return should be false")
    }
    
    func testIsLoading() {
        let fridge = Fridge()
        XCTAssertEqual(fridge.isLoading, false, "Is Loading should be false")

    }
    
    func testUnsavedVariables() {
        let fridge = Fridge()
        XCTAssertEqual(fridge.unsavedIcon, "", "Should be blank by default")
        XCTAssertEqual(fridge.unsavedRecipeName, "", "Should be blank by default")
        XCTAssertEqual(fridge.unsavedRecipeMethod, "", "Should be blank by default")
        XCTAssertEqual(fridge.unsavedRecipeIngredient, "", "Should be blank by default")
    }
}

