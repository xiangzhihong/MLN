//
//  MLNUIScrollView.m
//  Expecta
//
//  Created by MoMo on 2018/7/5.
//

#import "MLNUIScrollView.h"
#import "MLNUIKitHeader.h"
#import "MLNUIViewExporterMacro.h"
#import "UIScrollView+MLNUIKit.h"
#import "MLNUIScrollViewDelegate.h"
#import "UIView+MLNUILayout.h"
#import "UIView+MLNUIKit.h"
#import "MLNUILuaCore.h"
#import "MLNUIInnerScrollView.h"
#import "MLNUIViewConst.h"
#import "MLNUIStack.h"

@interface MLNUIScrollView()

@property (nonatomic, strong) MLNUIInnerScrollView *innerScrollView;
@property (nonatomic, assign) BOOL autoFitSize; // scrollView如果没有设置固定宽高，则会自适应内容大小

@end

@implementation MLNUIScrollView

- (instancetype)initWithMLNUILuaCore:(MLNUILuaCore *)luaCore isHorizontal:(NSNumber *)isHorizontal
{
    if (self = [super initWithFrame:CGRectZero]) {
        _innerScrollView = [[MLNUIInnerScrollView alloc] initWithMLNUILuaCore:luaCore direction:[isHorizontal boolValue] requetLayoutHandler:[self requestLayoutHandler]];
        [super luaui_addSubview:_innerScrollView];
        _autoFitSize = NO;
    }
    return self;
}

// contentStack作为根节点，而scrollView作为叶子节点，所以contentStack被标为dirty时不会向上传递
// 因此在contentStack测量时需要将scrollView主动标为dirty，通过测量scrollView来测量contentStack
- (MLNUIScrollViewNodeRequestLayoutHandler)requestLayoutHandler {
    __weak typeof(self) weakSelf = self;
    return ^CGSize(void){
        MLNUILayoutNode *node = weakSelf.mlnui_layoutNode;
        [node markDirty];
        return [node applyLayout];
    };
}

#pragma mark - Override

- (void)luaui_addSubview:(UIView *)view {
    [self.innerScrollView luaui_addSubview:view];
}

- (void)luaui_removeAllSubViews {
    [self.innerScrollView luaui_removeAllSubViews];
}

- (void)setLuaui_loadahead:(CGFloat)loadahead
{
    [self.innerScrollView setLuaui_loadahead:loadahead];
}

- (CGFloat)luaui_loadahead
{
    return self.innerScrollView.luaui_loadahead;
}

- (void)setLuaui_ContentOffset:(CGPoint)point
{
    [self.innerScrollView luaui_setContentOffset:point];
}

- (CGPoint)luaui_contentOffset
{
    return [self.innerScrollView luaui_contentOffset];
}

- (void)setLuaui_ScrollEnabled:(BOOL)scrollEnable
{
    [self.innerScrollView setScrollEnabled:scrollEnable];
}

- (BOOL)luaui_isScrollEnabled
{
    return self.innerScrollView.isScrollEnabled;
}

- (void)setLuaui_Bounces:(BOOL)bounces
{
    [self.innerScrollView setBounces:bounces];
}

- (BOOL)luaui_bounces
{
    return self.innerScrollView.bounces;
}

- (void)setLuaui_showsHorizontalScrollIndicator:(BOOL)show
{
    self.innerScrollView.showsHorizontalScrollIndicator = show;
}

- (BOOL)luaui_showsHorizontalScrollIndicator
{
    return self.innerScrollView.showsHorizontalScrollIndicator;
}

- (void)setLuaui_showsVerticalScrollIndicator:(BOOL)show
{
    self.innerScrollView.showsVerticalScrollIndicator = show;
}

- (BOOL)luaui_showsVerticalScrollIndicator
{
    return self.innerScrollView.showsVerticalScrollIndicator;
}

- (void)setLuaui_alwaysBounceHorizontal:(BOOL)alwaysBounceHorizontal
{
    self.innerScrollView.alwaysBounceHorizontal = alwaysBounceHorizontal;
}

