
#import "MgushiShareSheet.h"
#import "ExternalShare.h"

@implementation MgushiShareSheetGroup

- (void)addButtonWithTitle:(NSString *)title iconImageName:(NSString *)iconImageName
{
    if (self.titles == nil) {
        self.titles = [[NSMutableArray alloc] initWithObjects:title, nil];
        self.icons = [[NSMutableArray alloc] initWithObjects:iconImageName, nil];
    } else {
        [self.titles addObject:title];
        [self.icons addObject:iconImageName];
    }
}

- (UIView*)drawToView;
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    for (int i = 0; i < [self.titles count]; i ++) {
        NSString *title = [self.titles objectAtIndex:i];
        NSString *iconImageName = [self.icons objectAtIndex:i];
        
        float x = (i % 4) * 75.0;
        float y = floor(i / 4.0) * 90.0;
        
        UIButton *button = [UIButton buttonWithFrame:CGRectMake(x, y, 60.0, 60.0) imageName:iconImageName];
        button.tag = i;
        [button addTouchUpInsideTarget:self action:@selector(buttonTouched:)];
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11.5];
        CGSize titleSize = [title sizeWithFont:font constrainedToSize:CGSizeMake(60, 48)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x + (60 - titleSize.width) / 2, y + 65.0f, titleSize.width, titleSize.height)];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.font = font;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.shadowOffset = CGSizeMake(0, -1.0);
        label.shadowColor = [UIColor blackColor];
        
        [view addSubview:button];
        [view addSubview:label];
        
        [view setSizeHeight:y + 90.0];
    }
    
    [view setSizeWidth:300];
    return view;
}

- (void)buttonTouched:(UIButton*)button
{
    [self.delegate shareSheetGroupDidTouch:self atIdnexPath:[NSIndexPath indexPathForRow:button.tag inSection:self.index]];
}

@end

@implementation MgushiShareSheet

- (id)initWithObject:(id)object otherButtonNames:(NSString *)otherButtonNames, ... NS_REQUIRES_NIL_TERMINATION;
{
    self = [self init];
    if (self) {
        _object = object;
        
        // 默认
        [self addButtonWithTitle:@"新浪微博" iconImageName:@"share-weibo" atGroup:0];
        [self addButtonWithTitle:@"微信好友" iconImageName:@"share-weixin" atGroup:0];
        [self addButtonWithTitle:@"朋友圈" iconImageName:@"share-weixin-group" atGroup:0];
        //            [self addButtonWithTitle:@"腾讯微博" iconImageName:@"share-ttweibo" atGroup:0];
        [self addButtonWithTitle:@"QQ好友" iconImageName:@"share-qq" atGroup:0];
        [self addButtonWithTitle:@"QQ空间" iconImageName:@"share-qzone" atGroup:0];
        
        // 取得名称列表
        NSMutableArray* arrays = [NSMutableArray array];
        va_list argList;
        if (otherButtonNames) {
            [arrays addObject:otherButtonNames];
            va_start(argList, otherButtonNames);
            id arg;
            while ((arg = va_arg(argList, id))) {
                [arrays addObject:arg];
            }
        }
        
        // 遍历所有名称
        for (NSString *name in arrays) {
            if ([name isEqualToString:@"Comment"]) {
                [self addButtonWithTitle:@"评论" iconImageName:@"share-comment" atGroup:1];
            } else if ([name isEqualToString:@"Delete"]) {
                [self addButtonWithTitle:@"删除" iconImageName:@"share-delete" atGroup:1];
            } else if ([name isEqualToString:@"Report"]) {
                [self addButtonWithTitle:@"举报" iconImageName:@"share-report" atGroup:1];
            }
        }
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.groups = [NSMutableArray array];
    }
    
    return self;
}

- (void)addTarget:(id)target action:(SEL)action;
{
    _target = target;
    _action = action;
}

- (void)addButtonWithTitle:(NSString*)title iconImageName:(NSString*)iconImageName atGroup:(NSUInteger)groupIndex;
{
    MgushiShareSheetGroup *group;
    if (groupIndex < self.groups.count) {
        group = [self.groups objectAtIndex:groupIndex];
    }
    
    if (group == nil) {
        group = [[MgushiShareSheetGroup alloc] init];
        group.index = groupIndex;
        group.delegate = self;
        [self.groups addObject:group];
    }
    
    [group addButtonWithTitle:title iconImageName:iconImageName];
}

