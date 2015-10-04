//
//  KSBlockPickerView.m
//  Angejia
//
//  Created by zhujinhui on 15/10/2.
//  Copyright © 2015年 Plan B Inc. All rights reserved.
//

#import "KSBlockPickerView.h"

#define WIDTH_LEFT_TABLEVIEW 100
#define HEIGHT_TABLEVIEW 200
#define HEIGHT_TOOLBAR 44
#define HEIGHT_TABLEVIEW_ROW 42

#define TAG_LEFT_TABLEVIEW  1009
#define TAG_RIGHT_TABLEVIEW 1010
#define TAG_CLEAR_FILTER    1011
#define TAG_CONFIRM         1012
#define TAG_CANCEL          1013
#define TAG_CELL_ACCESSORYBUTTON    9090
#define TAG_CELL_BADGEVIEW          9091

#define ROW_RIGHTSELECTED @"ROW_RIGHTSELECTED"

#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

static NSString *leftTableViewIdentifier = @"leftTableViewIdentifier";
static NSString *rightTableViewIdentifier = @"rightTableViewIdentifier";

@interface UIView (viewUtils)

@end

@implementation UIView (viewUtils)
//frame accessors

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size{
    return self.frame.size;
}

- (CGFloat)top{
    return self.origin.y;
}

- (void)setTop:(CGFloat)top{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)left{
    return self.origin.x;
}