- (BOOL)luaui_alwaysBounceHorizontal
{
    return self.innerScrollView.alwaysBounceHorizontal;
}

- (void)setLuaui_alwaysBounceVertical:(BOOL)alwaysBounceVertical
{
    self.innerScrollView.alwaysBounceVertical = alwaysBounceVertical;
}

- (BOOL)luaui_alwaysBounceVertical
{
    return self.innerScrollView.alwaysBounceVertical;
}

- (void)setLuaui_scrollBeginCallback:(MLNUIBlock *)callback
{
    self.innerScrollView.luaui_scrollBeginCallback = callback;
}

- (void)setLuaui_scrollingCallback:(MLNUIBlock *)callback
{
    self.innerScrollView.luaui_scrollingCallback = callback;
}

- (void)setLuaui_endDraggingCallback:(MLNUIBlock *)callback
{
    self.innerScrollView.luaui_endDraggingCallback = callback;
}

- (void)setLuaui_startDeceleratingCallback:(MLNUIBlock *)callback
{
    self.innerScrollView.luaui_startDeceleratingCallback = callback;
}

- (void)setLuaui_scrollEndCallback:(MLNUIBlock *)callback
{
    self.innerScrollView.luaui_scrollEndCallback = callback;
}

- (void)luaui_setContentInset:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    [self.innerScrollView luaui_setContentInset:top right:right bottom:bottom left:left];
}

- (void)luaui_getContetnInset:(MLNUIBlock*)block
{
    [self.innerScrollView luaui_getContetnInset:block];
}

- (void)luaui_setScrollIndicatorInset:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom  left:(CGFloat)left
{
    [self.innerScrollView luaui_setScrollIndicatorInset:top right:right bottom:bottom left:left];
}

- (void)luaui_setContentOffsetWithAnimation:(CGPoint)point
{
    [self.innerScrollView luaui_setContentOffsetWithAnimation:point];
}

- (void)mlnui_setLuaScrollEnable:(BOOL)scrollEnable
{
    [self.innerScrollView mlnui_setLuaScrollEnable:scrollEnable];
}

- (void)mlnui_setFlingSpeed:(CGFloat)speed
{
    self.innerScrollView.decelerationRate = speed;
}

- (CGFloat)mlnui_flingSpeed
{
    return self.innerScrollView.decelerationRate;
}

- (void)mlnui_setPagingEnable:(BOOL)pagingEnabled
{
    self.innerScrollView.pagingEnabled = pagingEnabled;
}

- (BOOL)mlnui_pagingEnabled
{
    return self.innerScrollView.pagingEnabled;
}

#pragma mark - Override (Layout)

- (BOOL)mlnui_layoutEnable {
    return YES;
}

- (BOOL)luaui_isContainer {
    return YES;
}

- (CGSize)mlnui_sizeThatFits:(CGSize)size {
    _autoFitSize = YES;
    MLNUIPlaneStack *contentStack = (MLNUIPlaneStack *)self.innerScrollView.mlnui_contentView;
    [contentStack setCrossAxisMaxSize:size];
    return [contentStack.mlnui_layoutNode applyLayoutWithSize:CGSizeMake(MLNUIUndefined, MLNUIUndefined)]; // 自适应内容大小 (前提是没有设置固定宽高)
}

- (void)mlnui_layoutCompleted {
    [super mlnui_layoutCompleted];
    if (!_autoFitSize) {
        MLNUIPlaneStack *contentStack = (MLNUIPlaneStack *)self.innerScrollView.mlnui_contentView;
        [contentStack setCrossAxisSize:self.innerScrollView.frame.size]; // 固定宽高情况下，要让contentStack交叉轴大小和scrollView保持一致（主轴方向上滚动）
        [contentStack mlnui_requestLayoutIfNeedWithSize:CGSizeMake(MLNUIUndefined, MLNUIUndefined)]; // 固定宽高不会执行mlnui_sizeThatFits
        
    } else { // 自适应内容要二次测量，处理subviews带有widthPercent/heightPercent的情况
        MLNUILayoutNode *contentNode = self.innerScrollView.mlnui_contentView.mlnui_layoutNode;
        contentNode.width = MLNUIPointValue(self.frame.size.width);
        contentNode.height = MLNUIPointValue(self.frame.size.height);
        [contentNode applyLayoutWithSize:self.frame.size];
    }
}

