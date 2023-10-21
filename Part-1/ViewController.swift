import UIKit

class SomeViewController: UIViewController {
    @IBOutlet private weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private var detailViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var detailView: UIView!
    
    private var detailVC: UIViewController?
    private var dataArray: [String]? // Mostly go with proper data type
    
    private let customCell = "someCell"
    private let url = "https://someurl.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
    }
    
    // MARK: - Network Request
    
    func fetchData() {
        guard let url = URL(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if let data = data {
                self?.dataArray = self?.parseData(data) ?? [] // Implement parseData function
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } else {
                // Handle the error
            }
        }
        task.resume()
    }
    
    
    @IBAction func closeShowDetails() {
        detailViewWidthConstraint.constant = 0
        animateViewWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            self.detailVC?.removeFromParent()
        }
    }
    
    @IBAction func showDetail() {
        detailViewWidthConstraint.constant = 100
        animateViewWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            self.view.addSubview(self.detailView)
        }
    }
}

// MARK: - Private functions
private extension SomeViewController {
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: customCell,
                                      bundle: nil),
                                forCellWithReuseIdentifier: customCell)
        fetchData()
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("Done", comment: ""),
            style: .plain,
            target: self,
            action: #selector(dismissController)
        )
    }
    
    private func parseData(_ data: Data) -> [String] {
        // Do necessary logic
        var dataMall: [String] = []
        
        return dataMall
    }
    
    // MARK: - User Actions
    
    @objc func dismissController() {
        // Dismiss the view controller
    }
    
    func animateViewWithDuration(_ duration: TimeInterval, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: duration, 
                       animations: animations,
                       completion: completion)
    }
}

// MARK: - UICollectionViewDataSource

extension SomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Create and return a custom cell
        return collectionView.dequeueReusableCell(withReuseIdentifier: customCell,
                                                  for: indexPath)
    }
}

// MARK: - UICollectionViewDelegate

extension SomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDetail()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widthMultiplier: CGFloat = 0.2929
        if Helper.isIPhone() {
            widthMultiplier = 0.9
        }
        return CGSize(width: view.frame.width * widthMultiplier, height: 150.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let frameWidth = (view.frame.width * 0.2929 * 3) + 84
        var minSpacing: CGFloat = (view.frame.width - frameWidth) / 2
        if Helper.isIPhone() {
            minSpacing = 24
        }
        return minSpacing
    }
}

class Helper {
    static func isIPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}
