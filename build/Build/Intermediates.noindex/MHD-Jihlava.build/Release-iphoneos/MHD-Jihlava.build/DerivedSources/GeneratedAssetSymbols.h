#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "mhd" asset catalog image resource.
static NSString * const ACImageNameMhd AC_SWIFT_PRIVATE = @"mhd";

#undef AC_SWIFT_PRIVATE