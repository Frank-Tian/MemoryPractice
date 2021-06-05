//
//  ViewController.m
//  VMDemo
//
//  Created by Tian on 2021/6/3.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *group;
@property (nonatomic, strong) NSThread *thread;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.group = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        [self.group addObject:[[Person alloc] init]];
    }
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(action) object:nil];
    [self.thread setName:@"com.tech.test"];
    [self.thread start];
}

- (void)action {
//    while (true) {
//        Model *m = [self.container takeModel];
//        [m increment];
//    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}



- (void)testMallocCrash {
    //    void *buffer = malloc(8000 * 1024 * 1024);
    //    crash
    //    VMDemo(85234,0x11749fe00) malloc: can't allocate region
    //    :*** mach_vm_map(size=18446744073508225024, flags: 100) failed (error code=3)
    //    VMDemo(85234,0x11749fe00) malloc: *** set a breakpoint in malloc_error_break to debug
}

@end
