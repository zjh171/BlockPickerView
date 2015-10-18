//
//  KSBlockPickerView.m
//  Angejia
//
//  Created by zhujinhui on 15/10/2.
//  Copyright © 2015年 Plan B Inc. All rights reserved.
//

#import "KSBlockPickerView.h"

#define WIDTH_LEFT_TABLEVIEW 150
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

#define KEY_LEFT_SELECTED_ROW(leftRow)  ([NSString stringWithFormat:@"%li",(long)leftRow])

#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#pragma mark - KSBlockPickerClearFilterButton

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
        UIImage *image = [UIImage imageNamed:@"btn_sx"];
        [self setImage:image forState:UIControlStateNormal];
        //        [self setBackgroundImage:image forState:UIControlStateNormal];
    }else{
        UIImage *image = [UIImage imageNamed:@"btn_pre_sx"];
        //        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
        
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
        KSBlockPickerCheckButton *accessoryButton = [KSBlockPickerCheckButton checkButtonWithFrame:CGRectMake(0, 0, HEIGHT_TABLEVIEW_ROW, HEIGHT_TABLEVIEW_ROW)];
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
    NSMutableDictionary *_cache;
}

@property (nonatomic, strong, readonly) NSArray *leftHasDataTableViewCellRowIndexs;

@property (nonatomic, assign) BOOL leftTableViewEnableMultiSelect;

@property (nonatomic, strong) NSArray *data;

@end

@implementation PickerCache

#define BADGE_LEFT      @"@"
#define BADGE_RIGHT     @"#"

- (instancetype)initWithData:(NSArray *)data
{
    self = [super init];
    if (self) {
        _cache = [[NSMutableDictionary alloc] init];
        self.data = data;
    }
    return self;
}

-(void)clearCache{
    [_cache removeAllObjects];
}

-(BOOL) hasData{
    BOOL hasData = NO;
    if ([_cache allKeys].count > 0 && [_cache allValues].count > 0) {
        hasData = YES;
    }
    return hasData;
}

-(BOOL)allrightRowselectedAtLeftRowIndex:(NSInteger) leftRowIndex withCachedString:(NSString *) cache{
    NSMutableString *allselectedString = [[NSMutableString alloc] init];
    NSAssert(self.data.count > leftRowIndex, @"数组越界");
    NSDictionary *dataAtleftRowInfoDictionary = self.data[leftRowIndex];
    NSArray *rightRowData = [dataAtleftRowInfoDictionary allValues].firstObject;
    for (NSInteger index = 1; index < rightRowData.count; ++index) {
        [allselectedString appendFormat:@"@%li#",(long)index];
    }
    if (cache.length == allselectedString.length) {
        return YES;
    }
    return NO;
}



-(void)cacheRightSelectedCell:(KSBlockPickerRightViewCell *)cell atRightIndexPathRow:(NSInteger) rightRow leftIndexPathRow:(NSInteger) leftRow{
    
    NSString *cachedString = [self->_cache objectForKey:KEY_LEFT_SELECTED_ROW(leftRow)];
    
    //    NSLog(@"cachedString %@", cachedString);
    if (nil == cachedString) {
        cachedString = @"";
    }
    NSMutableString *currentSelectedRowFormattedString = [NSMutableString stringWithFormat:@"@%li#",(long)rightRow];
    //    NSLog(@"currentSelectedRowFormattedString %@", currentSelectedRowFormattedString);
    //
    //    NSLog(@"%@",currentSelectedRowFormattedString);
    
    if (cell.isSelected || nil == cell) {
        cachedString = [cachedString stringByAppendingString:currentSelectedRowFormattedString];
        //如果全部选中，则添加第0个“不限”
        if ((rightRow != 0) && [self allrightRowselectedAtLeftRowIndex:leftRow withCachedString:cachedString]) {
            cachedString = [cachedString stringByAppendingString:@"@0#"];
        }
        
    }else{
        NSRange range = [cachedString rangeOfString:currentSelectedRowFormattedString];
        if (rightRow != 0) {
            cachedString = [cachedString stringByReplacingOccurrencesOfString:@"@0#" withString:@""];
        }
        
        if (range.length > 0) {
            cachedString = [cachedString stringByReplacingOccurrencesOfString:currentSelectedRowFormattedString withString:@""];
        }
    }
    if ([cachedString isEqualToString:@""]) {
        [self->_cache removeObjectForKey:KEY_LEFT_SELECTED_ROW(leftRow)];
    }else{
        [self->_cache removeObjectForKey:KEY_LEFT_SELECTED_ROW(leftRow)];
        [self->_cache setObject:cachedString forKey:KEY_LEFT_SELECTED_ROW(leftRow)];
    }
    
    //mutltiselect
    if (!self.leftTableViewEnableMultiSelect) {
        NSMutableDictionary *templeftSelectedRows = [[NSMutableDictionary alloc] init];
        for (NSString *leftSelectedItem in [_cache allKeys]) {
            if ([leftSelectedItem integerValue] == leftRow) {
                templeftSelectedRows[leftSelectedItem] = [_cache objectForKey:leftSelectedItem] ;
            }
        }
        self->_cache = templeftSelectedRows;
    }
}


