//
//  PagingView.swift
//  Pages
//
//  Created by Nacho Navarro on 01/11/2019.
//  Copyright © 2019 nachonavarro. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SwiftUI

/// A paging view that generates pages dynamically based on some user-defined data.
@available(iOS 13.0, OSX 10.15, *)
public struct DPages<Data, Content>: View where Data: RandomAccessCollection, Content: View, Data.Element: Identifiable {

    @ObservedObject private var pg: PageGeometry

    var items: [Data.Element]
    private var template: (Int, Data.Element) -> Content

    /**
     Creates the paging view that generates pages dynamically based on some user-defined data.

     `DPages` can be used as follows:
        ```
            struct Car: Identifiable {
                var id = UUID()
                var model: String
            }

            struct CarsView: View {
                let cars = [Car(model: "Ford"), Car(model: "Ferrari")

                var body: some View {
                    DPages(self.cars) { i, car in
                        Text("Car is \(car.model)!")
                    }
                }
            }
        ```

        - Parameters:
            - items: The collection of data that will drive page creation.
            - template: A function that specifies how a page looks like given the position of the page and the item related to the page.
        - Note: Each item in `items` has to conform to the `Identifiable` protocol.
     */
    public init(_ items: Data, template: @escaping (Int, Data.Element) -> Content) {
        self.items = items.map { $0 }
        self.template = template
        self.pg = PageGeometry(numPages: self.items.count)
    }

    public var body: some View {
        GeometryReader { geometry in
            Pages(numPages: self.items.count) {
                HStack(spacing: 0) {
                    ForEach(0..<self.items.count) { i in
                        self.template(i, self.items[i])
                            .frame(width: geometry.size.width)
                    }
                }
            }
        }
    }

}