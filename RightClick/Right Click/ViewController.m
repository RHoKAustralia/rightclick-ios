//
//  ViewController.m
//  Right Click
//
//  Created by Janidu Wanigasuriya on 12/5/15.
//  Copyright © 2015 Rhok. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <TSMessages/TSMessageView.h>

#import "NoteViewController.h"
#import "Note.h"
#import "Lesson.h"
#import "DataService.h"
#import "AnnotationViewController.h"
#import "Config.h"

@interface ViewController ()<UIActionSheetDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, NoteViewControllerDelegate, UIDocumentInteractionControllerDelegate, AnnotationViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *notesTableView;
@property(nonatomic, strong)UIDocumentInteractionController *documentInteractionController;
@property(nonatomic, strong)NSDictionary * mediaInfo;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"New Lesson"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self action:@selector(home:)];
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    // Do any additional setup after loading the view, typically from a nib.
    [self.notesTableView setEditing:YES animated:YES];
    
    self.title = self.lesson.lessonTitle;
}

-(void)home:(UIBarButtonItem *)sender {
    
    UIAlertController *alertConfirmation = [UIAlertController
                                            alertControllerWithTitle:@"New Lesson"
                                            message:@"This will remove All Notes, Are you Sure ?"
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertConfirmation animated:YES completion:nil];
    
    UIAlertAction* okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [self.navigationController popToRootViewControllerAnimated:YES];
                               }];
    
    UIAlertAction* cancelAction = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleCancel
                               handler:nil];
    
    [alertConfirmation addAction:okAction];
    [alertConfirmation addAction:cancelAction];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
    
    NSURL *url = [NSURL URLWithString:POST_URL];
    
    [TSMessage showNotificationWithTitle:@"Please Wait"
                                subtitle:@"Hold On, We are sending your notes to the cloud"
                                    type:TSMessageNotificationTypeWarning];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:API_KEY forHTTPHeaderField:@"x-api-key"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *jsonString = [[DataService sharedManager] getJsonStringWithLesson:self.lesson];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                                                         success:^(AFHTTPRequestOperation * operation, id responseObject) {
                                                                             NSLog(@"Success from Server");
                                                                             
                                                                             [TSMessage showNotificationWithTitle:@"Awesome !"
                                                                                                         subtitle:@"Your notes are on the Cloud"
                                                                                                             type:TSMessageNotificationTypeSuccess];
                                                                             
                                                                         } failure:^(AFHTTPRequestOperation *operation, NSError * error) {
                                                                             NSLog(@"Error %@", error);
                                                                             [TSMessage showNotificationWithTitle:@"Oops!"
                                                                                                         subtitle:@"Can't post to the Cloud at the moment"
                                                                                                             type:TSMessageNotificationTypeError];
                                                                         }];
    [operation start];
    [self pdfExport];
}

- (void)pdfExport {
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

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    Note *noteToMove = [self.lesson.notes objectAtIndex:sourceIndexPath.row];
    [self.lesson.notes removeObjectAtIndex:sourceIndexPath.row];
    [self.lesson.notes insertObject:noteToMove atIndex:destinationIndexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lesson.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyIdentifier"];
    }
    
    cell.showsReorderControl = YES;
    
    Note *note = [self.lesson.notes objectAtIndex:indexPath.row];
    
    if (note.instruction.length == 0) {
        cell.textLabel.text = @"Image Note";
        cell.imageView.image = note.image;
    }else {
        cell.textLabel.text = note.instruction;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.lesson.notes removeObjectAtIndex:indexPath.row];
        [self.notesTableView reloadData];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        NSLog(@"Add Picture Note");
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:picker animated:YES completion:nil];
        });
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
    
    self.mediaInfo = info;
    
    AnnotationViewController *annotationView = [self.storyboard instantiateViewControllerWithIdentifier:@"AnnotationViewController"];
    annotationView.delegate = self;
    annotationView.imageToAnnotate = chosenImage;
    [self.navigationController pushViewController:annotationView animated:YES];
}

-(void)didAnnotateImage:(UIImage *)uiImage {
    [[DataService sharedManager] addNoteWithText:nil andImage:uiImage mediaInfo:self.mediaInfo lesson:self.lesson];
    [self.notesTableView reloadData];
}

@end
