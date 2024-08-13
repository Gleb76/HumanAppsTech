//
//  ViewController.swift
//  HumanApps_Tech
//
//  Created by Глеб Клыга on 12.08.24.
//

import UIKit
import Combine

class MainViewController: UIViewController {

    // MARK: - Properties
    
    private let imageView: UIImageView = UIComponentFactory.createImageView()
    private let filterSegmentedControl: UISegmentedControl = UIComponentFactory.createSegmentedControl(items: ["Original", "B&W"])
    private let addButton: UIButton = UIComponentFactory.createButton(title: "+", fontSize: 50)
    private let saveButton: UIButton = UIComponentFactory.createButton(title: "Save", fontSize: 24)

    private let viewModel = PhotoViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    // Gesture recognizers
    private var panGesture: UIPanGestureRecognizer!
    private var pinchGesture: UIPinchGestureRecognizer!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        setupGestures()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        setupImageView()
        setupFilterSegmentedControl()
        setupAddButton()
        setupSaveButton()
    }
    
    private func setupAddButton() {
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 100),
            addButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        addButton.addTarget(self, action: #selector(openPhotoGallery), for: .touchUpInside)
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    private func setupFilterSegmentedControl() {
        view.addSubview(filterSegmentedControl)
        
        NSLayoutConstraint.activate([
            filterSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            filterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        filterSegmentedControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
    }
    
    private func setupSaveButton() {
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.widthAnchor.constraint(equalToConstant: 60),
            saveButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        saveButton.addTarget(self, action: #selector(saveImageToGallery), for: .touchUpInside)
    }


    
    private func bindViewModel() {
        viewModel.$currentPhoto
            .receive(on: RunLoop.main)
            .sink { [weak self] image in
                guard let self = self else { return }
                self.updateImageView()
            }
            .store(in: &cancellables)
    }
    
    private func updateImageView() {
        guard let originalImage = viewModel.currentPhoto else { return }
        let filteredImage = applyFilter(to: originalImage)
        imageView.image = filteredImage
        
        let imageAspectRatio = filteredImage.size.width / filteredImage.size.height
        
        NSLayoutConstraint.deactivate(imageView.constraints)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1 / imageAspectRatio)
        ])
    }
    
    private func applyFilter(to image: UIImage) -> UIImage {
        guard filterSegmentedControl.selectedSegmentIndex == 1 else {
            return image
        }
        
        let context = CIContext(options: nil)
        if let currentFilter = CIFilter(name: "CIPhotoEffectMono") {
            let beginImage = CIImage(image: image)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            if let output = currentFilter.outputImage, let cgimg = context.createCGImage(output, from: output.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return image
    }
    
    private func setupGestures() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(panGesture)
        
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        imageView.addGestureRecognizer(pinchGesture)
    }
    
    // MARK: - Actions
    
    @objc private func openPhotoGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let view = recognizer.view else { return }
        
        let translation = recognizer.translation(in: view)
        recognizer.setTranslation(.zero, in: view)
        
        let newCenterX = view.center.x + translation.x
        let newCenterY = view.center.y + translation.y
        
        let minX = view.bounds.width / 2
        let maxX = self.view.bounds.width - minX
        let minY = view.bounds.height / 2
        let maxY = self.view.bounds.height - minY
        
        view.center = CGPoint(x: min(max(newCenterX, minX), maxX),
                              y: min(max(newCenterY, minY), maxY))
    }

    
    @objc private func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        guard let view = recognizer.view else { return }
        
        let transform = view.transform
        let scale = recognizer.scale
        let minScale: CGFloat = 1.0
        let maxScale: CGFloat = 4.0

        let newScale = scale * sqrt(transform.a * transform.a + transform.c * transform.c)

        if newScale > maxScale {
            view.transform = transform.scaledBy(x: maxScale / newScale, y: maxScale / newScale)
        } else if newScale < minScale {
            view.transform = transform.scaledBy(x: minScale / newScale, y: minScale / newScale)
        } else {
            view.transform = transform.scaledBy(x: scale, y: scale)
        }

        recognizer.scale = 1.0
    }

    @objc private func filterChanged() {
        updateImageView()
    }
    
    @objc private func saveImageToGallery() {
        guard let imageToSave = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            viewModel.addPhoto(selectedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
