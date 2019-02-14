//
//  Adapter.swift
//  FlexAdapter
//
//  Created by Алексей Папин on 11/02/2019.
//  Copyright © 2019 Artec. All rights reserved.
//

import UIKit

protocol TypeProtocol {
    var sectionId: String { get }
    var rowId: String { get }
    var row: RowProtocol { get }
}

protocol CellRegistrator {
    func registerIfNeeded(cellNib: UINib, for cellId: String)
}

class Adapter: NSObject {
    weak var tableView: UITableView!
    var sections: [Section] = []
    var selectDelegate: ((TypeProtocol) -> Void)?
    private var registeredCellIds: Set<String> = []
    var rows: [RowProtocol] {
        return self.sections.compactMap({ $0.rows }).reduce([], +)
    }
    
    public var lastSectionIndex: Int {
        return self.sections.count > 0 ? self.sections.count - 1 : 0
    }
    
    public var lastElementIndexPath: IndexPath {
        return IndexPath(row: self.sections[self.lastSectionIndex].lastRowIndex, section: self.lastSectionIndex)
    }
    
    init(_ tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func item(at indexPath: IndexPath) -> TypeProtocol {
        return self.sections[indexPath.section].rows[indexPath.row].item
    }
    
    enum Update {
        case insertSection(Section, Int)
        case updateSection(Section, Int)
        case deleteSection(Int)
        case insertRows([RowProtocol], [IndexPath])
        case updateRows([RowProtocol], [IndexPath])
        case deleteRows([Int], [Range<Int>])
    }
    
    public func handle(_ update: Update, with animation: UITableView.RowAnimation = .automatic) {
        self.tableView.beginUpdates()
        switch update {
        case .insertSection(let section, let index):
            self.sections.insert(section, at: index)
            self.tableView.insertSections(IndexSet(integer: index), with: animation)
        case .updateSection(let section, let index):
            self.sections[index] = section
            self.tableView.reloadSections(IndexSet(integer: index), with: animation)
        case .deleteSection(let index):
            self.sections.remove(at: index)
            self.tableView.deleteSections(IndexSet(integer: index), with: animation)
            
        case .insertRows(let rows, let indexPaths):
            for i in 0..<rows.count {
                self.sections[indexPaths[i].section].rows.insert(rows[i], at: indexPaths[i].row)
                self.registerIfNeeded(cellNib: rows[i].cellNib, for: rows[i].cellId)
            }
            self.tableView.insertRows(at: indexPaths, with: animation)
        case .updateRows(let rows, let indexPaths):
            for i in 0..<rows.count {
                self.sections[indexPaths[i].section].rows[i] = rows[i]
            }
            self.tableView.reloadRows(at: indexPaths, with: animation)
        case .deleteRows(let sectionIndexes, let rowsRanges):
            var indexPaths = [IndexPath]()
            for i in sectionIndexes {
                self.sections[i].rows.removeSubrange(rowsRanges[i])
                for j in rowsRanges[i] {
                    indexPaths.append(IndexPath(row: j, section: i))
                }
            }
            self.tableView.deleteRows(at: indexPaths, with: animation)
        }
        self.tableView.endUpdates()
    }    
}

extension Adapter: CellRegistrator {
    private func isRegistered(cellId: String) -> Bool {
        return self.registeredCellIds.contains(cellId)
    }
    
    public func registerIfNeeded(cellNib: UINib, for cellId: String) {
        if !isRegistered(cellId: cellId) {
            self.tableView.register(cellNib, forCellReuseIdentifier: cellId)
            self.registeredCellIds.insert(cellId)
        }
    }
}

extension Adapter: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.sections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.cellId, for: indexPath)
        row.configure(cell: cell)
        return cell
    }
}

extension Adapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sections[section].headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = self.item(at: indexPath).row
        return row.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectDelegate?(item(at: indexPath))
    }
}
