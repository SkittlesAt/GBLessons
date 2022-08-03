//
//  ProfileFriendViewController.swift
//  GeekBrainsLesons
//
//  Created by Vitalii Sukhoroslov on 30.10.2021.
//

import UIKit

class ProfileFriendViewController: UIViewController {
    @IBOutlet weak var friendAvatar: UIImageView!
    @IBOutlet weak var friendCollectionPhoto: UICollectionView!
    @IBOutlet weak var friendName: UILabel!

	lazy var swipeLeftRecognizer: UISwipeGestureRecognizer = {
		let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeToBack))
		recognizer.direction = .right
		return recognizer
	}()

	@objc func swipeToBack() {
		self.navigationController?.popViewController(animated: true)
	}

	private let service = PhotoService()
	var friendId = ""
	var nameFriend = ""
	var avatarFriend = ""
	var infoPhotoFriend: [InfoPhotoFriend] = []

	private var storedImagesM: [String] = []
	private var storedImagesZ: [String] = []
	private let identifier = "PhotoCollectionViewCell"
	private var photos: [UIImage] = []

	// Данные для галлереи

	private let cellsCount: CGFloat = 3.0
	private let cellsOffset: CGFloat = 2.0

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.addGestureRecognizer(swipeLeftRecognizer)
		loadInfoCurrentFriend()

		friendCollectionPhoto.delegate = self
		friendCollectionPhoto.dataSource = self
		fetchPhotos()

		friendCollectionPhoto.register(
			UINib(
				nibName: "PhotoCollectionViewCell",
				bundle: nil),
			forCellWithReuseIdentifier: identifier
		)
	}
}
// MARK: - Table view data source
extension ProfileFriendViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return storedImagesM.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PhotoCollectionViewCell
		else {
			return UICollectionViewCell()
		}
		service.loadImage(url: storedImagesM[indexPath.item]) { image in
			DispatchQueue.main.async {
				self.photos.append(image)
				cell.photoImage.image = image
			}
		}

		return cell
	}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "FullScreenPhotoViewController" ) as? FullScreenPhotoViewController
		else {
            return
        }

        vc.photos = photos
		vc.selectedPhoto = indexPath.item
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Private
private extension ProfileFriendViewController {

	func loadInfoCurrentFriend() {
		friendName.text = nameFriend
		service.loadImage(url: avatarFriend) { [weak self] image in
			guard let self = self else { return }
			DispatchQueue.main.async {
				self.friendAvatar.image = image
			}
		}
	}

	func sortImage(by sizeType: Size.SizeType,
				   from array: [InfoPhotoFriend]) -> [String] {
		var imageLinks: [String] = []
		for model in array {
			for size in model.sizes {
				if size.type == sizeType {
					imageLinks.append(size.url)
				}
			}
		}
		return imageLinks
	}

	func fetchPhotos() {
		service.loadPhoto(idFriend: friendId) { [weak self] model in
			guard let self = self else { return }
			switch model {
			case .success(let photo):
				self.infoPhotoFriend = photo
				let imagesM = self.sortImage(by: .m, from: photo)
				self.storedImagesM = imagesM
				let imagesZ = self.sortImage(by: .z, from: photo)
				self.storedImagesZ = imagesZ
				DispatchQueue.main.async {
					self.friendCollectionPhoto.reloadData()
				}
			case .failure(let error):
				print("\(error)")
			}
		}
	}
}
