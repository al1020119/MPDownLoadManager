//
//  MusicDownloadListViewController.m
//  MusicPartnerDownload
//
//  Created by 度周末网络-王腾 on 16/1/25.
//  Copyright © 2016年 dzmmac. All rights reserved.
//

#import "MusicDownloadListViewController.h"
#import "MusicDownloadListTableCell.h"
#import "MusicDownloadDataSource.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PopViewLikeQQView.h"


@interface MusicDownloadListViewController ()

@property (nonatomic , strong) MusicDownloadDataSource *dataSource;

- (IBAction)moreAction:(UIButton *)sender;

@end

@implementation MusicDownloadListViewController

+(MusicDownloadListViewController *)shareManager{
    static MusicDownloadListViewController *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[UIStoryboard storyboardWithName:@"MusicDownloadList" bundle:nil] instantiateInitialViewController];
    });
    return instance;
}

-(void)startDownLoad{
    [self.mainTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[MusicDownloadDataSource alloc ] init];
    
    __weak typeof(self) weakSelf = self;
    self.dataSource.downloadStatusChangeBlock = ^(TaskDownloadState mpDownloadState,NSString *downLoadUrlString){
        [weakSelf.mainTableView reloadData];
    };
    
    [self.mainTableView setTableFooterView:[[UIView alloc ] init]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadNewTask];
}

-(void)loadNewTask{
    
    [self.dataSource  loadUnFinishedTasks];
    [self.mainTableView reloadData];
    [self.dataSource startDownLoadUnFinishedTasks];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.unFinishedTasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicDownloadListTableCell *musicListCell = [tableView dequeueReusableCellWithIdentifier:@"MusicDownloadListTableCell"];
    TaskEntity *taskEntity    = [self.dataSource.unFinishedTasks objectAtIndex:indexPath.row];
    [musicListCell showData:taskEntity];
    return musicListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskEntity *taskEntity = [self.dataSource.unFinishedTasks objectAtIndex:indexPath.row];
    MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:taskEntity.mpDownLoadPath]];
    [self presentViewController:moviePlayer animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)moreAction:(UIButton *)sender {
    
    [PopViewLikeQQView configCustomPopViewWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 147, 70, 120, 120)
                                          imagesArr:@[@"tip_delected",@"tip_download",@"tip_download"]
                                      dataSourceArr:@[@"全部删除",@"全部开始",@"全部暂停"] anchorPoint:CGPointMake(1, 0)
                                 seletedRowForIndex:^(NSInteger index) {
                                     if (index == 0) {
                                         [self.dataSource deleAllTask];
                                     }else if (index == 1){
                                         [self.dataSource startAllTask];
                                     }else{
                                          [self.dataSource pauseAllTask];
                                     }
                                     
                                     
                                 } animation:YES timeForCome:0.3 timeForGo:0.3];
}
@end
