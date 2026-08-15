#import <UIKit/UIKit.h>
#include <mach-o/loader.h>
#include <objc/runtime.h>
#include <dlfcn.h>

static NSBundle*guestBundle;

int main(int a,char**v){
dlopen("@executable_path/Frameworks/YuriGameUI.dylib",RTLD_LAZY);

id u=NSUserDefaults.standardUserDefaults,s=[u stringForKey:@"selected"];
if(!s)return UIApplicationMain(a,v,nil,@"YiAppDelegate");
[u removeObjectForKey:@"selected"];

guestBundle=[NSBundle bundleWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/Applications/%@",s]];

class_replaceMethod(objc_getMetaClass("NSBundle"),@selector(mainBundle),imp_implementationWithBlock(^id(id s,SEL c){return guestBundle;}),"@@");

struct mach_header_64*h=dlsym(dlopen(guestBundle.executablePath.UTF8String,RTLD_LAZY),"_mh_execute_header");
struct load_command*c=(void*)h+sizeof(*h);
while(c->cmd!=LC_MAIN)c=(void*)c+c->cmdsize;

v[0]=(char*)guestBundle.executablePath.UTF8String;
return((int(*)(int,char**))((uintptr_t)h+((struct entry_point_command*)c)->entryoff))(a,v);
}