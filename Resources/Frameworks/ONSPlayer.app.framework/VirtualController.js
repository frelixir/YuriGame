window.addEventListener('load', function() {
//创建主键盘块元素
var mainKeyDiv = document.createElement("div")
mainKeyDiv.id="mainKeyDiv"
document.body.appendChild(mainKeyDiv)

//创建键盘元素
var div= 
'\
<div id="keySwitch"></div>\
<div id="bg">\
    <div id="upKey"></div>\
    <div id="leftKey"></div>\
    <div id="rightKey"></div>\
    <div id="downKey"></div>\
    <div id="leftupKey"></div>\
    <div id="leftdownKey"></div>\
    <div id="rightupKey"></div>\
    <div id="rightdownKey"></div>\
</div>\
<div id="bg2">\
    <div id="XKey"><div id="tX">X</div></div>\
    <div id="YKey"><div id="tY">Y</div></div>\
    <div id="AKey"><div id="tA">A</div></div>\
    <div id="BKey"><div id="tB">B</div></div>\
</div>\
'; 

document.getElementById('mainKeyDiv').innerHTML=div;


//按键2键码定义
var YKeyCode =115
var XKeyCode =17
var BKeyCode =88
var AKeyCode =90

//获取元素
var bg = document.getElementById('bg');
var upKey = document.getElementById('upKey');
var leftKey = document.getElementById('leftKey');
var rightKey = document.getElementById('rightKey');
var downKey = document.getElementById('downKey');
var leftupKey = document.getElementById('leftupKey');
var leftdownKey = document.getElementById('leftdownKey');
var rightupKey = document.getElementById('rightupKey');
var rightdownKey = document.getElementById('rightdownKey');

var bg2 = document.getElementById('bg2');
var YKey = document.getElementById('YKey');
var XKey = document.getElementById('XKey');
var BKey = document.getElementById('BKey');
var AKey = document.getElementById('AKey');


var tX = document.getElementById('tX');
var tY = document.getElementById('tY');
var tB = document.getElementById('tB');
var tA = document.getElementById('tA');
var keySwitch = document.getElementById('keySwitch');
var keySwitchStatus = true
//设置开关大小
keySwitch.style.width='50px'
keySwitch.style.height='50px'
//设置开关颜色
keySwitch.style.background='rgba(77, 114, 138, 0.459)'
//设置开关其他属性
keySwitch.style.float='left'
keySwitch.style.position='absolute'
keySwitch.style.borderRadius='50em'
keySwitch.style.color='rgb(255, 255, 255,0.300)'
keySwitch.style.textAlign='center'
keySwitch.style.lineHeight=keySwitch.style.height
keySwitch.innerHTML='Show'
//设置背景(整个键盘)大小
bgSize=200+'px'
bg.style.width=bgSize
bg.style.height=bgSize
//设置背景原点
bg.style.transform='translate(-0%,-100%)'
//设置背景(整个键盘)其他属性
bg.style.float='left'
bg.style.position='absolute'
bg.style.background='rgba(255, 247, 247, 0.300)'
bg.style.borderRadius='50em'
//设置背景(整个键盘)位置
bg.style.top=100+'%'
bg.style.left=0+'px'
//设置按键大小
keySize=32.33333333333333+'%'
upKey.style.width=keySize
upKey.style.height=keySize
leftKey.style.width=keySize
leftKey.style.height=keySize
rightKey.style.width=keySize
rightKey.style.height=keySize
downKey.style.width=keySize
downKey.style.height=keySize

leftupKey.style.width=keySize
leftupKey.style.height=keySize
leftdownKey.style.width=keySize
leftdownKey.style.height=keySize
rightupKey.style.width=keySize
rightupKey.style.height=keySize
rightdownKey.style.width=keySize
rightdownKey.style.height=keySize
//设置按键原点
upKey.style.transform='translate(-50%,-0%)'
leftKey.style.transform='translate(-0%,-50%)'
rightKey.style.transform='translate(-100%,-50%)'
downKey.style.transform='translate(-50%,-100%)'

leftupKey.style.transform='translate(-0%,-0%)'
leftdownKey.style.transform='translate(-0%,-100%)'
rightupKey.style.transform='translate(-100%,-0%)'
rightdownKey.style.transform='translate(-100%,-100%)'
//设置按键颜色
upKey.style.background='rgba(77, 114, 138, 0.459)'
leftKey.style.background='rgba(77, 114, 138, 0.459)'
rightKey.style.background='rgba(77, 114, 138, 0.459)'
downKey.style.background='rgba(77, 114, 138, 0.459)'
leftupKey.style.background='rgba(77, 114, 138, 0.459)'
leftdownKey.style.background='rgba(77, 114, 138, 0.459)'
rightupKey.style.background='rgba(77, 114, 138, 0.459)'
rightdownKey.style.background='rgba(77, 114, 138, 0.459)'
//设置按键其他属性
upKey.style.float='left'
leftKey.style.float='left'
rightKey.style.float='left'
downKey.style.float='left'
leftupKey.style.float='left'
leftdownKey.style.float='left'
rightupKey.style.float='left'
rightdownKey.style.float='left'

upKey.style.position='absolute'
leftKey.style.position='absolute'
rightKey.style.position='absolute'
downKey.style.position='absolute'
leftupKey.style.position='absolute'
leftdownKey.style.position='absolute'
rightupKey.style.position='absolute'
rightdownKey.style.position='absolute'
//设置按键圆角
radiusSize=1.1+'em'
upKey.style.borderTopLeftRadius=radiusSize
upKey.style.borderTopRightRadius=radiusSize
leftKey.style.borderTopLeftRadius=radiusSize
leftKey.style.borderBottomLeftRadius=radiusSize
rightKey.style.borderTopRightRadius=radiusSize
rightKey.style.borderBottomRightRadius=radiusSize
downKey.style.borderBottomLeftRadius=radiusSize
downKey.style.borderBottomRightRadius=radiusSize

leftupKey.style.borderTopLeftRadius=radiusSize
leftupKey.style.borderTopRightRadius=radiusSize
leftupKey.style.borderBottomLeftRadius=radiusSize
leftdownKey.style.borderBottomLeftRadius=radiusSize
leftdownKey.style.borderBottomRightRadius=radiusSize
leftdownKey.style.borderTopLeftRadius=radiusSize
rightupKey.style.borderTopRightRadius=radiusSize
rightupKey.style.borderTopLeftRadius=radiusSize
rightupKey.style.borderBottomRightRadius=radiusSize
rightdownKey.style.borderBottomRightRadius=radiusSize
rightdownKey.style.borderTopRightRadius=radiusSize
rightdownKey.style.borderBottomLeftRadius=radiusSize
//设置按键边框
upKey.style.borderStyle='solid'
leftKey.style.borderStyle='solid'
rightKey.style.borderStyle='solid'
downKey.style.borderStyle='solid'
leftupKey.style.borderStyle='solid'
leftdownKey.style.borderStyle='solid'
rightupKey.style.borderStyle='solid'
rightdownKey.style.borderStyle='solid'

upKey.style.borderColor='rgb(160, 160, 160)'
leftKey.style.borderColor='rgb(160, 160, 160)'
rightKey.style.borderColor='rgb(160, 160, 160)'
downKey.style.borderColor='rgb(160, 160, 160)'
leftupKey.style.borderColor='rgb(160, 160, 160)'
leftdownKey.style.borderColor='rgb(160, 160, 160)'
rightupKey.style.borderColor='rgb(160, 160, 160)'
rightdownKey.style.borderColor='rgb(160, 160, 160)'
//设置按键位置
upKey.style.left='50%'
upKey.style.top='0%'
leftKey.style.left='0%'
leftKey.style.top='50%'
rightKey.style.left='100%'
rightKey.style.top='50%'
downKey.style.left='50%'
downKey.style.top='100%'
leftupKey.style.left='0%'
leftupKey.style.top='0%'
leftdownKey.style.left='0%'
leftdownKey.style.top='100%'
rightupKey.style.left='100%'
rightupKey.style.top='0%'
rightdownKey.style.left='100%'
rightdownKey.style.top='100%'
//设置背景2(整个键盘)大小
bg2.style.width=bgSize
bg2.style.height=bgSize
//设置背景2原点
bg2.style.transform='translate(-100%,-100%)'
//设置背景2(整个键盘)其他属性
bg2.style.float='left'
bg2.style.position='absolute'
//设置背景2(整个键盘)位置
bg2.style.top=100+'%'
bg2.style.left=100+'%'
//设置按键2大小
keySize2=33.33333333333333+'%'
XKey.style.width=keySize2
XKey.style.height=keySize2
YKey.style.width=keySize2
YKey.style.height=keySize2
AKey.style.width=keySize2
AKey.style.height=keySize2
BKey.style.width=keySize2
BKey.style.height=keySize2
//设置按键2原点
YKey.style.transform='translate(-50%,-0%)'
XKey.style.transform='translate(-0%,-50%)'
BKey.style.transform='translate(-100%,-50%)'
AKey.style.transform='translate(-50%,-100%)'
//设置按键2颜色
YKey.style.background='rgba(77, 114, 138, 0.459)'
XKey.style.background='rgba(77, 114, 138, 0.459)'
BKey.style.background='rgba(77, 114, 138, 0.459)'
AKey.style.background='rgba(77, 114, 138, 0.459)'
//设置按键字体属性
tY.style.color='rgb(255, 255, 255)'
tX.style.color='rgb(255, 255, 255)'
tB.style.color='rgb(255, 255, 255)'
tA.style.color='rgb(255, 255, 255)'
tY.style.float='left'
tX.style.float='left'
tB.style.float='left'
tA.style.float='left'
tY.style.position='absolute'
tX.style.position='absolute'
tB.style.position='absolute'
tA.style.position='absolute'
tY.style.transform='translate(-50%,-50%)'
tX.style.transform='translate(-50%,-50%)'
tB.style.transform='translate(-50%,-50%)'
tA.style.transform='translate(-50%,-50%)'
//设置按键文本位置
tY.style.top='50%'
tY.style.left='50%'
tX.style.top='50%'
tX.style.left='50%'
tB.style.top='50%'
tB.style.left='50%'
tA.style.top='50%'
tA.style.left='50%'
//设置按键2其他属性
YKey.style.float='left'
XKey.style.float='left'
BKey.style.float='left'
AKey.style.float='left'
YKey.style.position='absolute'
XKey.style.position='absolute'
BKey.style.position='absolute'
AKey.style.position='absolute'
//设置按键2圆角
radiusSize2=50+'em'
YKey.style.borderRadius=radiusSize2
XKey.style.borderRadius=radiusSize2
BKey.style.borderRadius=radiusSize2
AKey.style.borderRadius=radiusSize2
//设置按键边框
YKey.style.borderStyle='solid'
XKey.style.borderStyle='solid'
BKey.style.borderStyle='solid'
AKey.style.borderStyle='solid'

YKey.style.borderColor='rgb(160, 160, 160)'
XKey.style.borderColor='rgb(160, 160, 160)'
BKey.style.borderColor='rgb(160, 160, 160)'
AKey.style.borderColor='rgb(160, 160, 160)'

//设置按键2位置
YKey.style.left='50%'
YKey.style.top='0%'
XKey.style.left='0%'
XKey.style.top='50%'
BKey.style.left='100%'
BKey.style.top='50%'
AKey.style.left='50%'
AKey.style.top='100%'

//设置各按键层级
bg.style.zIndex=2147483647 
upKey.style.zIndex=2147483647 
leftKey.style.zIndex=2147483647 
rightKey.style.zIndex=2147483647 
downKey.style.zIndex=2147483647 
bg2.style.zIndex=2147483647 
YKey.style.zIndex=2147483647 
XKey.style.zIndex=2147483647 
BKey.style.zIndex=2147483647 
AKey.style.zIndex=2147483647 
tX.style.zIndex=2147483647 
tY.style.zIndex=2147483647 
tB.style.zIndex=2147483647 
tA.style.zIndex=2147483647 
keySwitch.style.zIndex=2147483647 
//js部分
////模拟键盘按键
function Akeys(el,keyCode,keyType) {   
    evtObj = document.createEvent('UIEvents');  

    Object.defineProperty(evtObj, 'keyCode', {  
        get : function() { return this.keyCodeVal; }  
    })   

    Object.defineProperty(evtObj, 'which', {  
        get : function() { return this.keyCodeVal; }  
    });  
    evtObj.initUIEvent( keyType, true, true, window, 1 );  
    evtObj.keyCodeVal = keyCode; 
    el.dispatchEvent(evtObj);  
}
////按键互动颜色方法
function startColor(element) {
    element.style.background='rgba(33, 61, 114, 0.459)'
}
function endColor(element) {
    element.style.background='rgba(77, 114, 138, 0.459)'
}
////手机震动方法
function vibrate() {
    if('vibrate' in window.navigator) {
        window.navigator.vibrate(100); 
    }else {
        console.log("浏览器不支持震动")
    }
}

////按键事件
upKey.ontouchstart = function(){
    event.stopPropagation()
    startColor(this) 
    vibrate()
    Akeys(this,38,'keydown')
}
upKey.ontouchend = function(){
    endColor(this)
    Akeys(this,38,'keyup')
}
leftKey.ontouchstart = function(){
    event.stopPropagation()
    startColor(this) 
    vibrate()
    Akeys(this,37,'keydown')

}
leftKey.ontouchend = function(){
    endColor(this)
    Akeys(this,37,'keyup')
}
rightKey.ontouchstart = function(){
    event.stopPropagation()
    startColor(this) 
    vibrate()
    Akeys(this,39,'keydown')
}
rightKey.ontouchend = function(){
    endColor(this)
    Akeys(this,39,'keyup')
}
downKey.ontouchstart = function(){
    event.stopPropagation()
    startColor(this) 
    vibrate()
    Akeys(this,40,'keydown')
}
downKey.ontouchend = function(){
    endColor(this)
    Akeys(this,40,'keyup')
}
////按键2事件
YKey.ontouchstart = function(){
    event.stopPropagation()
    startColor(this) 
    vibrate()
    Akeys(this,YKeyCode,'keydown')
}
YKey.ontouchend = function(){
    endColor(this)
    Akeys(this,YKeyCode,'keyup')
}
XKey.ontouchstart = function(){
    event.stopPropagation()
    startColor(this) 
    vibrate()
    Akeys(this,XKeyCode,'keydown')

}
XKey.ontouchend = function(){
    endColor(this)
    Akeys(this,XKeyCode,'keyup')
}
BKey.ontouchstart = function(){
    event.stopPropagation()
    startColor(this) 
    vibrate()
    Akeys(this,BKeyCode,'keydown')
}
BKey.ontouchend = function(){
    endColor(this)
    Akeys(this,BKeyCode,'keyup')
}
AKey.ontouchstart = function(){
    event.stopPropagation()
    startColor(this) 
    vibrate()
    Akeys(this,AKeyCode,'keydown')
}
AKey.ontouchend = function(){
    endColor(this)
    Akeys(this,AKeyCode,'keyup')
}
keySwitch.ontouchstart = function(){
    event.stopPropagation()
    startColor(this) 
    vibrate()       
    if (keySwitchStatus==true) {
            bg.style.display='none'
            bg2.style.display='none'
            keySwitchStatus=false
        } else {
            bg.style.display='block'
            bg2.style.display='block'
            keySwitchStatus=true
        }

}
keySwitch.ontouchend = function(){
    endColor(this)
    Akeys(this,AKeyCode,'keyup')
}
// leftupKey
// leftdownKey
// rightupKey
// rightdownKey
leftupKey.ontouchstart = function(){
    event.stopPropagation()
    startColor(this) 
    vibrate()
    Akeys(this,38,'keydown')
    Akeys(this,37,'keydown')
}
leftupKey.ontouchend = function(){
    endColor(this)
    Akeys(this,38,'keyup')
    Akeys(this,37,'keyup')
}
leftdownKey.ontouchstart = function(){
    event.stopPropagation()
    startColor(this) 
    vibrate()
    Akeys(this,37,'keydown')
    Akeys(this,40,'keydown')

}
leftdownKey.ontouchend = function(){
    endColor(this)
    Akeys(this,37,'keyup')
    Akeys(this,40,'keyup')
}
rightupKey.ontouchstart = function(){
    event.stopPropagation()
    startColor(this) 
    vibrate()
    Akeys(this,39,'keydown')
    Akeys(this,38,'keydown')
}
rightupKey.ontouchend = function(){
    endColor(this)
    Akeys(this,39,'keyup')
    Akeys(this,38,'keyup')
}
rightdownKey.ontouchstart = function(){
    event.stopPropagation()
    startColor(this) 
    vibrate()
    Akeys(this,40,'keydown')
    Akeys(this,39,'keydown')
}
rightdownKey.ontouchend = function(){
    endColor(this)
    Akeys(this,40,'keyup')
    Akeys(this,39,'keyup')
}
bg.ontouchstart = function(){
    event.stopPropagation()

}
})
