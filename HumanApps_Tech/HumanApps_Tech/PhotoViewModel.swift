//
//  PhotoViewModel.swift
//  HumanApps_Tech
//
//  Created by Глеб Клыга on 12.08.24.
//

import Foundation
import UIKit
import Combine

class MainViewModel: ObservableObject {
    @Published var currentPhoto: UIImage? = nil

    private var photos: [PhotoModel] = []

    func addPhoto(_ photo: UIImage) {
        let model = PhotoModel(id: UUID(), imageData: photo.pngData()!)
        photos.append(model)
        currentPhoto = photo
    }
}