- (void)setup
{
    self.backgroundColor = RGBA(0, 0, 0, 0.7);
    self.frame = [UIView frameForStateBar];
    self.userInteractionEnabled = YES;
    
    UIImageView *wrap = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 0)];
    wrap.userInteractionEnabled = YES;
    wrap.image = [[UIImage imageNamed:@"share-bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self addSubview:wrap];
    
    UILabel *titleLabel = [UILabel initWithFrame:CGRectMake(0, 8.0f, 320, 18) font:FONTBLOD(14.0) color:
                           [UIColor whiteColor] aligment:NSTextAlignmentCenter];
    titleLabel.text = @"分享到";
    titleLabel.shadowOffset = CGSizeMake(0, -1.0);
    titleLabel.shadowColor = [UIColor blackColor];
    [wrap addSubview:titleLabel];
    
    CGPoint startOrigin = CGPointMake(23.0f, titleLabel.getBottomY + 8.0f);
    for (uint i = 0; i < self.groups.count; i ++) {
        MgushiShareSheetGroup *group = [self.groups objectAtIndex:i];
        UIView *groupView = [group drawToView];
        [groupView setOrigin:startOrigin];
        [wrap addSubview:groupView];
        
        startOrigin.y += groupView.getSizeHeight + 5.0f;
        
        if (i != self.groups.count - 1) {
            // 分割线
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.0, startOrigin.y - 10.0f, 290.0f, 1.0f)];
            line.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"share-line"]];;
            [wrap addSubview:line];
        }
    }
    
    UIButton *button = [UIButton initWithFrame:CGRectMake(24, startOrigin.y - 2.0, 278, 40) title:@"取消" fontSize:13 color:RGB(49, 49, 49)];
    [button addTouchUpInsideTarget:self action:@selector(cancelButtonTouched:)];
    button.tag = -1;
    
    [wrap addSubview:button];
    
    [wrap setSizeHeight:button.getBottomY + 10.0f];
    [wrap setOriginY:self.getSizeHeight];
    _wrap = wrap;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 先取消
    [self cancelButtonTouched:nil];
}

- (void)animationShow
{
    [UIView beginAnimations:nil context:nil];
    
    [_wrap setOriginY:self.getSizeHeight - _wrap.getSizeHeight];
    
    [UIView commitAnimations];
}

- (void)cancelButtonTouched:(UIButton*)button
{
    [UIView animateWithDuration:0.2f animations:^{
        [_wrap setOriginY:self.getSizeHeight];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showInWindow;
{
    [self setup];
    [self animationShow];
}

- (void)processShareAtIndex:(NSUInteger)index
{
    ExternalShareType type = ExternalShareTypeQQ;
    if (index == 0) {
        type = ExternalShareTypeWeibo;
    } else if (index == 1) {
        type = ExternalShareTypeWeixin;
    } else if (index == 2) {
        type = ExternalShareTypeWeixinGroup;
//    } else if (index == 3) {
//        type = ExternalShareTypeTWeibo;
    } else if (index == 3) {
        type = ExternalShareTypeQQ;
    } else if (index == 4) {
        type = ExternalShareTypeQZone;
    }
    
    [[ExternalShare instance] shareType:type withObject:_object];
}

#pragma mark - MgushiShareSheetGroupDelegate
/**
 *  选中其中一项
 *
 *  @param group     MgushiShareSheetGroup
 *  @param indexPath 所在的位置
 */
- (void)shareSheetGroupDidTouch:(MgushiShareSheetGroup*)group atIdnexPath:(NSIndexPath*)indexPath;
{
    // 先取消
    [self cancelButtonTouched:nil];
    
    // 第一组内部处理
    if (indexPath.section == 0) {
        [self processShareAtIndex:indexPath.row];
        return;
    }
    
    // 第二组外部处理
    if (_target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_action withObject:self withObject:indexPath];
#pragma clang diagnostic pop
    }
}

@end
