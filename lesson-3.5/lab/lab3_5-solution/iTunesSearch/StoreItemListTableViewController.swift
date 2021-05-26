
import UIKit

class StoreItemListTableViewController: UITableViewController {
            
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.window?.endEditing(true)
    }
}