#pragma mark - MLNUIPaddingContainerViewProtocol

- (UIView *)mlnui_contentView {
    return self.innerScrollView;
}

#pragma mark - Export For Lua
LUAUI_EXPORT_VIEW_BEGIN(MLNUIScrollView)
LUAUI_EXPORT_VIEW_PROPERTY(loadThreshold, "setLuaui_loadahead:", "luaui_loadahead", MLNUIScrollView)
LUAUI_EXPORT_VIEW_PROPERTY(contentOffset, "setLuaui_ContentOffset:", "luaui_contentOffset", MLNUIScrollView)
LUAUI_EXPORT_VIEW_PROPERTY(scrollEnabled, "setLuaui_ScrollEnabled:", "luaui_isScrollEnabled", MLNUIScrollView)
LUAUI_EXPORT_VIEW_PROPERTY(i_bounces, "setLuaui_Bounces:", "luaui_bounces", MLNUIScrollView)
LUAUI_EXPORT_VIEW_PROPERTY(showsHorizontalScrollIndicator, "setLuaui_showsHorizontalScrollIndicator:", "luaui_showsHorizontalScrollIndicator", MLNUIScrollView)
LUAUI_EXPORT_VIEW_PROPERTY(showsVerticalScrollIndicator, "setLuaui_showsVerticalScrollIndicator:", "luaui_showsVerticalScrollIndicator", MLNUIScrollView)
LUAUI_EXPORT_VIEW_PROPERTY(i_bounceHorizontal, "setLuaui_alwaysBounceHorizontal:", "luaui_alwaysBounceHorizontal", MLNUIScrollView)
LUAUI_EXPORT_VIEW_PROPERTY(i_bounceVertical, "setLuaui_alwaysBounceVertical:", "luaui_alwaysBounceVertical", MLNUIScrollView)
LUAUI_EXPORT_VIEW_PROPERTY(a_flingSpeed, "mlnui_setFlingSpeed:", "mlnui_flingSpeed" , MLNUIScrollView)
LUAUI_EXPORT_VIEW_PROPERTY(i_pagingEnabled, "mlnui_setPagingEnable:", "mlnui_pagingEnabled" , MLNUIScrollView)
LUAUI_EXPORT_VIEW_METHOD(setScrollBeginCallback, "setLuaui_scrollBeginCallback:",MLNUIScrollView)
LUAUI_EXPORT_VIEW_METHOD(setScrollingCallback, "setLuaui_scrollingCallback:",MLNUIScrollView)
LUAUI_EXPORT_VIEW_METHOD(setEndDraggingCallback, "setLuaui_endDraggingCallback:",MLNUIScrollView)
LUAUI_EXPORT_VIEW_METHOD(setStartDeceleratingCallback, "setLuaui_startDeceleratingCallback:",MLNUIScrollView)
LUAUI_EXPORT_VIEW_METHOD(setScrollEndCallback, "setLuaui_scrollEndCallback:",MLNUIScrollView)
LUAUI_EXPORT_VIEW_METHOD(setContentInset, "luaui_setContentInset:right:bottom:left:", MLNUIScrollView)
LUAUI_EXPORT_VIEW_METHOD(getContentInset, "luaui_getContetnInset:", MLNUIScrollView)
LUAUI_EXPORT_VIEW_METHOD(setScrollIndicatorInset, "luaui_setScrollIndicatorInset:right:bottom:left:", MLNUIScrollView)
LUAUI_EXPORT_VIEW_METHOD(setOffsetWithAnim, "luaui_setContentOffsetWithAnimation:", MLNUIScrollView)
LUAUI_EXPORT_VIEW_METHOD(setScrollEnable, "mlnui_setLuaScrollEnable:", MLNUIScrollView)
LUAUI_EXPORT_VIEW_END(MLNUIScrollView, ScrollView, YES, "MLNUIView", "initWithMLNUILuaCore:isHorizontal:")

@end

