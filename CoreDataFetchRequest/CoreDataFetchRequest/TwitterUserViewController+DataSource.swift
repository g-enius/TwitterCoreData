//
//  TwitterUserViewController+NSFetchedResultsController_DataSource.swift
//  CoreDataFetchRequest
//
//  Created by Charles on 14/05/17.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit
import CoreData

extension TwitterUserViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController?.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultController?.sections, sections.count > 0 {
            return sections[section].name
        } else {
            return nil
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultController?.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
    
}
