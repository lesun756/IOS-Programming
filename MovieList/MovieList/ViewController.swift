//
//  ViewController.swift
//  MovieList
//
//  Created by 杨丽婧 on 2020/2/27.
//  Copyright © 2020 Le Sun. All rights reserved.
//
//  Please noted that 杨丽婧 is my roommate
//  I borrowed her MAC to do the homework

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // master view
    @IBOutlet weak var tableView: UITableView!
    
    // url to get popular movies
    final let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=efaabbc14c4434092885808f997cd291")
    
    private var results: MovieResults?
    private var movies: [MovieInfo] = []
    private var posters:[Int:UIImage] = [Int:UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //download popular movies
        downloadJson {
            print("json download successful")
            self.tableView.reloadData()
        }
        
        // change the navigation bar title
        navigationItem.title = "Popular Movies"
        
        
    }
    
    func downloadJson(completed: @escaping() -> ()) {
        guard let downloadURL = url else { return }
        
        URLSession.shared.dataTask(with: downloadURL) { ( data, urlResponse, error) in
            guard let data = data, error == nil, urlResponse != nil else {
                print("something is wrong")
                return
            }
            print("data downloaded")
            do
            {
                let decoder = JSONDecoder()
                
                // save MovieResults to results, and get the movie list to movies
                self.results = try decoder.decode(MovieResults.self, from: data)
                self.movies = self.results!.movies
                
                DispatchQueue.main.async {
                    completed()
                    self.tableView.reloadData()
                }
                
            } catch {
                print("something wrong for data")
            }
        }.resume()
    }
    
    // helper function for downloading image
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? MovieCell else {
            return UITableViewCell()
        }
        
        //update movie title for each row
        cell.titleLabel.text = movies[indexPath.row].title
        
        // download poster image from poster path
        if let url = URL(string: "https://image.tmdb.org/t/p/w185/\(movies[indexPath.row].posterPath!)") {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    
                    //update poster image for cell
                    cell.posterImageView.image = UIImage(data: data)
                    self.posters[self.movies[indexPath.row].id!] = UIImage(data: data)
                }
            }
        }
        else {
            print("something wrong for poster")
        }
        
        return cell
    }
    
    // turn on edit
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // implement swipe to delete a movie
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            movies.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // load detail view after selecting the row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // vc is the detailViewController
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        let id = movies[indexPath.row].id!
        
        // pass the current movieInfo & poster to detail view
        vc?.movie = movies[indexPath.row]
        vc?.posterimg = self.posters[id]

        // push detail view
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
}

