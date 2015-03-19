////////////////////////////////////////////////////////////////////////////
//
// Copyright 2014 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

import XCTest
import RealmSwift

let utf8TestString = "值значен™👍☞⎠‱௹♣︎☐▼❒∑⨌⧭иеمرحبا"

class UnicodeTests: TestCase {
    func testUTF8StringContents() {
        let realm = realmWithTestPath()

        realm.write {
            realm.create(StringObject.self, value: [utf8TestString])
            return
        }

        let obj1 = realm.objects(StringObject.self).first!
        XCTAssertEqual(obj1.stringCol, utf8TestString)

        let obj2 = realm.objects(StringObject.self).filter("stringCol == %@", utf8TestString).first!
        XCTAssertEqual(obj1, obj2)
        XCTAssertEqual(obj2.stringCol, utf8TestString)

        XCTAssertEqual(Int(0), realm.objects(StringObject.self).filter("stringCol != %@", utf8TestString).count)
    }

    func testUTF8PropertyWithUTF8StringContents() {
        let realm = realmWithTestPath()
        realm.write {
            realm.create(UTF8Object.self, value: [utf8TestString])
            return
        }

        let obj1 = realm.objects(UTF8Object.self).first!
        XCTAssertEqual(obj1.柱колоéнǢкƱаم👍, utf8TestString, "Storing and retrieving a string with UTF8 content should work")

        // Test fails because of rdar://17735684
        let obj2 = realm.objects(UTF8Object.self).filter("%K == %@", "柱колоéнǢкƱаم👍", utf8TestString).first!
        XCTAssertEqual(obj1, obj2, "Querying a realm searching for a string with UTF8 content should work")
    }
}