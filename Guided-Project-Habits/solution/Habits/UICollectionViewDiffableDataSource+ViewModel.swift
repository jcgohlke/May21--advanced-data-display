//
// UICollectionViewDiffableDataSource+ViewModel.swift
// Habits
//


import UIKit

extension UICollectionViewDiffableDataSource {
    func applySnapshotUsing(sectionIDs: [SectionIdentifierType], itemsBySection: [SectionIdentifierType: [ItemIdentifierType]], sectionsRetainedIfEmpty: Set<SectionIdentifierType> = Set<SectionIdentifierType>()) {
        applySnapshotUsing(sectionIDs: sectionIDs, itemsBySection: itemsBySection, animatingDifferences: true, sectionsRetainedIfEmpty: sectionsRetainedIfEmpty)
    }

    func applySnapshotUsing(sectionIDs: [SectionIdentifierType], itemsBySection: [SectionIdentifierType: [ItemIdentifierType]], animatingDifferences: Bool, sectionsRetainedIfEmpty: Set<SectionIdentifierType> = Set<SectionIdentifierType>()) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()

        for sectionID in sectionIDs {
            guard let sectionItems = itemsBySection[sectionID],
                sectionItems.count > 0 || sectionsRetainedIfEmpty.contains(sectionID) else { continue }

            snapshot.appendSections([sectionID])
            snapshot.appendItems(sectionItems, toSection: sectionID)
        }

        self.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
