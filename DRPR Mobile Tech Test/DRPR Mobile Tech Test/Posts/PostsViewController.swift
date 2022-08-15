//
//  PostsViewController.swift
//  DRPR Mobile Tech Test
//
//  Created by Daniel Pulgarin R. on 13/08/22.
//

import UIKit

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var removeAllPostsButton: UIButton!
    
    
    var post: Post? = Post()

    var bodies: [ChoosenPost]?

    var selectedPostId = 0
    var selectedPostData: ChoosenPost?

    var reloadButton = UIBarButtonItem()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Personalization
        setPersonalization()
        
        // MARK: Load Posts
        getPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
    }
    
    
    // MARK: - Style
    func setPersonalization() {
        
        // MARK: Nav Bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Posts"
        reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapReloadButton))
        navigationItem.rightBarButtonItems = [reloadButton]

        // MARK: Table View
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        
        // MARK: Button
        removeAllPostsButton.setTitle("Remove all posts", for: .normal)
        removeAllPostsButton.backgroundColor = .red
        removeAllPostsButton.tintColor = .white
        removeAllPostsButton.layer.cornerRadius = 20.0
        removeAllPostsButton.layer.masksToBounds = true
    }
    
    
    // MARK: - NavBar Buttons
    @objc func didTapReloadButton(sender: AnyObject){
        getPosts()
    }
    
    
    // MARK: - Remove All Posts
    @IBAction func removeAllPostsButton(_ sender: Any) {
        deleteAllPosts()
    }
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortByFavorites()
        return bodies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = bodies?[indexPath.row]
        selectedPostId = post?.id ?? 0
        selectedPostData = post
        performSegue(withIdentifier: "goToPostDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        cell.postTitleLabel.text = bodies?[indexPath.row].title
        if favoritePosts[bodies?[indexPath.row].id ?? 0] == true {
            cell.favoriteButtonHeightConstraint.constant = 30.0
            cell.favoriteButton.setImage(UIImage(named: "star.filled"), for: .normal)
            cell.favoriteButton.isHidden = false
        }
        else {
            cell.favoriteButtonHeightConstraint.constant = 0.0
            cell.favoriteButton.setImage(nil, for: .normal)
            cell.favoriteButton.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(45.0)
    }

    // MARK: - Get posts from JSONAPI
    func getPosts() {
        JSONAPI.getPosts { (posts, error) in
            if let error = error {
                print(error)
            } else {
                if let posts = posts {
                    self.bodies = posts.map { ChoosenPost(userId: $0.userId, id: $0.id, title: $0.title, body: $0.body) }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else if let error = error {
                    print(error)
                }
            }
        }
    }


    // MARK: - Delete all posts
    func deleteAllPosts() {
        bodies = [ChoosenPost]()
        tableView.reloadData()
    }

    
    // MARK: - Sort by favorites at top
    func sortByFavorites() {
        bodies = bodies?.sorted { (post1, post2) -> Bool in
            return favoritePosts[post1.id] ?? false
        }
    }
    
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPostDetail" {
            let segueDestination = segue.destination as! PostDetailViewController
            segueDestination.postIdToShow = selectedPostId
            segueDestination.postData = selectedPostData
        }
    }
    
    @IBAction func unwindToPostsFromDetail (_ sender: UIStoryboardSegue) {
        bodies?.removeAll(where: { $0.id == selectedPostId })
    }
}
