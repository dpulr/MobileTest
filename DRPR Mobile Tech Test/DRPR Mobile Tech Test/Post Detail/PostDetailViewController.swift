//
//  PostDetailViewController.swift
//  DRPR Mobile Tech Test
//
//  Created by Daniel Pulgarin R. on 13/08/22.
//

import UIKit

class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var titleContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var postIdToShow = 0
    var postData: ChoosenPost?
    
    var comments: [PostCommentsData]?
    var userInfo: UserData?

    var favoriteButton = UIBarButtonItem()
    var deleteButton = UIBarButtonItem()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Personalization
        setPersonalization()

        // MARK: Load Comments
        getComments()
        getUserInfo()
    }
    
    
    // MARK: - Style
    func setPersonalization() {
        
        // MARK: Nav Bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Post Detail"
        postTitleLabel.text = postData?.title
        favoriteButton = UIBarButtonItem(image: UIImage(named: "star"), style: .plain, target: self, action: #selector(didTapFavoriteButton))
        deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDeleteButton))
        navigationItem.rightBarButtonItems = [deleteButton, favoriteButton]

        // MARK: View
        titleContainerView.addBottomBorder(color: .lightGray, borderLineSize: 2.0)
        
        // MARK: Table View
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PostDescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionCell")
        tableView.register(UINib(nibName: "PostDetailTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "PostUserInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "UserInfoCell")
        tableView.register(UINib(nibName: "PostCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        
        // MARK: Load Favorite
        favoriteButton.image = favoritePosts[postIdToShow] ?? false ? UIImage(named: "star.filled") : UIImage(named: "star")
    }

    
    // MARK: - NavBar Buttons
    @objc func didTapFavoriteButton(sender: AnyObject){
        favoritePosts[postIdToShow] = !(favoritePosts[postIdToShow] ?? false)
        favoriteButton.image = favoritePosts[postIdToShow] ?? false ? UIImage(named: "star.filled") : UIImage(named: "star")
    }
    
    @objc func didTapDeleteButton(sender: AnyObject){
        // MARK: Delete Post
        deletePost()
    }
    
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (comments?.count ?? 0) + 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 {
            cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! PostDetailTitleTableViewCell
            configureTitleCell(cell as! PostDetailTitleTableViewCell, indexPath: indexPath)
        }
        else if indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! PostDescriptionTableViewCell
            configureDescriptionCell(cell as! PostDescriptionTableViewCell, indexPath: indexPath)
        }
        else if indexPath.row == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell", for: indexPath) as! PostUserInfoTableViewCell
            configureUserInfoCell(cell as! PostUserInfoTableViewCell, indexPath: indexPath)
        }
        else if indexPath.row > 4 {
            cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! PostCommentTableViewCell
            configureCommentCell(cell as! PostCommentTableViewCell, indexPath: indexPath)
        }

        return cell
    }

    func configureTitleCell(_ cell: PostDetailTitleTableViewCell, indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            cell.titleLabel.text = "Description".uppercased()
        }
        else if indexPath.row == 2 {
            cell.titleLabel.text = "User info".uppercased()
        }
        else if indexPath.row == 4 {
            cell.titleLabel.text = "Comments".uppercased()
        }
    }
    
    func configureDescriptionCell(_ cell: PostDescriptionTableViewCell, indexPath: IndexPath) {
        
        cell.descriptionLabel.text = postData?.body
    }
    
    func configureUserInfoCell(_ cell: PostUserInfoTableViewCell, indexPath: IndexPath) {
        
        let titleAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)]
        let infoAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]
        let nameTitle = NSMutableAttributedString(string: "Name:\n", attributes: titleAttributes)
        let nameInfo = NSMutableAttributedString(string: (userInfo?.name ?? "") + "\n" + "\n", attributes: infoAttributes)
        nameTitle.append(nameInfo)
        let emailTitle = NSMutableAttributedString(string: "Email:\n", attributes: titleAttributes)
        let emailInfo = NSMutableAttributedString(string: (userInfo?.email ?? "") + "\n" + "\n", attributes: infoAttributes)
        nameTitle.append(emailTitle)
        nameTitle.append(emailInfo)
        let phoneTitle = NSMutableAttributedString(string: "Phone:\n", attributes: titleAttributes)
        let phoneInfo = NSMutableAttributedString(string: (userInfo?.phone ?? "") + "\n" + "\n", attributes: infoAttributes)
        nameTitle.append(phoneTitle)
        nameTitle.append(phoneInfo)
        let websiteTitle = NSMutableAttributedString(string: "Website:\n", attributes: titleAttributes)
        let websiteInfo = NSMutableAttributedString(string: (userInfo?.website ?? ""), attributes: infoAttributes)
        nameTitle.append(websiteTitle)
        nameTitle.append(websiteInfo)

        cell.infoLabel.attributedText = nameTitle
    }
    
    func configureCommentCell(_ cell: PostCommentTableViewCell, indexPath: IndexPath) {
        
        cell.emailLabel.text = comments?[indexPath.row - 4].email
        cell.commentLabel.text = comments?[indexPath.row - 4].body
    }
    
    
    // MARK: - Get post comments from JSONAPI
    func getComments() {
        JSONAPI.getPostComments(postIdToShow) { (comments, error) in
            if let error = error {
                print(error)
            } else {
                self.comments = comments
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func getUserInfo() {
        JSONAPI.getUserInfo(postData?.userId ?? 0) { (userInfo, error) in
            if let error = error {
                print(error)
            } else {
                self.userInfo = userInfo
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    // MARK: - Delete Post
    func deletePost() {
        performSegue(withIdentifier: "goBackToPosts", sender: self)
    }
    
}