-(NSArray *)rightTableViewCellSelectedAtLeftTableViewCellIndex:(NSInteger) leftRow{
    NSMutableArray *allSelectedRow = [[NSMutableArray alloc] init];
    NSString *cachedString2 = [self->_cache objectForKey:KEY_LEFT_SELECTED_ROW(leftRow)];
    NSArray *rows = [cachedString2 componentsSeparatedByString:@"#"];
    for (NSString *rowStringItem in rows) {
        if (![rowStringItem isEqualToString:@""]) {
            NSString *rowStringItem2 = [rowStringItem stringByReplacingOccurrencesOfString:@"@" withString:@""];
            
            NSInteger row = [rowStringItem2 integerValue];
            [allSelectedRow addObject:[NSNumber numberWithInteger:row]];
        }
    }
    return allSelectedRow;
}

-(BOOL)rightTableViewCellIsSelected:(NSInteger)rightRow atLeftTableViewCellIndex:(NSInteger) leftRow{
    BOOL rightIsSelected = NO;
    if ([self.leftHasDataTableViewCellRowIndexs isKindOfClass:[NSArray class]] ) {
        for (NSNumber *rowItem  in [self rightTableViewCellSelectedAtLeftTableViewCellIndex:leftRow]) {
            if ([rowItem integerValue] == rightRow) {
                rightIsSelected = YES;
                break;
            }
        }
    }
    return rightIsSelected;
}

-(BOOL)leftTableViewCellHasData:(NSInteger) leftRow{
    BOOL leftTableViewRowHasData = NO;
    for (NSNumber *leftRowItem in self.leftHasDataTableViewCellRowIndexs) {
        if (leftRow == [leftRowItem integerValue]) {
            leftTableViewRowHasData = YES;
            break;
        }
    }
    return leftTableViewRowHasData;
}

