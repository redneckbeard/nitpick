# Nitpick: a choosey color chooser # 

Nitpick is essentially a refactor and port to CoffeeScript of the [jQuery
ColorPicker plugin](http://www.eyecon.ro/colorpicker/) by Stefan Petre.  We
used this plugin for a long time and felt that it was the best around.  All of
the color math in colormath.coffee, the overall architecture of events, and
several of the images are a direct port. However, there were some itches that
we just had to scratch:

* We really didn't feel like HSB fields were really necessary.  This is the
web, not Photoshop.
* Since RGBa support has got quite good, we wanted that baked in.
* Stefan's example page shows a little "click-me" widget that reflects the
currently selected color.  We wanted to make this a default, rather than
something that has an example of how to wire up.
* There were a lot of very tangled chains of events in the original.  We
rebuilt it using Backbone.js to make it more hackable and easier to read
through.
* The original is prettier than ours, but has loads of background images that
could really just be HTML + CSS.  So we changed that.  If you want it
prettier, just style it.
* We wanted the "Yes, I want this color" to be a little clearer than the
colorwheel icon that ColorPicker uses.

## Installation ##

Nitpick has several dependencies: jQuery, Backbone.js, and underscore.js.  Get
those first.  Then:

    git clone https://github.com/threadsafelabs/nitpick.git

Copy nitpick/js/nitpick.(min.)?.js to your project, along with
nitpick/css/nitpick.css and the contents of nitpick/img/.  You may need to
modify nitpick.css to ensure that paths to background images are correct.

## Usage ##

Nitpick is a Backbone.js view.  To instantiate it, we give it an element to
turn into the button widget and the initial RGBa values.

        new NitPicker({button: $("div#colorButton"), r: 139, g: 82, b: 56, a: 100})


Presumably, you want to override some of the available callbacks (`onChange`,
`onAccept`, `onCancel`).  Backbone lets us do this nicely with `extend`. You
can then just instantiate this class in the same manner as you would
`NitPicker`.

    var PickierPicker = NitPicker.extend({
        onChange: function (rgb, hex, alpha) { ... },
        onCancel: function (rgb, hex, alpha) { ... },
        onAccept: function (rgb, hex, alpha) { ... }
    });

The signature for all three callbacks is the same:

* `rgb` is an object with properties `r`, `g`, and `b`, all numbers from 0 to
255;
* `hex` is a 6-character string (not prefixed with "#");
* `alpha` is a value from 0 to 100 -- **NOT** from 0.0 to 1.0.

## Building from source ##

If you want to hack on Nitpick, you will need to install, in this order:

* Node.js
* NPM
* `sudo npm install -g coffee-script`
* `sudo npm install -g uglifyjs`

A Cake file is provide that concatenates the three `.coffee` files, compiles
them to JavaScript as `js/nitpick.js`, and additional produces a minified
version using uglify-js.
