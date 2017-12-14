@import PiwikTracker;

#import "ObjectiveCCompatibilityChecker.h"

@implementation ObjectiveCCompatibilityChecker

- (void)check {
    PiwikTracker *piwikTracker = [[PiwikTracker alloc] initWithSiteId:@"5" baseURL:[NSURL URLWithString:@"http://example.com/piwik.php"] userAgent:nil];
    [piwikTracker trackWithView:@[@"example"] url:nil];
    [piwikTracker trackWithEventWithCategory:@"category" action:@"action" name:nil number:nil url:nil];
    [piwikTracker dispatch];
    piwikTracker.logger = [[DefaultLogger alloc] initWithMinLevel:LogLevelVerbose];
}

- (void)checkDeprecated {
    PiwikTracker *piwikTracker = [[PiwikTracker alloc] initWithSiteId:@"5" baseURL:[NSURL URLWithString:@"http://example.com/piwik.php"] userAgent:nil];
    [piwikTracker trackWithEventWithCategory:@"category" action:@"action" name:nil number:nil];
}

@end
