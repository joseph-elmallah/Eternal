//
// Eternal
//
// Copyright (c) 2020 Joseph El Mallah - https://github.com/joseph-elmallah/Eternal
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import XCTest
@testable import Eternal

final class DiffableTests: XCTestCase {
    func testNotConform() {

        let obj1 = DiffNotConform()
        let obj2 = DiffNotConform()
        XCTAssertThrowsError(try obj1.difference(with: obj2)) { error in
            if case EError.UnexpectedError(debugDescription: _) = error {
            } else {
                XCTFail("Unexpected error thrown")
            }
        }
    }

    func testNoDiff() {
        do {
            let obj1 = DiffObject()
            let obj2 = DiffObject()
            let diff = try obj1.difference(with: obj2)
            XCTAssertTrue(diff.isEmpty)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDiffBool() {
        do {
            var obj1 = DiffObject()
            obj1.boo = false
            let obj2 = DiffObject()
            let diff = try obj1.difference(with: obj2)
            XCTAssertEqual(diff.count, 1)
            XCTAssertEqual(diff.first, "boo")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDiffString() {
        do {
            var obj1 = DiffObject()
            obj1.str = "MM"
            let obj2 = DiffObject()
            let diff = try obj1.difference(with: obj2)
            XCTAssertEqual(diff.count, 1)
            XCTAssertEqual(diff.first, "str")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDiffInt() {
        do {
            var obj1 = DiffObject()
            obj1.int = 10
            let obj2 = DiffObject()
            let diff = try obj1.difference(with: obj2)
            XCTAssertEqual(diff.count, 1)
            XCTAssertEqual(diff.first, "int")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDiffFloat() {
        do {
            var obj1 = DiffObject()
            obj1.flo = 99.3
            let obj2 = DiffObject()
            let diff = try obj1.difference(with: obj2)
            XCTAssertEqual(diff.count, 1)
            XCTAssertEqual(diff.first, "flo")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDiffDouble() {
        do {
            var obj1 = DiffObject()
            obj1.dou = 33.2344
            let obj2 = DiffObject()
            let diff = try obj1.difference(with: obj2)
            XCTAssertEqual(diff.count, 1)
            XCTAssertEqual(diff.first, "dou")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDiffData() {
        do {
            var obj1 = DiffObject()
            obj1.daa = "MM".data(using: .utf8)!
            let obj2 = DiffObject()
            let diff = try obj1.difference(with: obj2)
            XCTAssertEqual(diff.count, 1)
            XCTAssertEqual(diff.first, "daa")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDiffDate() {
        do {
            var obj1 = DiffObject()
            obj1.dae = Date(timeIntervalSince1970: 1588289555)
            let obj2 = DiffObject()
            let diff = try obj1.difference(with: obj2)
            XCTAssertEqual(diff.count, 1)
            XCTAssertEqual(diff.first, "dae")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDiffAll() {
        do {
            var obj1 = DiffObject()
            obj1.boo = false
            obj1.str = "FRT"
            obj1.int = 3
            obj1.flo = 23.3
            obj1.dou = 499.11314
            obj1.daa = "MM".data(using: .utf8)!
            obj1.dae = Date(timeIntervalSince1970: 1588289555)
            let obj2 = DiffObject()
            let diff = try obj1.difference(with: obj2)
            XCTAssertEqual(diff.count, 7)
            XCTAssertEqual(diff.sorted(), [
                "boo",
                "str",
                "int",
                "flo",
                "dou",
                "daa",
                "dae",
                ].sorted())
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDiffArr() {
        do {
            var obj1 = DiffArr()
            obj1.arr = ["sdfsdf"]
            let obj2 = DiffArr()
            let diff = try obj1.difference(with: obj2)
            XCTAssertEqual(diff.count, 1)
            XCTAssertEqual(diff.first, "arr")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDiffNull() {
        do {
            var obj1 = DiffNullable()
            obj1.str = "asd"
            let obj2 = DiffNullable()
            let diff = try obj1.difference(with: obj2)
            XCTAssertEqual(diff.count, 1)
            XCTAssertEqual(diff.first, "str")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testEqualNull() {
        do {
            let obj1 = DiffNullable()
            let obj2 = DiffNullable()
            let diff = try obj1.difference(with: obj2)
            XCTAssertTrue(diff.isEmpty)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

struct DiffObject: Diffable {
    var boo: Bool = true
    var str: String = "abcd"
    var int: Int = 1
    var flo: Float = 2.3
    var dou: Double = 4.444445
    var daa: Data = "sba".data(using: .utf8)!
    var dae: Date = Date(timeIntervalSince1970: 1588279555)
}

struct DiffNotConform: Diffable {
    let not = DateFormatter()
}

struct DiffArr: Diffable {
    var arr: [String] = ["Hello"]
}

struct DiffNullable: Diffable {
    var str: String? = nil
}
