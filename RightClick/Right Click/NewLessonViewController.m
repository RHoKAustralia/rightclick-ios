//
//  NewLessonViewController.m
//  Right Click
//
//  Created by Janidu Wanigasuriya on 12/6/15.
//  Copyright © 2015 Rhok. All rights reserved.
//

#import "NewLessonViewController.h"
#import "Lesson.h"
#import "ViewController.h"

@interface NewLessonViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) UIPickerView *deviceTypesPicker;
@property (weak, nonatomic) IBOutlet UITextField *lessonTextField;
@property (weak, nonatomic) IBOutlet UITextField *tutorNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *tutorEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *studentNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *deviceTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *studentEmailTextField;
@property (strong, nonatomic)NSArray *deviceType;
@end

@implementation NewLessonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"New Lesson";
    
    self.deviceTypeTextField.delegate = self;
    
    self.deviceType = @[@"Mobile", @"Tablet", @"Laptop", @"Camera", @"Other"];
    
    self.deviceTypesPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    self.deviceTypesPicker.dataSource = self;
    self.deviceTypesPicker.delegate = self;
    self.deviceTypesPicker.showsSelectionIndicator = YES;
    self.deviceTypeTextField.inputView = self.deviceTypesPicker;
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.lessonTextField becomeFirstResponder];
    [self resetTextFields];
}

- (void)resetTextFields {
    self.lessonTextField.text = @"";
    self.tutorNameTextField.text = @"";
    self.tutorEmailTextField.text = @"";
    self.studentNameTextField.text = @"";
    self.studentEmailTextField.text = @"";
    self.deviceTypeTextField.text = @"";
}

- (IBAction)AddNotes:(id)sender {
    
    Lesson *lesson = [Lesson new];
    lesson.lessonTitle = self.lessonTextField.text;
    lesson.tutorName = self.tutorNameTextField.text;
    lesson.tutorEmail = self.tutorEmailTextField.text;
    lesson.studentName = self.studentNameTextField.text;
    lesson.deviceType = self.deviceTypeTextField.text;
    lesson.studentEmail = self.studentEmailTextField.text;
    lesson.startDate = [NSDate date];
    lesson.notes = [NSMutableArray new];
    
    NSLog(@"Lesson title %@", lesson.lessonTitle);
    NSLog(@"Tutor Name %@", lesson.tutorName);
    NSLog(@"Tutor Email %@", lesson.tutorEmail);
    NSLog(@"Student Name %@", lesson.studentName);
    NSLog(@"Student Email %@", lesson.studentEmail);
    NSLog(@"Device Type %@", lesson.deviceType);
    
    ViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    mainViewController.lesson = lesson;
    [self.navigationController pushViewController:mainViewController animated:YES];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *deviceType = [self.deviceType objectAtIndex:row];
    
    if ([deviceType isEqualToString:@"Other"]) {
        self.deviceTypeTextField.inputView = nil;
        self.deviceTypeTextField.text = @"";
        [self.deviceTypeTextField resignFirstResponder];
        [self.deviceTypeTextField becomeFirstResponder];
    }else {
        self.deviceTypeTextField.text = deviceType;
        [self.deviceTypeTextField resignFirstResponder];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.text.length != 0 && ![self.deviceType containsObject:textField.text]) {
        // Show Pickerview
        self.deviceTypeTextField.inputView = self.deviceTypesPicker;
    }
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.deviceType.count;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.deviceType objectAtIndex:row];
}


@end
