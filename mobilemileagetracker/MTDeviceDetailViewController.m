//
//  MTDeviceDetailViewController.m
//  mobilemileagetracker
//
//  Created by Chris Ballinger on 9/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MTDeviceDetailViewController.h"

@implementation MTDeviceDetailViewController
@synthesize nameTextField;
@synthesize typeTextField;
@synthesize UUIDTextField;
@synthesize device;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    nameTextField.text = device.name;
    typeTextField.text = device.deviceType;
    UUIDTextField.text = device.uuid;
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setTypeTextField:nil];
    [self setUUIDTextField:nil];
    [self setDevice:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [nameTextField release];
    [typeTextField release];
    [UUIDTextField release];
    [device release];
    [super dealloc];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)requestFinished:(ASIFormDataRequest *)request
{
    NSLog(@"HTTP code %d:\n%@", [request responseStatusCode], [request responseString]);
}

- (void)requestFailed:(ASIFormDataRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"A network error has occurred. Please try again later." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}

- (IBAction)savePressed:(id)sender 
{
    ASIFormDataRequest *request = [MTDevice requestWithURL:[MTDevice RESTurl] filters:nil];
    device.name = nameTextField.text;
    device.deviceType = typeTextField.text;
    device.uuid = UUIDTextField.text;
    [request appendPostData:[device toJSON]];
    [request setDelegate:self];
    [request startAsynchronous];
    //[request setData:recording withFileName:[NSString stringWithFormat:@"%d.caf",unixTime] andContentType:@"audio/x-caf" forKey:@"doc_file"];

}
@end
