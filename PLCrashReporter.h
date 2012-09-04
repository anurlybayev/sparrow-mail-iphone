@interface PLCrashReporter
@end

@interface PLCrashReport : NSObject
@end

@interface PLCrashReportTextFormatter
@end

@interface PLCrashReporter (MM)

+ (PLCrashReporter *) sharedReporter;

- (BOOL) hasPendingCrashReport;

- (NSData *) loadPendingCrashReportData;
- (NSData *) loadPendingCrashReportDataAndReturnError: (NSError **) outError;

- (BOOL) purgePendingCrashReport;
- (BOOL) purgePendingCrashReportAndReturnError: (NSError **) outError;

- (BOOL) enableCrashReporter;
- (BOOL) enableCrashReporterAndReturnError: (NSError **) outError;

@end

@interface PLCrashReport (MM)

- (id) initWithData: (NSData *) encodedData error: (NSError **) outError;

@end

@interface PLCrashReportTextFormatter (MM)

typedef enum {
    PLCrashReportTextFormatiOS = 0
} PLCrashReportTextFormat;

+ (NSString *) stringValueForCrashReport: (PLCrashReport *) report withTextFormat: (PLCrashReportTextFormat) textFormat;

@end
