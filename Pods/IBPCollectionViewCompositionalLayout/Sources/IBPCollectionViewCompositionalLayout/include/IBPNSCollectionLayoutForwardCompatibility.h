#import "IBPNSCollectionLayoutAnchor.h"
#import "IBPNSCollectionLayoutBoundarySupplementaryItem.h"
#import "IBPNSCollectionLayoutContainer_Protocol.h"
#import "IBPNSCollectionLayoutDecorationItem.h"
#import "IBPNSCollectionLayoutDimension.h"
#import "IBPNSCollectionLayoutEdgeSpacing.h"
#import "IBPNSCollectionLayoutEnvironment_Protocol.h"
#import "IBPNSCollectionLayoutGroup.h"
#import "IBPNSCollectionLayoutGroupCustomItem.h"
#import "IBPNSCollectionLayoutItem.h"
#import "IBPNSCollectionLayoutSection.h"
#import "IBPNSCollectionLayoutSize.h"
#import "IBPNSCollectionLayoutSpacing.h"
#import "IBPNSCollectionLayoutSupplementaryItem.h"
#import "IBPNSCollectionLayoutVisibleItem.h"
#import "IBPUICollectionViewCompositionalLayout.h"
#import "IBPUICollectionViewCompositionalLayoutConfiguration.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 130000
@compatibility_alias NSCollectionLayoutAnchor IBPNSCollectionLayoutAnchor;
@compatibility_alias NSCollectionLayoutBoundarySupplementaryItem IBPNSCollectionLayoutBoundarySupplementaryItem;
@compatibility_alias NSCollectionLayoutDecorationItem IBPNSCollectionLayoutDecorationItem;
@compatibility_alias NSCollectionLayoutDimension IBPNSCollectionLayoutDimension;
@compatibility_alias NSCollectionLayoutEdgeSpacing IBPNSCollectionLayoutEdgeSpacing;
@compatibility_alias NSCollectionLayoutGroup IBPNSCollectionLayoutGroup;
@compatibility_alias NSCollectionLayoutGroupCustomItem IBPNSCollectionLayoutGroupCustomItem;
@compatibility_alias NSCollectionLayoutItem IBPNSCollectionLayoutItem;
@compatibility_alias NSCollectionLayoutSection IBPNSCollectionLayoutSection;
@compatibility_alias NSCollectionLayoutSize IBPNSCollectionLayoutSize;
@compatibility_alias NSCollectionLayoutSpacing IBPNSCollectionLayoutSpacing;
@compatibility_alias NSCollectionLayoutSupplementaryItem IBPNSCollectionLayoutSupplementaryItem;
@compatibility_alias UICollectionViewCompositionalLayout IBPUICollectionViewCompositionalLayout;
@compatibility_alias UICollectionViewCompositionalLayoutConfiguration IBPUICollectionViewCompositionalLayoutConfiguration;
@protocol NSCollectionLayoutContainer <IBPNSCollectionLayoutContainer> @end
@protocol NSCollectionLayoutEnvironment <IBPNSCollectionLayoutEnvironment> @end
#endif

#define NSCollectionLayoutAnchor IBPNSCollectionLayoutAnchor
#define NSCollectionLayoutBoundarySupplementaryItem IBPNSCollectionLayoutBoundarySupplementaryItem
#define NSCollectionLayoutDecorationItem IBPNSCollectionLayoutDecorationItem
#define NSCollectionLayoutDimension IBPNSCollectionLayoutDimension
#define NSCollectionLayoutEdgeSpacing IBPNSCollectionLayoutEdgeSpacing
#define NSCollectionLayoutGroup IBPNSCollectionLayoutGroup
#define NSCollectionLayoutGroupCustomItem IBPNSCollectionLayoutGroupCustomItem
#define NSCollectionLayoutItem IBPNSCollectionLayoutItem
#define NSCollectionLayoutSection IBPNSCollectionLayoutSection
#define NSCollectionLayoutSize IBPNSCollectionLayoutSize
#define NSCollectionLayoutSpacing IBPNSCollectionLayoutSpacing
#define NSCollectionLayoutSupplementaryItem IBPNSCollectionLayoutSupplementaryItem
#define UICollectionViewCompositionalLayout IBPUICollectionViewCompositionalLayout
#define UICollectionViewCompositionalLayoutConfiguration IBPUICollectionViewCompositionalLayoutConfiguration

#define NSDirectionalEdgeInsets IBPNSDirectionalEdgeInsets
#define NSDirectionalEdgeInsetsZero IBPNSDirectionalEdgeInsetsZero
#define NSDirectionalEdgeInsetsMake IBPNSDirectionalEdgeInsetsMake
#define NSStringFromDirectionalEdgeInsets IBPNSStringFromDirectionalEdgeInsets

#define NSDirectionalRectEdge IBPNSDirectionalRectEdge
#define NSDirectionalRectEdgeNone IBPNSDirectionalRectEdgeNone
#define NSDirectionalRectEdgeTop IBPNSDirectionalRectEdgeTop
#define NSDirectionalRectEdgeLeading IBPNSDirectionalRectEdgeLeading
#define NSDirectionalRectEdgeBottom IBPNSDirectionalRectEdgeBottom
#define NSDirectionalRectEdgeTrailing IBPNSDirectionalRectEdgeTrailing
#define NSDirectionalRectEdgeAll IBPNSDirectionalRectEdgeAll

#define NSRectAlignment IBPNSRectAlignment
#define NSRectAlignmentNone IBPNSRectAlignmentNone
#define NSRectAlignmentTop IBPNSRectAlignmentTop
#define NSRectAlignmentTopLeading IBPNSRectAlignmentTopLeading
#define NSRectAlignmentLeading IBPNSRectAlignmentLeading
#define NSRectAlignmentBottomLeading IBPNSRectAlignmentBottomLeading
#define NSRectAlignmentBottom IBPNSRectAlignmentBottom
#define NSRectAlignmentBottomTrailing IBPNSRectAlignmentBottomTrailing
#define NSRectAlignmentTrailing IBPNSRectAlignmentTrailing
#define NSRectAlignmentTopTrailing IBPNSRectAlignmentTopTrailing

#define UICollectionLayoutSectionOrthogonalScrollingBehaviorNone IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorNone
#define UICollectionLayoutSectionOrthogonalScrollingBehaviorContinuous IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorContinuous
#define UICollectionLayoutSectionOrthogonalScrollingBehaviorContinuousGroupLeadingBoundary IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorContinuousGroupLeadingBoundary
#define UICollectionLayoutSectionOrthogonalScrollingBehaviorPaging IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorPaging
#define UICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPaging IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPaging
#define UICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPagingCentered IBPUICollectionLayoutSectionOrthogonalScrollingBehaviorGroupPagingCentered