- (void)setLeft:(CGFloat)left{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right{
    return self.left + self.width;
}

- (void)setRight:(CGFloat)right{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom{
    return self.top + self.height;
}

- (void)setBottom:(CGFloat)bottom{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width{
    return self.size.width;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height{
    return self.size.height;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end


@interface UIColor (hex)
+ (UIColor *) colorWithHex:(uint) hex alpha:(CGFloat)alpha;
@end

@implementation UIColor(hex)

+ (UIColor *) colorWithHex:(uint) hex alpha:(CGFloat)alpha
{
    int red, green, blue;
    
    blue = hex & 0x0000FF;
    green = ((hex & 0x00FF00) >> 8);
    red = ((hex & 0xFF0000) >> 16);
    
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

@end

#pragma mark - KSBlockPickerClearFilterButton
@interface KSBlockPickerClearFilterButton : UIButton

@property (nonatomic, assign) BOOL clearEnable;

+(instancetype) clearFilterButtonWithFrame:(CGRect) frame;

@end

@implementation KSBlockPickerClearFilterButton

+(instancetype) clearFilterButtonWithFrame:(CGRect) frame{
    KSBlockPickerClearFilterButton *button = [KSBlockPickerClearFilterButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:@"清空筛选" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [button addTarget:button action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderColor = [UIColor colorWithHex:0xcccccc alpha:1.f].CGColor;
    button.layer.borderWidth = 1.f;
    button.clearEnable = NO;
    return button;
}

-(void)buttonClicked:(KSBlockPickerClearFilterButton *)sender{
    self.clearEnable = !self.clearEnable;
}

-(void)setClearEnable:(BOOL)clearEnable{
    _clearEnable = clearEnable;
    if (_clearEnable) {
        self.userInteractionEnabled = YES;
        [self setTitleColor:[UIColor colorWithHex:0x007fff alpha:1.f] forState:UIControlStateNormal];
    }else{
        self.userInteractionEnabled = NO;
        [self setTitleColor:[UIColor colorWithHex:0xcccccc alpha:1.f] forState:UIControlStateNormal];
    }
}

@end

#pragma mark - KSBlockPickerCheckButton
@interface KSBlockPickerCheckButton : UIButton

@property (nonatomic, assign) BOOL isSelected;

+(instancetype) checkButtonWithFrame:(CGRect) frame;

@end

@implementation KSBlockPickerCheckButton

+(instancetype) checkButtonWithFrame:(CGRect) frame{
    KSBlockPickerCheckButton *checkButton = [KSBlockPickerCheckButton buttonWithType:UIButtonTypeCustom];
    checkButton.frame = frame;
    checkButton.layer.borderWidth = 1.f;
    checkButton.isSelected = NO;
    [checkButton addTarget:checkButton action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return checkButton;
}


-(void)buttonClicked:(UIButton *) sender{
    _isSelected = !_isSelected;
    [self setIsSelected:_isSelected];
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (_isSelected) {
        UIImage *image = [UIImage imageNamed:@"icon_xuanzhongzhuangtai"];
        self.layer.borderColor = [UIColor clearColor].CGColor;
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }else{
        self.layer.borderColor = [UIColor colorWithHex:0xcccccc alpha:1.f].CGColor;
        [self setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

@end

#pragma mark - KSBlockPickerLeftViewCell
@interface KSBlockPickerLeftViewCell : UITableViewCell
/**
 * if one row in right tableview has been selected ,this property will set to YES.(to sign red point)
 */
@property (nonatomic, assign) BOOL hasDataTableViewCellSelected;

@end

@implementation KSBlockPickerLeftViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = [UIColor colorWithHex:0x8d8c92 alpha:1.f];
        self.textLabel.font = [UIFont systemFontOfSize:15.f];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
        backgroundView.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = backgroundView;
        
        self.backgroundColor = [UIColor colorWithHex:0xeeeeee alpha:1.f];
        
        UIView *badgeView = [[UIView alloc] initWithFrame:CGRectMake(self.textLabel.left, (self.contentView.height - self.textLabel.font.pointSize )/2, 4, 4)];
        badgeView.tag = TAG_CELL_BADGEVIEW;
        badgeView.layer.cornerRadius = 2.f;
        badgeView.backgroundColor = [UIColor redColor];
        [self.textLabel addSubview:badgeView];
        
        self.hasDataTableViewCellSelected = NO;
    }
    return self;
}

-(void)setHasDataTableViewCellSelected:(BOOL)hasDataTableViewCellSelected{
    _hasDataTableViewCellSelected = hasDataTableViewCellSelected;
    UIView *badgeView = [self.contentView viewWithTag:TAG_CELL_BADGEVIEW];
    if (_hasDataTableViewCellSelected) {
        badgeView.hidden = NO;
    }else{
        badgeView.hidden = YES;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    UIView *badgeView = [self.contentView viewWithTag:TAG_CELL_BADGEVIEW];
    badgeView.backgroundColor = [UIColor redColor];
    badgeView.left = self.textLabel.left;
}

@end

#pragma mark - KSBlockPickerRightViewCell
typedef void (^ButtonClickBlock)();

@interface KSBlockPickerRightViewCell : UITableViewCell{
    
}

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) ButtonClickBlock buttonClickedBlock;

@end

@implementation KSBlockPickerRightViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = [UIColor colorWithHex:0x8d8c92 alpha:1.f];
        self.textLabel.font = [UIFont systemFontOfSize:15.f];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        KSBlockPickerCheckButton *accessoryButton = [KSBlockPickerCheckButton checkButtonWithFrame:CGRectMake(0, 0, 20, 20)];
        accessoryButton.tag = TAG_CELL_ACCESSORYBUTTON;
        [accessoryButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.accessoryView = accessoryButton;
    }
    return self;
}

-(void)buttonClicked:(KSBlockPickerCheckButton *) sender{
    self.isSelected = sender.isSelected;
    self.buttonClickedBlock();
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    KSBlockPickerCheckButton *button = (KSBlockPickerCheckButton *) [self viewWithTag:TAG_CELL_ACCESSORYBUTTON];
    button.isSelected = _isSelected;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    KSBlockPickerCheckButton *button = (KSBlockPickerCheckButton *) [self viewWithTag:TAG_CELL_ACCESSORYBUTTON];
    button.isSelected = _isSelected;
}

@end

#pragma mark - PickerCache
@interface PickerCache : NSObject{
    @private
    NSCache *_cache;
}

@property (nonatomic, strong) NSNumber *leftHasDataTableViewCellRowIndex;

@end

@implementation PickerCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
    }
    return self;
}

-(void)clearCache{
    [_cache removeAllObjects];
}

-(void)cacheRightSelectedCell:(KSBlockPickerRightViewCell *)cell atRightIndexPathRow:(NSInteger) rightRow leftIndexPathRow:(NSInteger) leftRow{
    
    if (leftRow != [self.leftHasDataTableViewCellRowIndex integerValue]) {
        [self->_cache removeAllObjects];
    }
    
    NSString *cachedString = [self->_cache objectForKey:ROW_RIGHTSELECTED];
    if (nil == cachedString) {
        cachedString = @"";
    }
    NSMutableString *currentSelectedRowFormattedString = [NSMutableString stringWithFormat:@"%li#",(long)rightRow];
    
    if (cell.isSelected) {
        cachedString = [cachedString stringByAppendingString:currentSelectedRowFormattedString];
    }else{
        if ([cachedString rangeOfString:currentSelectedRowFormattedString].length > 0) {
            cachedString = [cachedString stringByReplacingOccurrencesOfString:currentSelectedRowFormattedString withString:@""];
        }
    }
    [self->_cache setObject:cachedString forKey:ROW_RIGHTSELECTED];
    if (![cachedString isEqualToString:@""]) {
        _leftHasDataTableViewCellRowIndex = [NSNumber numberWithInteger:leftRow];
    }else{
        _leftHasDataTableViewCellRowIndex = nil;
    }
}

-(NSArray *)rightTableViewCellSelectedAtLeftTableViewCellIndex:(NSInteger) leftRow{
    NSMutableArray *allSelectedRow = [[NSMutableArray alloc] init];
    if (leftRow == [self.leftHasDataTableViewCellRowIndex integerValue]) {
        NSString *cachedString2 = [self->_cache objectForKey:ROW_RIGHTSELECTED];
        NSArray *rows = [cachedString2 componentsSeparatedByString:@"#"];
        for (NSString *rowStringItem in rows) {
            if (![rowStringItem isEqualToString:@""]) {
                NSInteger row = [rowStringItem integerValue];
                [allSelectedRow addObject:[NSNumber numberWithInteger:row]];
            }
        }
    }
    return allSelectedRow;
}

-(BOOL)rightTableViewCellIsSelected:(NSInteger)rightRow atLeftTableViewCellIndex:(NSInteger) leftRow{
    BOOL rightIsSelected = NO;
    if ([self.leftHasDataTableViewCellRowIndex isKindOfClass:[NSNumber class]] && leftRow == [self.leftHasDataTableViewCellRowIndex integerValue]) {
        for (NSNumber *rowItem  in [self rightTableViewCellSelectedAtLeftTableViewCellIndex:leftRow]) {
            if ([rowItem integerValue] == rightRow) {
                rightIsSelected = YES;
            }
        }
    }
    return rightIsSelected;
}

@end

#pragma mark - KSBlockPickerView
@interface KSBlockPickerView ()<UITableViewDataSource,UITableViewDelegate>{
    PickerCache *_cache;
}

@property (nonatomic, strong) UITableView *leftTableView;

@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) UIToolbar     *toolbar;

@end

@implementation KSBlockPickerView

-(instancetype)initWithData:(NSArray *)data{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithHex:0x666666 alpha:0.6f];
        _cache = [[PickerCache alloc] init];
        self.data = data;
        
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.height - HEIGHT_TABLEVIEW - HEIGHT_TOOLBAR, self.width, HEIGHT_TOOLBAR)];
        [self addSubview:_toolbar];
        
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"  取消" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked:)];
        item1.tag = TAG_CANCEL;
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"确定  " style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked:)];
        item2.tag = TAG_CONFIRM;
        _toolbar.items = @[item1,space,item2];
        
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.height - HEIGHT_TABLEVIEW, WIDTH_LEFT_TABLEVIEW, HEIGHT_TABLEVIEW)];
        _leftTableView.tag = TAG_LEFT_TABLEVIEW;
        _leftTableView.rowHeight = HEIGHT_TABLEVIEW_ROW;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH_LEFT_TABLEVIEW, self.height - HEIGHT_TABLEVIEW, self.width - WIDTH_LEFT_TABLEVIEW, HEIGHT_TABLEVIEW)];
        _rightTableView.tag = TAG_RIGHT_TABLEVIEW;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.rowHeight = HEIGHT_TABLEVIEW_ROW;
        _rightTableView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        [self addSubview:_leftTableView];
        [self addSubview:_rightTableView];
        
        KSBlockPickerClearFilterButton *button = [KSBlockPickerClearFilterButton clearFilterButtonWithFrame:CGRectMake(0, 0, 100, 30)];
        button.center = self.center;
        button.top = _toolbar.top + (HEIGHT_TOOLBAR - button.height)/2;
        button.tag = TAG_CLEAR_FILTER;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (nil != self.data) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [_leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
    }
    return self;
}


