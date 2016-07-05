//
// Copyright 2016 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <EarlGrey/GREYBaseAction.h>
#import <EarlGrey/GREYConstants.h>

/**
 *  A GREYAction that implements the scroll action.
 */
@interface GREYScrollAction : GREYBaseAction

/**
 *  @remark init is not an available initializer. Use the other initializers.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 *  @remark initWithName::constraints: is overridden from its superclass.
 */
- (instancetype)initWithName:(NSString *)name
                 constraints:(id<GREYMatcher>)constraints NS_UNAVAILABLE;

/**
 *  Creates a scroll action that scrolls the contents in the given @c direction for the
 *  given @c amount.
 *
 *  @param direction The direction of the scroll.
 *  @param amount    The amount specified in points. The units here are the same as the units
 *                   of the coordinate system of the element matched.
 *
 *  @return An instance of GREYScrollAction, initialized with the provided
 *          direction and scroll amount.
 */
- (instancetype)initWithDirection:(GREYDirection)direction amount:(CGFloat)amount;

@end
