//
//  FourthViewController.m
//  FutureWeather
//
//  Created by Prince on 6/6/16.
//  Copyright © 2016 Prince. All rights reserved.
//

#import "FourthViewController.h"
#import "AppDelegate.h"
#import "CustomTableViewCell.h"

@interface FourthViewController ()

@property (weak, nonatomic) IBOutlet UITableView *locationTable;

@end

@implementation FourthViewController

AppDelegate *tableAppDelegate;
NSMutableArray *tableContents;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _locationTable.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    tableContents = [[NSMutableArray alloc] init];
    tableAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    tableContents = tableAppDelegate.savedLocations;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableContents count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = (CustomTableViewCell *) [_locationTable dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[tableContents objectAtIndex:indexPath.row] localizedUppercaseString];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
