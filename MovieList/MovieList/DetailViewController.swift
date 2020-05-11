//
//  DetailViewController.swift
//  MovieList
//
//  Created by 杨丽婧 on 2020/2/27.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var link: String? = ""
    var imgLink: String? = ""
    
    // download movieDetail & images with the corresponding new movieInfo passed by master view
    var movie: MovieInfo? {
        didSet {
            let id = movie?.id
            
            // url for GET details by movie id
            link = "https://api.themoviedb.org/3/movie/\(id!)?api_key=efaabbc14c4434092885808f997cd291"
            
            // url for GET images by movie id
            imgLink = "https://api.themoviedb.org/3/movie/\(id!)/images?api_key=efaabbc14c4434092885808f997cd291"
            
            downloadJsonDetails {
                self.collectionView.reloadData()
            }
            
            downloadJsonImages {
                self.collectionView.reloadData()
            
            }
        }
    }
    var movieDetail: MovieDetails?
    var posterimg: UIImage?
    var images_list: [UIImage?] = []
    
    @IBOutlet weak var testImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set poster image
        self.testImageView.image = self.posterimg
        
        // customize the progressView
        self.progressView.transform = progressView.transform.scaledBy(x: 1, y: 4)

    }
    
    // download movie details
    func downloadJsonDetails(completed: @escaping() -> ()) {
        
        guard let downloadURL = URL(string: self.link!) else { return }
        
        //print(downloadURL)
            
        URLSession.shared.dataTask(with: downloadURL) { ( data, urlResponse, error) in
                guard let data = data, error == nil, urlResponse != nil else {
                    print("something is wrong")
                    return
                }
                
                do
                {
                    let decoder = JSONDecoder()
                    let movieDetail = try decoder.decode(MovieDetails.self, from: data)
                    self.movieDetail = movieDetail
                    
                    DispatchQueue.main.async {
                        completed()
                        self.titleLabel.text = movieDetail.title!
                        self.rateLabel.text = "\(10*movieDetail.vote!)% liked"
                        self.descriptionTextView.text = movieDetail.overview!
                        self.dateLabel.text = "Release on \(movieDetail.releaseDate!)"
                        
                        // update progressView to show the rating
                        self.progressView.progress = Float(movieDetail.vote! / 10)
                        
                    }
                    
                } catch {
                    print("something wrong for detail data")
                }
            }.resume()
        
        
    }
    
    // helper function for downloading images
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // download images
    func downloadJsonImages(completed: @escaping() -> ()) {
        guard let downloadURL = URL(string: self.imgLink!) else { return }
        
        URLSession.shared.dataTask(with: downloadURL) { ( data, urlResponse, error) in
            guard let data = data, error == nil, urlResponse != nil else {
                print("something is wrong")
                return
            }
            
            do
            {
                let decoder = JSONDecoder()
                let movieImages = try decoder.decode(MovieImages.self, from: data)
                
                // download 2 backdrop images by backdrop path
                for count in 0...1 {
                    if let imageURL = URL(string: "https://image.tmdb.org/t/p/w185/\(movieImages.backdrops[count].filePath!)") {
                        self.getData(from: imageURL) { data, response, error in
                            guard let data = data, error == nil else { return }
                            
                            // save the image into the image list
                            let temp = UIImage(data: data)
                            self.images_list.append(temp)

                            DispatchQueue.main.async {
                                completed()
                                
                            }
                        }
                    }
                    else {
                        print("something wrong for poster")
                    }
                }
                
                // download 2 poster images by poster path
                for count in 0...1 {
                    if let imageURL = URL(string: "https://image.tmdb.org/t/p/w185/\(movieImages.posters[count].filePath!)") {
                        self.getData(from: imageURL) { data, response, error in
                            guard let data = data, error == nil else { return }
                            
                            // save the image into the image list
                            let temp = UIImage(data: data)
                            self.images_list.append(temp)

                            DispatchQueue.main.async {
                                completed()
                                
                            }
                        }
                    }
                    else {
                        print("something wrong for poster")
                    }
                }
                DispatchQueue.main.async {
                    completed()
                }
                
            } catch {
                print("something wrong for detail data")
            }
        }.resume()
    }
    
    // show # of images in the image list, which is 4
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images_list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as? DetailCell else {
            return UICollectionViewCell()
        }
        
        // update image view in the DetailCell
        cell.imgView.image = images_list[indexPath.row]
        
        
        return cell
    }
    
    
    
}
