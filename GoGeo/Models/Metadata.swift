//
//  Metadata.swift
//  GoGeo
//
//  Created by Виталий Гринчик on 14.03.23.
//

// Metadata: Result metadata (currently only associated with collection results)
struct Metadata: Decodable {
    let currentOffset: Int
    let totalCount: Int
}
