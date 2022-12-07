//
//  ViewController.swift
//  CombineIntro
//
//  Created by Sean Livingston on 12/7/22.
//

import UIKit
import Combine

class MyCustomTableViewCell: UITableViewCell {
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    let action = PassthroughSubject<String, Never>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func didTapButton() {
        action.send("Cool button was tapped.")
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 10, y: 3, width: contentView.frame.size.width-20, height: contentView.frame.size.height-6)
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(MyCustomTableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var models = [String]()
    
    var observers: [AnyCancellable] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
//        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        ApiCaller.shared.fetchCompanies()
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { [weak self] value in
            self?.models = value
            self?.tableView.reloadData()
        }).store(in: &observers)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MyCustomTableViewCell else {
            fatalError()
        }
        cell.action.sink { string in
            print(string)
        }.store(in: &observers)
//        cell.textLabel?.text = models[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
}

