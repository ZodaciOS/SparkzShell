#import "SparkzBridge.h"
#include <pthread.h>
#include <unistd.h>
#include <string.h>

NSNotificationName const SparkzOutputNotification = @"SparkzOutputNotification";

@interface SparkzEngine()
@property (nonatomic, assign) pthread_t emulator_thread;
@property (nonatomic, strong) NSMutableArray<NSString *> *inputQueue;
@property (nonatomic, assign) pthread_mutex_t input_mutex;
@property (nonatomic, assign) pthread_cond_t input_cond;
@end

static void *emulator_main(void *arg) {
    SparkzEngine *self = (__bridge SparkzEngine *)arg;
    
    [self postOutput:@"SparkzShell Booting...\n"];
    sleep(1);
    [self postOutput:@"Welcome to Debian 12 (bookworm) amd64 (Simulated)\n"];
    [self postOutput:@"sparkz@localhost:~$ "];

    while (1) {
        pthread_mutex_lock(&self->_input_mutex);
        
        while (self.inputQueue.count == 0) {
            pthread_cond_wait(&self->_input_cond, &self->_input_mutex);
        }
        
        NSString *command = self.inputQueue.firstObject;
        [self.inputQueue removeObjectAtIndex:0];
        
        pthread_mutex_unlock(&self->_input_mutex);

        NSString *response;
        if ([command isEqualToString:@"ls\n"]) {
            response = @"bin/  dev/  etc/  home/  lib/  mnt/  proc/  root/  run/  tmp/  usr/  var/\n";
        } else if ([command isEqualToString:@"uname -a\n"]) {
            response = @"Linux localhost 5.10.0-ish x86_64 GNU/Linux\n";
        } else if ([command isEqualToString:@"passwd\n"]) {
            response = @"Changing password for root.\n(current) UNIX password: \n";
        } else if ([command isEqualToString:@"\n"]) {
            response = @"";
        } else {
            NSString *trimmedCmd = [command stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            response = [NSString stringWithFormat:@"command not found: %@\n", trimmedCmd];
        }
        
        [self postOutput:response];
        
        if ([command isEqualToString:@"exit\n"]) {
            [self postOutput:@"logout\n[Process completed]"];
            break;
        }
        
        [self postOutput:@"sparkz@localhost:~$ "];
    }
    return NULL;
}

@implementation SparkzEngine

- (instancetype)init {
    self = [super init];
    if (self) {
        _inputQueue = [NSMutableArray new];
        pthread_mutex_init(&_input_mutex, NULL);
        pthread_cond_init(&_input_cond, NULL);
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_input_mutex);
    pthread_cond_destroy(&_input_cond);
}

- (void)start {
    pthread_create(&_emulator_thread, NULL, emulator_main, (__bridge void *)self);
}

- (void)sendInput:(NSString *)input {
    pthread_mutex_lock(&_input_mutex);
    [self.inputQueue addObject:input];
    pthread_cond_signal(&_input_cond);
    pthread_mutex_unlock(&_input_mutex);
}

- (void)postOutput:(NSString *)output {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SparkzOutputNotification
                                                            object:output];
    });
}

@end
