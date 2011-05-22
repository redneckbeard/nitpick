class this.ColorPicker extends Backbone.View
    tagName: "div"
    className: "colorpicker"

    events: 
        "mousedown div.colorpicker_hue": "downHue"
        "mousedown div.colorpicker_color": "downSelector"
        "change input": "change"
        "keyup div.colorpicker_rgb_a input": "changeAlpha"
        "click div.button_wrap a": "clearOpacity"

    hsb: {h: 0, s: 0, b: 0}

    render: =>
        _template = _.template template
        $(@el).html (_template {r: 255, g: 255, b: 255, a: 100, hex: 'ffffff', disabled: false })
        @

    # Conversion methods to and from base-10 RGB, hex RGB, and HSB.

    # All aspects of the color picker (palette, hue bar, rgb fields, hex field,
    # and status button) need setter methods.
    setPalette: =>
        hsb = @hsb
        @$('div.colorpicker_color').css 'backgroundColor', '#' + (ColorMath.hsbToHex {h: hsb.h, s: 100, b: 100})
        @$('div.colorpicker_color div div').css {
            left: parseInt 150 * hsb.s/100, 10
            top: parseInt 150 * (100-hsb.b)/100, 10
        }

    setHue: =>
        hsb = @hsb
        @$('div.colorpicker_hue div').css 'top', (parseInt 150 - 150 * hsb.h/360, 10)


    getRGB: =>
        rgb_row = @$ 'div.rgb_row input'
        {
            r: parseInt(rgb_row.eq(0).val(), 10)
            g: parseInt(rgb_row.eq(1).val(), 10)
            b: parseInt(rgb_row.eq(2).val(),  10)
        }

    setRGB: =>
        rgb = ColorMath.hsbToRGB @hsb
        @$('div.rgb_row input')
            .eq(0).val(rgb.r).end()
            .eq(1).val(rgb.g).end()
            .eq(2).val(rgb.b).end()

    setHex: =>
        @$('div.colorpicker_hex input').val(ColorMath.hsbToHex @hsb)

    change: (e) =>
        target = $ e.target
        targetClass = target.attr 'class' 
        if targetClass == 'hex'
            @hsb = ColorMath.hexToHSB target.val()
        else if targetClass == "rgb"
            @hsb = ColorMath.rgbToHSB @getRGB()
        @setRGB()
        @setHex()
        @setPalette()
        @setHue()
        # callback

    downHue: (e) =>
        e.preventDefault()
        current = 
            y: $(e.target).offset().top
        $(document).bind 'mouseup', current, @upHue
        $(document).bind 'mousemove', current, @moveHue
    
    moveHue: (e) =>
        e.preventDefault()
        @hsb.h = parseInt 360*((150 - (Math.max 0, (Math.min 150, e.pageY - e.data.y)))/150), 10
        @change e
    
    upHue: (e) =>
        e.preventDefault()
        @setRGB()
        @setHex()
        $(document).unbind 'mouseup', @upHue
        $(document).unbind 'mousemove', @moveHue

    downSelector: (e) =>
        e.preventDefault()
        current =
            pos: $(e.target).offset()
        $(document).bind 'mouseup', current, @upSelector
        $(document).bind 'mousemove', current, @moveSelector
    
    moveSelector: (e) =>
        e.preventDefault()
        @hsb.b = parseInt 100*((150 - (Math.max 0, Math.min(150, e.pageY - e.data.pos.top)))/150), 10
        @hsb.s = parseInt 100*(Math.max 0, Math.min(150, e.pageX - e.data.pos.left))/150, 10
        @change e
    
    upSelector: (e) =>
        e.preventDefault()
        @setRGB()
        @setHex()
        $(document).unbind 'mouseup', @upSelector
        $(document).unbind 'mousemove', @moveSelector

    changeAlpha: (e) =>
        alpha = Number $(e.target).val()
        key_code = e.keyCode
        if key_code in [38, 40]
            adjusted = true
            if key_code == 38
                alpha += 1
            else if key_code == 40
                alpha -= 1
        if alpha > 100
            alpha = 100
        else if alpha < 0
            alpha = 0
        if adjusted?
            $(e.target).val alpha 
        @$("div.alpha_channel").fadeTo 0, (100 - alpha) / 100

    clearOpacity: (e) =>
        e.preventDefault() 
        @$("div.colorpicker_rgb_a input").val("0").trigger("keyup")
