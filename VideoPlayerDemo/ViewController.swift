import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func presentVideoPlayerVC(_ sender: Any) {
        let vc = VideoPlayerViewController()
        self.present(vc, animated: true, completion: nil)
    }
}