-(void)buttonClicked:(id) sender{
    switch ([sender tag]) {
        case TAG_CANCEL:{
            [self removeFromSuperview];
        }
            break;
        case TAG_CONFIRM:{
            if (self.delegate && [self.delegate respondsToSelector:@selector(blockPickerView:leftRowSelected:rightRowsSelected:)]) {
                [self.delegate blockPickerView:self leftRowSelected:_cache.leftHasDataTableViewCellRowIndex rightRowsSelected:[_cache rightTableViewCellSelectedAtLeftTableViewCellIndex:[_cache.leftHasDataTableViewCellRowIndex integerValue]]];
            }
        }
            break;
        case TAG_CLEAR_FILTER:{
            [_cache clearCache];
            [_rightTableView reloadData];
            [_leftTableView reloadData];
            _cache.leftHasDataTableViewCellRowIndex = nil;
            
            if (nil != self.data && self.data.count > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [_leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            }
        }
            break;
            
        default:
            break;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case TAG_LEFT_TABLEVIEW:{
            return self.data.count;
        }
            break;
        case TAG_RIGHT_TABLEVIEW:{
            NSIndexPath *indexPath = _leftTableView.indexPathForSelectedRow;
            NSDictionary *districts = self.data[indexPath.row];
            NSArray *blocks = [districts allValues].firstObject;
            return blocks.count;
        }
            break;
        default:
            break;
    }
    return 0;
}

//缩进
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case TAG_LEFT_TABLEVIEW:{
            KSBlockPickerLeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftTableViewIdentifier];
            if (cell == nil) {
                cell = [[KSBlockPickerLeftViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftTableViewIdentifier];
            }
            if ([_cache.leftHasDataTableViewCellRowIndex isKindOfClass:[NSNumber class]] && indexPath.row == [_cache.leftHasDataTableViewCellRowIndex integerValue]) {
                cell.hasDataTableViewCellSelected = YES;
            }else {
                cell.hasDataTableViewCellSelected = NO;
            }
            
            NSDictionary *districts = self.data[indexPath.row];
            
            cell.textLabel.text = [districts allKeys].firstObject;
            return cell;
        }
            break;
        case TAG_RIGHT_TABLEVIEW:{
            KSBlockPickerRightViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightTableViewIdentifier];
            if (cell == nil) {
                cell = [[KSBlockPickerRightViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:rightTableViewIdentifier];
            }
            __block NSIndexPath *leftTableViewIndexPath = _leftTableView.indexPathForSelectedRow;
            NSDictionary *district = self.data[leftTableViewIndexPath.row];
            NSArray *blocks = [district allValues].firstObject;
            cell.textLabel.text = blocks[indexPath.row];

            cell.isSelected = [_cache rightTableViewCellIsSelected:indexPath.row atLeftTableViewCellIndex:leftTableViewIndexPath.row];

            @WeakObj(cell);
            @WeakObj(self);
            cell.buttonClickedBlock = ^(void){
                @StrongObj(cell);
                @StrongObj(self);
                
                if ((indexPath.row == 0) && ([cell.textLabel.text rangeOfString:@"不限"].length > 0)) {
                    for (NSInteger i = 0; i < blocks.count; ++i) {
                        [self->_cache cacheRightSelectedCell:cell atRightIndexPathRow:i leftIndexPathRow:leftTableViewIndexPath.row];
                    }
                    [self.rightTableView reloadData];
                }else{
                    [self->_cache cacheRightSelectedCell:cell atRightIndexPathRow:indexPath.row leftIndexPathRow:leftTableViewIndexPath.row];
                }
                
                NSArray *rightSelectedRows = [self->_cache rightTableViewCellSelectedAtLeftTableViewCellIndex:leftTableViewIndexPath.row];
                KSBlockPickerClearFilterButton *clearButton =  (KSBlockPickerClearFilterButton *) [self viewWithTag:TAG_CLEAR_FILTER];
                if (rightSelectedRows.count > 0) {
                    clearButton.clearEnable = YES;
                }else{
                    clearButton.clearEnable = NO;
                }
                
                [self.leftTableView reloadData];
                [self.leftTableView selectRowAtIndexPath:leftTableViewIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            };
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case TAG_LEFT_TABLEVIEW:{
            [_rightTableView reloadData];
        }
            break;
        case TAG_RIGHT_TABLEVIEW:{
            
        }
            break;
            
        default:
            break;
    }
}

-(void)reloadData{
    [_leftTableView reloadData];
    [_rightTableView reloadData];
    
    if (nil != self.data && self.data.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
}

-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)remove{
    [self removeFromSuperview];
}

- (void)dealloc{
    
}

@end
