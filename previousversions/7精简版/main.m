#import <UIKit/UIKit.h>
#include <objc/runtime.h>
#include <dlfcn.h>
#define L 0x80000028
typedef struct{int c,s;}l;
static NSBundle*g;
id m(id s,SEL c){return g;}

int main(int a,char**v){
dlopen("@executable_path/Frameworks/YuriGameUI.dylib",1);

id u=NSUserDefaults.standardUserDefaults,s=[u stringForKey:@"selected"];
if(!s)return UIApplicationMain(a,v,nil,@"YiAppDelegate");
[u removeObjectForKey:@"selected"];

g=[NSBundle bundleWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/Applications/%@",s]];

class_replaceMethod(objc_getMetaClass("NSBundle"),@selector(mainBundle),(IMP)m,"@@:");

void*h=dlsym(dlopen(g.executablePath.UTF8String,1),"_mh_execute_header");
l*c=h+32;
while(c->c!=L)c=(void*)c+c->s;

return((int(*)(int,char**))((long)h+*(long*)((char*)c+8)))(a,v);
}