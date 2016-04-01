## What is? ##
The TextAnim is an open source code for [dynamic text animation in Flash - ActionScript 3](http://flupie.net/textanim/maker/), it's events based and tween engine independent.

## How does it work? ##
The library has **no ready-made animation**, the idea is only break apart the TextField (split TextField) and dispatch blocks sequence, to be free to make the animation you want. Doesn't matter which **tween engine** that you like: Tweener, BTween, GTween, Tweensy, TweenLite (...)

Just don't forget to **embed the font** that you want to use.

**Example 1:**
```
import flupie.textanim.*;

var myTextAnim:TextAnim = new TextAnim(myTextField);
myTextAnim.effects = myEffect;
myTextAnim.blocksVisible = false;
myTextAnim.start();

function myEffect(block:TextAnimBlock):void
{
    block.alpha = 0;
    Tweener.addTween(block, {alpha:1, time:.5});
}
```

**Example 2:**
```
TextAnim.create(myTextField, {effects:myEffect, split:TextAnimSplit.WORDS}).start();
```

**Example 3:**
```
var myTextAnim:TextAnim = new TextAnim(myTextField);
myTextAnim.effects = myEffect;
myTextAnim.mode = TextAnimMode.LAST_FIRST;

myTextAnim.addEventListener(TextAnimEvent.START, onStartHandler);
myTextAnim.start();
```

**split** - To specify how the TextAnim will break the text. [TextAnimSplit](http://flupie.net/textanim/docs/flupie/textanim/TextAnimSplit.html):
  * CHARS
  * WORDS
  * LINES

**mode** - Is the way of the effects dispatches will be occurs. TextAnim dispatch effects in five diferent ways. [TextAnimMode](http://flupie.net/textanim/docs/flupie/textanim/TextAnimMode.html):
  * FIRST\_LAST
  * LAST\_FIRST
  * EDGES\_CENTER
  * CENTER\_EDGES
  * RANDOM

## Tools ##
Extra tools for special treatment of TextAnim instance. Can convert the blocks to bitmap, apply patterns, etc. Are static functions to implement some useful things. Get more here TextAnimTools.

  * getColorBounds
  * setGradientLinear
  * setPattern
  * showAnchors
  * toBitmap
  * toVector

## More ##

You can download the [latest stable version](http://code.google.com/p/textanim/downloads/list) of TextAnim, check out [Flupie blog](http://flupie.net/blog/) to get a few examples with source, read the [documentation](http://flupie.net/textanim/docs/) or get TextAnim code generator, called [TextAnim Maker](http://flupie.net/textanim/maker/).

All examples was made with the IDE Flash CS4, but everything has been properly tested in other environments, Flex, Flash Builder, mxmlc command line, FDT.

[Examples repository](http://textanim.googlecode.com/svn/trunk/example/)