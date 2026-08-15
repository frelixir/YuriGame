#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <dlfcn.h>
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
struct{int c,s;}*c=(void*)h+32;
while(c->c!=0x80000028)c=(void*)c+c->s;

return((int(*)(int,char**))((long)h+*(long*)((char*)c+8)))(a,v);
}