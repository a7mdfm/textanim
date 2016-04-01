Can convert the blocks to bitmap, set patterns, gradient. [Read more](http://flupie.net/textanim/docs/flupie/textanim/TextAnimTools.html).

# Examples #

### toBitmap ###
Converts each block of a TextAnim to bitmap, smoothed or not:
```
var txtanim:TextAnim = new TextAnim(myTextField);
TextAnimTools.toBitmap(txtanim, true);
txtanim.split = TextAnimSplit.LINES;
txtanim.effects = jump;
txtanim.start();
```


### setPattern ###
Applies an image (movieclip, bitmap, etc.) as texture. This sample spent more than a function like effect, you can pass an array with as many effects as you want.
```
var txtanim:TextAnim = new TextAnim(myTextField);
TextAnimTools.setPattern(txtanim, new MyPattern());
anim.mode = TextAnimMode.CENTER_EDGES;
txtanim.effects = [alphaIn, scaleIn];
txtanim.interval = 200;
txtanim.start();
```

### setGradientLinear ###
Prints in text a linear gradient with many colors as you want. This example is experiencing a delay to start the animation in the start method. And multiple effects.
```
var txtanim:TextAnim = TextAnim.create(myTextField, {effects:otherEffect});
TextAnimTools.setGradientLinear(txtanim, [0x000000, 0xFF0000], 180);
txtanim.start(2000);
```