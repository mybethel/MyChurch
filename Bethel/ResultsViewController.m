//
//  ResultsViewController.m
//  Bethel
//
//  Created by Albert Martin on 4/8/14.
//  Copyright (c) 2014 Albert Martin. All rights reserved.
//

#import "ResultsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LocationTableCell.h"

@implementation ResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the table view defaults
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
    
    // Content perfect pixel
    UIView *pixel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 1)];
    pixel.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    [self.view addSubview:pixel];
}

- (UIScrollView *)scrollViewForParallexController
{
    return self.tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of locations in view.
    return [_controller.locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationTableCell *cell = (LocationTableCell *)[tableView dequeueReusableCellWithIdentifier:@"MinistryLocationCell"];
    
    ChurchLocation *location = _controller.locations[indexPath.row];
    cell.ministryName.text = location.title;
    cell.locationName.text = location.subtitle;
    [cell.logoView setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://cdn.bethel.io/150x150/%@", location.ministry[@"image"]]]
                  placeholderImage:[UIImage imageNamed:@"Placeholder"]
                           options:SDWebImageRefreshCached];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ChurchDetail" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_controller.locations count]-1) {
        return 99+36;
    }
    
    return 89;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ChurchDetail"]) {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] setActiveLocation: [_controller.locations objectAtIndex: [self.tableView indexPathForSelectedRow].row]];
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}

@end
