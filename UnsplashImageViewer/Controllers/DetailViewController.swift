//
//  DetailViewController.swift
//  UnsplashImageViewer
//
//  Created by Nikolas Omelianov on 8/27/19.
//  Copyright © 2019 Nikolas Omelianov. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var instaName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var user: UnsplashUserEntity?
    var image: UIImage?
    var imageView = UIImageView()
    
    override func viewWillAppear(_ animated: Bool) {
         AppUtility.lockOrientation(.portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initials()
        setUpSubviews()
        scrollView?.addSubview(imageView)
        showPoint()
    }
    @objc private func shareObjects(){
        guard let img = image else { return }
        let sharePopUp = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        sharePopUp.completionWithItemsHandler = {_, bool, _, _  in
            if bool {
                print("file sent")
            }
        }
        sharePopUp.popoverPresentationController?.barButtonItem = UIBarButtonItem()
        sharePopUp.popoverPresentationController?.permittedArrowDirections = .any
        present(sharePopUp, animated: true)
    }
    private func setUpSubviews() {
        setUpLabels()
        setUpProfileImage()
        setUpImageView()
        setUpScrollView()
    }
    private func setUpImageView() {
        imageView = UIImageView(frame: scrollView.frame)
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.image = image
    }
    private func setUpScrollView() {
        scrollView.isUserInteractionEnabled = true
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.zoomScale = 1.0
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.center = scrollView.center
    }
    //To return initial size as in apple gallery
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.zoomScale = 1.0
    }
    private func setUpProfileImage() {
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    private func setUpLabels(){
        guard let details = user else { return }
        authorName.text = details.userName
        instaName.text = details.instaName
        instaName.textColor = .blue
        location.text = details.imageInfo?.location
        if let nsdata = details.profileImage {
            let data = Data(referencing: nsdata)
            profileImage.image = UIImage(data: data)
        }
    }
    private func initials(){
        scrollView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareObjects ))
    }
    
    func showPoint() {
        mapView.isHidden = true
        if let searchString = location.text {
//        let searchString = "Sweeden"
//            let firstWord = searchString.components(separatedBy: " ").first
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = searchString
            let activeSearchg = MKLocalSearch(request: searchRequest)
            activeSearchg.start { (response, error) in
                if response == nil {
                    print("error")
                } else {
                    let anotations = self.mapView.annotations
                    self.mapView.removeAnnotations(anotations)
                    
                    let latitude = response?.boundingRegion.center.latitude
                    let longitude = response?.boundingRegion.center.longitude
                    
                    let anotation = MKPointAnnotation()
                    anotation.title = searchString
                    anotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                    self.mapView.addAnnotation(anotation)
                    self.mapView.setCenter(anotation.coordinate, animated: true)
                    self.mapView.isHidden = false
                }
            }
        }
    }
}