-(NSArray *)leftHasDataTableViewCellRowIndexs{
    NSArray *allCacheKeys = [self->_cache allKeys];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (NSString *leftSlectedRowItem in allCacheKeys) {
        [resultArray addObject:[NSNumber numberWithInteger:[leftSlectedRowItem integerValue]]];
    }
    return resultArray;
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

-(instancetype)initWithData:(NSArray *)data multiDistrictsSelectEnable:(BOOL)enable{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithHex:0x666666 alpha:0.6f];
        _cache = [[PickerCache alloc] initWithData:data];
        self.multiDistrictsSelectEnable = enable;
        
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
        
        if (nil != self.data && self.data.count > 0) {
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
            NSMutableDictionary *allRows = [[NSMutableDictionary alloc] init];
            for (NSNumber *leftSelectRowItem in self->_cache.leftHasDataTableViewCellRowIndexs) {
                NSArray *rightSelectedRows = [self->_cache rightTableViewCellSelectedAtLeftTableViewCellIndex:leftSelectRowItem.integerValue];
                allRows[leftSelectRowItem] = rightSelectedRows;
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(blockPickerView:selectedRows:)]) {
                [self.delegate blockPickerView:self selectedRows:allRows];
            }
        }
            break;
        case TAG_CLEAR_FILTER:{
            [_cache clearCache];
            [_rightTableView reloadData];
            [_leftTableView reloadData];
            
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

static NSString *blockPickerLeftViewCellIdentifier = @"blockPickerLeftViewCellIdentifier";
static NSString *blockPickerRightViewCellIdentifier = @"blockPickerRightViewCellIdentifier";


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case TAG_LEFT_TABLEVIEW:{
            KSBlockPickerLeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:blockPickerLeftViewCellIdentifier];
            if (cell == nil) {
                cell = [[KSBlockPickerLeftViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:blockPickerLeftViewCellIdentifier];
            }
            cell.hasDataTableViewCellSelected = [self->_cache leftTableViewCellHasData:indexPath.row];
            
            NSDictionary *districts = self.data[indexPath.row];
            
            cell.textLabel.text = [districts allKeys].firstObject;
            return cell;
        }
            break;
        case TAG_RIGHT_TABLEVIEW:{
            KSBlockPickerRightViewCell *cell = [tableView dequeueReusableCellWithIdentifier:blockPickerRightViewCellIdentifier];
            if (cell == nil) {
                cell = [[KSBlockPickerRightViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:blockPickerRightViewCellIdentifier];
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
                
                if (0 == indexPath.row) {
                    for (NSInteger i = 0; i < blocks.count; ++i) {
                        [self->_cache cacheRightSelectedCell:cell atRightIndexPathRow:i leftIndexPathRow:leftTableViewIndexPath.row];
                    }
                }else{
                    [self->_cache cacheRightSelectedCell:cell atRightIndexPathRow:indexPath.row leftIndexPathRow:leftTableViewIndexPath.row];
                }
                [self.rightTableView reloadData];
                
                //                NSArray *rightSelectedRows = [self->_cache rightTableViewCellSelectedAtLeftTableViewCellIndex:leftTableViewIndexPath.row];
                KSBlockPickerClearFilterButton *clearButton =  (KSBlockPickerClearFilterButton *) [self viewWithTag:TAG_CLEAR_FILTER];
                if ([_cache hasData]) {
                    clearButton.clearEnable = YES;
                }else{
                    clearButton.clearEnable = NO;
                }
                
                [self.leftTableView reloadData];
                [self.leftTableView selectRowAtIndexPath:leftTableViewIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
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

-(void)setMultiDistrictsSelectEnable:(BOOL)multiDistrictsSelectEnable{
    _multiDistrictsSelectEnable = multiDistrictsSelectEnable;
    _cache.leftTableViewEnableMultiSelect = _multiDistrictsSelectEnable;
}

-(void)reloadData{
    [_leftTableView reloadData];
    [_rightTableView reloadData];
    
    if (nil != self.data && self.data.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    
    if ([_cache hasData]) {
        KSBlockPickerClearFilterButton *clearButton =  (KSBlockPickerClearFilterButton *) [self viewWithTag:TAG_CLEAR_FILTER];
        clearButton.clearEnable = YES;
    }
}


-(void)setSelectedRows:(NSDictionary *)selectedRows{
    _selectedRows = selectedRows;
    
    NSArray *leftSelectedRows = [_selectedRows allKeys];
    for (NSNumber *leftSelectedItem in leftSelectedRows) {
        NSArray *currentRightSelectedRows = selectedRows[leftSelectedItem];
        //add 不限
        NSDictionary *allBlocks = self.data[[leftSelectedItem integerValue]];
        NSArray *allBlockNames = [allBlocks allValues].firstObject;
        if (currentRightSelectedRows.count ==  (allBlockNames.count)) {
            [self->_cache cacheRightSelectedCell:nil atRightIndexPathRow:0 leftIndexPathRow:[leftSelectedItem integerValue]];
        }
        
        for (NSNumber *rightSelectedItem in currentRightSelectedRows) {
            [self->_cache cacheRightSelectedCell:nil atRightIndexPathRow:[rightSelectedItem integerValue] leftIndexPathRow:[leftSelectedItem integerValue]];
        }
    }
    [self reloadData];
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


