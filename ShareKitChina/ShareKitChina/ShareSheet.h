//

#import <UIKit/UIKit.h>
#import "MgushiActionSheet.h"
#import "ExternalShareObject.h"

@class MgushiShareSheetGroup;
@protocol MgushiShareSheetGroupDelegate <NSObject>
/**
 *  选中其中一项
 *
 *  @param group     MgushiShareSheetGroup
 *  @param indexPath 所在的位置
 */
- (void)shareSheetGroupDidTouch:(MgushiShareSheetGroup*)group atIdnexPath:(NSIndexPath*)indexPath;

@end

@interface MgushiShareSheetGroup : NSObject

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, retain) NSMutableArray *titles;
@property (nonatomic, retain) NSMutableArray *icons;
@property (nonatomic, assign) id<MgushiShareSheetGroupDelegate> delegate;

- (void)addButtonWithTitle:(NSString*)title iconImageName:(NSString*)iconImageName;

@end

/**
 *  分享的ActionSheet
 */
@interface MgushiShareSheet : UIView <MgushiShareSheetGroupDelegate>
{
    BOOL _isDefaultButtons;
    UIImageView *_wrap;
    id _object;
    id _target;
    SEL _action;
}

@property (nonatomic, retain) NSMutableArray *groups;
@property (nonatomic, assign) id holder;

/**
 *  初始化
 *
 *  @param object           内容
 *  @param otherButtonNames 其他按钮名称
 *
 *  @return MgushiShareSheet
 */
- (id)initWithObject:(id<ExternalShareObjectConvert>)object otherButtonNames:(NSString *)otherButtonNames, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  加入返回处理
 *  第一组内部处理; 第二组外部处理
 *
 *  @param target 目标
 *  @param action 处理函数 shareActionSheet:atIndexPath:
 */
- (void)addTarget:(id)target action:(SEL)action;

- (void)addButtonWithTitle:(NSString*)title iconImageName:(NSString*)iconImageName atGroup:(NSUInteger)groupIndex;

/**
 *  在 window 上显示
 */
- (void)showInWindow;

@end
