#include "macos.h"

#ifdef __APPLE__

#import <Foundation/Foundation.h>

void enable_momentum_scroll() {
  [[NSUserDefaults standardUserDefaults]
    setBool: YES
    forKey: @"AppleMomentumScrollSupported"];
}

#endif