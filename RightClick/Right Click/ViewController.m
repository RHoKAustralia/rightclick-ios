//
//  ViewController.m
//  Right Click
//
//  Created by Janidu Wanigasuriya on 12/5/15.
//  Copyright © 2015 Rhok. All rights reserved.
//

#import "ViewController.h"

#import "NoteViewController.h"
#import "Note.h"
#import "Lesson.h"
#import "DataService.h"

@interface ViewController ()<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, NoteViewControllerDelegate, UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *notesTableView;
@property(nonatomic, strong)Lesson *lesson;
@property(nonatomic, strong)UIDocumentInteractionController *documentInteractionController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.lesson = [Lesson new];
    self.lesson.notes = [NSMutableArray new];
    
    self.lesson.name = @"New lesson";
    self.lesson.mentorEmail = @"testMentor@email.com";
    self.lesson.menteeEmail = @"testMentee@email.com";
    self.lesson.startDate = [NSDate date];
}

- (IBAction)addNote:(id)sender {
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Note type:"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Picture", @"Text", nil];
    [popup showInView:self.view];
}

- (IBAction)exportNote:(id)sender {
    
    [[DataService sharedManager] generatePDFWithLesson:self.lesson];
    
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:[[DataService sharedManager] getPDFPath]];
    
    if (URL) {
        // Initialize Document Interaction Controller
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        // Configure Document Interaction Controller
        [self.documentInteractionController setDelegate:self];
        
        // Preview PDF
        [self.documentInteractionController presentPreviewAnimated:YES];
    }
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

-(void)didEnterTextNote:(NSString *)text {
    [[DataService sharedManager] addNoteWithText:text andImage:nil mediaInfo:nil lesson:self.lesson];
    [self.notesTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lesson.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"] ;
    }
    
    Note *note = [self.lesson.notes objectAtIndex:indexPath.row];
    
    NSString *tableText = note.instruction.length == 0 ? @"Image Note" : note.instruction;
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@", (long)indexPath.row + 1, tableText];
    return cell;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        NSLog(@"Add Picture Note");
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }else if (buttonIndex == 1){
        NSLog(@"Add Text Note");
        NoteViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"NoteViewController"];
        newView.delegate = self;
        [self.navigationController pushViewController:newView animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [[DataService sharedManager] addNoteWithText:nil andImage:chosenImage mediaInfo:info lesson:self.lesson];
    [self.notesTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
