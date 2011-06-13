//  License Agreement for Source Code provided by Mizage LLC
//
//  This software is supplied to you by Mizage LLC in consideration of your
//  agreement to the following terms, and your use, installation, modification
//  or redistribution of this software constitutes acceptance of these terms. If
//  you do not agree with these terms, please do not use, install, modify or
//  redistribute this software.
//
//  In consideration of your agreement to abide by the following terms, and
//  subject to these terms, Mizage LLC grants you a personal, non-exclusive
//  license, to use, reproduce, modify and redistribute the software, with or
//  without modifications, in source and/or binary forms; provided that if you
//  redistribute the software in its entirety and without modifications, you
//  must retain this notice and the following text and disclaimers in all such
//  redistributions of the software, and that in all cases attribution of Mizage
//  LLC as the original author of the source code shall be included in all such
//  resulting software products or distributions.  Neither the name, trademarks,
//  service marks or logos of Mizage LLC may be used to endorse or promote
//  products derived from the software without specific prior written permission
//  from Mizage LLC. Except as expressly stated in this notice, no other rights
//  or licenses, express or implied, are granted by Mizage LLC herein, including
//  but not limited to any patent rights that may be infringed by your
//  derivative works or by other works in which the software may be
//  incorporated.
//
//  The software is provided by Mizage LLC on an "AS IS" basis. MIZAGE LLC MAKES
//  NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
//  WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
//  PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
//  COMBINATION WITH YOUR PRODUCTS.
//
//  IN NO EVENT SHALL MIZAGE LLC BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
//  OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION
//  AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY
//  OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE,
//  EVEN IF MIZAGE LLC HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import "FileUtils.h"
#import "DBUtils.h"

NSString* const DBDropboxFileDidChangeNotification = 
                  @"DBDropboxFileDidChangeNotification";

@interface FileUtils ()
+ (NSString*)localPreferencesDirectoryPath;
+ (NSString*)dropboxPreferencesDirectoryPath;
@end

@implementation FileUtils

// This method checks to see if the preferences file exists in Dropbox
+ (BOOL)dropboxPreferencesExist
{
  return [[NSFileManager defaultManager] 
          fileExistsAtPath:[FileUtils dropboxPreferencesFilePath]];
}

+ (NSString*)preferencesDirectoryPath
{
  if([[NSUserDefaults standardUserDefaults] 
      boolForKey:kDBDropboxSyncEnabledKey])
    return [FileUtils dropboxPreferencesDirectoryPath];
  else
    return [FileUtils localPreferencesDirectoryPath];
}

// This method is a convenience method to return the file path of the
//  preferences file based on the current syncing state
+ (NSString*)preferencesFilePath
{
  if([[NSUserDefaults standardUserDefaults] 
      boolForKey:kDBDropboxSyncEnabledKey])
    return [FileUtils dropboxPreferencesFilePath];
  else
    return [FileUtils localPreferencesFilePath];
}

// This method returns the path to the preferences file on Dropbox
+ (NSString*)dropboxPreferencesFilePath
{
  if(![DBUtils isDropboxAvailable])
    return nil;
  
  return [NSString stringWithFormat:@"%@/%@DB.plist",
          [self dropboxPreferencesDirectoryPath],[[NSBundle mainBundle] bundleIdentifier]];
}

// This method returns the path to the preferences file on the local system
+ (NSString*)localPreferencesFilePath
{
  return [NSString stringWithFormat:@"%@/%@.plist",
          [FileUtils localPreferencesDirectoryPath],
          [[NSBundle mainBundle] bundleIdentifier]];
}

// This method returns a tilde expanded local path to the Preferences directory
+ (NSString*)localPreferencesDirectoryPath
{
  return [@"~/Preferences" stringByExpandingTildeInPath];
}

// This method returns the path to the Preferences directory on Dropbox
+ (NSString*)dropboxPreferencesDirectoryPath
{
  if(![DBUtils isDropboxAvailable])
    return nil;
  
  return [NSString stringWithFormat:@"%@/Preferences", [DBUtils dropboxPath]];
}

@end
