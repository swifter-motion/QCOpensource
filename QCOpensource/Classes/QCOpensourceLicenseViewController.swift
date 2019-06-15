//Copyright (c) 2019 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import UIKit
import SafariServices

open class QCOpensourceLicenseViewController: UIViewController {
    private var opensources = [QCOpensource]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        let leadingConstraint = NSLayoutConstraint(item: self.view, attribute: .leading, relatedBy: .equal, toItem: tableView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: tableView, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: self.view, attribute: .top, relatedBy: .equal, toItem: tableView, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        return tableView
    }()
    
    public init(plistPath: String?) {
        super.init(nibName: nil, bundle: nil)
        
        guard let plistPath = plistPath,
            let array = NSArray(contentsOfFile: plistPath) else { return }
        
        let opensources = array.compactMap { element -> QCOpensource? in
            let value = element as? [String: String]
            return QCOpensource(name: value?["name"], license: value?["license"], urlPath: value?["urlPath"])
        }
        
        self.opensources = opensources
    }
    
    public init(opensources: [QCOpensource]) {
        super.init(nibName: nil, bundle: nil)
        
        self.opensources = opensources
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

// MARK: UITableViewDelegate
extension QCOpensourceLicenseViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let opensource = self.opensources[indexPath.row]
        if let urlPath = opensource.urlPath, urlPath != "", let url = URL(string: urlPath) {
            if #available(iOS 9.0, *) {
                let viewController = SFSafariViewController(url: url)
                self.present(viewController, animated: true, completion: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            let viewController = QCOpensourceLicenseDetailViewController(opensource)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: UITableViewDataSource
extension QCOpensourceLicenseViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.opensources.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let item = self.opensources[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = item.name
        return cell
    }
}




