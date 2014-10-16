//
//  PDViewController.m
//  ParseDemo
//
//  Created by Joshua Howland on 6/25/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "PDViewController.h"
#import <Parse/Parse.h>

@interface PDViewController () <PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate>

@property (nonatomic, strong) PFUser *user;

@end

@implementation PDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)signIn:(id)sender {
    PFLogInViewController *logIn = [PFLogInViewController new];
    logIn.delegate = self;
    [self presentViewController:logIn animated:YES completion:nil];
}

- (IBAction)signUp:(id)sender {
    PFSignUpViewController *signUp = [PFSignUpViewController new];
    signUp.delegate = self;
    [self presentViewController:signUp animated:YES completion:nil];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    self.user = user;
    [self addUserData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    self.user = user;
    [self addUserData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addUserData {
    PFQuery *query = [PFQuery queryWithClassName:@"yourData"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
            PFObject *yourData = [PFObject objectWithClassName:@"yourData"];
            yourData[@"favoriteAlbum"] = @"Discovery";
            
            if (self.user) {
                yourData.ACL = [PFACL ACLWithUser:self.user];
            }
            
            [yourData saveInBackground];
        } else {
            NSLog(@"You already stored your data");
        }
    }];
}

@end
