//
//  ViewController.m
//  MaxMemoryBudget
//
//  Created by Tian on 2021/6/5.
//

#import "ViewController.h"
#import <sys/types.h>
#import <sys/sysctl.h>
#import "MemoryHelper.h"

#define CRASH_MEMORY_FILE_NAME @"CrashMemory.dat"
#define MEMORY_WARNINGS_FILE_NAME @"MemoryWarnings.dat"

@interface ViewController ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (weak, nonatomic) IBOutlet UILabel *maxMemoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentMemoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *appMemoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
- (IBAction)startupAction:(id)sender;
- (IBAction)leakAction:(id)sender;

@end

@implementation ViewController {
    Byte *p[10000];
    int allocatedMB;
    BOOL firstMemoryWarningReceived;
    NSMutableArray *memoryWarnings;
    BOOL leakTest;
    CGFloat _totalMemory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    memoryWarnings = [NSMutableArray array];
    _totalMemory = [MemoryHelper getTotalMemorySize];
    self.maxMemoryLabel.text = [NSString stringWithFormat:@"%.2f MB", _totalMemory];

    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
    [_displayLink setPaused:YES];
    _displayLink.preferredFramesPerSecond = 30;
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)displayLinkTick:(CADisplayLink *)link {
    CGFloat usage = [MemoryHelper currentAppUsedMemory];
    CGFloat rate = usage / _totalMemory * 100;
    self.currentMemoryLabel.text = [NSString stringWithFormat:@"%.2f MB", [MemoryHelper availableMemory]];
    self.appMemoryLabel.text = [NSString stringWithFormat:@"%.2f MB", usage];
    self.rateLabel.text = [NSString stringWithFormat:@"%.2f %%", rate];
    if (leakTest) {
        [self allocateMemory];
    }
}

- (IBAction)leakAction:(id)sender {
    leakTest = !leakTest;
}

- (IBAction)startupAction:(id)sender {
    self.displayLink.paused = ![self.displayLink isPaused];
}

- (void)allocateMemory {
    
    p[allocatedMB] = malloc(1048576);
    memset(p[allocatedMB], 0, 1048576);
    allocatedMB += 1;
    
    if (firstMemoryWarningReceived) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        NSString *crashM = [NSString stringWithFormat:@"%d", allocatedMB];
        [crashM writeToFile:[basePath stringByAppendingPathComponent:CRASH_MEMORY_FILE_NAME] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    firstMemoryWarningReceived = YES;
    [memoryWarnings addObject:@(allocatedMB)];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    [memoryWarnings writeToFile:[basePath stringByAppendingPathComponent:MEMORY_WARNINGS_FILE_NAME] atomically:YES];
}
@end
