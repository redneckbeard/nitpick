
class Proxy extends Backbone.Events


class this.NitPicker extends Backbone.View
    tagName: "div"
    className: "nitpicker"

    events:
        "mousedown div.nitpicker_hue": "downHue"
        "mousedown div.nitpicker_color": "downSelector"
        "change input": "change"
        "keyup div.nitpicker_rgb_a input": "changeAlpha"
        "click div.button_wrap a": "clearOpacity"
        "click a.nitpicker_cancel": "cancel"
        "click a.nitpicker_accept": "accept"

    onChange: ->

    onCancel: ->

    onAccept: ->

    initialize: ->
        {r, g, b, a, button} = @options
        @hsb = ColorMath.rgbToHSB {r, g, b}
        @original_hsb = _.clone @hsb
        @original_alpha = @alpha = a
        @button = button
        @button.addClass("nitpicker-widget").html """
            <div class="content">
                <div class="transparency"></div>
            </div>
            <div class="frame"></div>"""
        $(@button).click @open
        @render()
        @$("div.nitpicker_rgb_a input").val(a).trigger "keyup"
        $("body").append @el
        @close()
        Proxy.bind "open", (sender) =>
            if @open and sender isnt @
                @cancel true

    open: (e) =>
        if e
            e.preventDefault()
        target = e.target
        pos = $(target).offset()
        m = document.compatMode is 'CSS1Compat'
        viewPort =
            l: window.pageXOffset or (if m then document.documentElement.scrollLeft else document.body.scrollLeft)
            t: window.pageYOffset or (if m then document.documentElement.scrollTop else document.body.scrollTop)
            w: window.innerWidth or (if m then document.documentElement.clientWidth else document.body.clientWidth)
            h: window.innerHeight or (if m then document.documentElement.clientHeight else document.body.clientHeight)
        top = pos.top + target.offsetHeight
        left = pos.left
        if top + 175 > viewPort.t + viewPort.h
            top -= target.offsetHeight + 175
        if left + 320 > viewPort.l + viewPort.w
            left -= 320
        $(@el).css {left: left + 'px', top: top + 'px'}
        $(@el).show()
        Proxy.trigger "open", @
        @open = true
        ($ document).bind "mousedown", @blur
    
    close: =>
        $(@el).hide()
        @open = false

    cancel: (e) =>
        hsb = @hsb
        hsb = _.extend {}, @original_hsb
        @$("div.nitpicker_rgb_a input").val(@original_alpha).trigger "keyup"
        @alpha = @original_alpha
        console.log hsb, @original_hsb
        @hsb = hsb
        @change e
        @close()

    accept: =>
        @original_hsb = _.clone @hsb
        @original_alpha = @$("div.nitpicker_rgb_a input").val()
        @close()
        @onAccept.call @, @getRGB(), (ColorMath.hsbToHex @hsb), @alpha

    blur: (e) =>
        target = e.target
        el = @el
        if target isnt el and $(el).find(target).length is 0
            ($ document).unbind "mousedown"
            @close()
        

    render: =>
        _template = _.template template
        context = ColorMath.hsbToRGB @hsb
        context.hex = ColorMath.hsbToHex @hsb
        context.a = @original_alpha
        $(@el).html (_template context)
        @change()
        @

    setPalette: =>
        hsb = @hsb
        @$('div.nitpicker_color').css 'backgroundColor', '#' + (ColorMath.hsbToHex {h: hsb.h, s: 100, b: 100})
        @$('div.nitpicker_color div div').css {
            left: parseInt 150 * hsb.s/100, 10
            top: parseInt 150 * (100-hsb.b)/100, 10
        }
        @button.find('div.content').css {backgroundColor: '#' + @$('input.hex').val()}

    setHue: =>
        hsb = @hsb
        @$('div.nitpicker_hue div').css 'top', (parseInt 150 - 150 * hsb.h/360, 10)


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
        @$('input.hex').val(ColorMath.hsbToHex @hsb)

    change: (e) =>
        if e
            target = $ e.target
            targetClass = target.attr 'class' 
            if targetClass is 'hex'
                @hsb = ColorMath.hexToHSB target.val()
            else if targetClass is "rgb"
                @hsb = ColorMath.rgbToHSB @getRGB()
        @setRGB()
        @setHex()
        @setPalette()
        @setHue()
        if e
            @onChange.call @, @getRGB(), (ColorMath.hsbToHex @hsb), @alpha

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
            if key_code is 38
                alpha += 1
            else if key_code is 40
                alpha -= 1
        if alpha > 100
            alpha = 100
        else if alpha < 0
            alpha = 0
        if adjusted?
            $(e.target).val alpha
        @alpha = alpha
        @$("div.alpha_channel").fadeTo 0, (100 - alpha) / 100
        if alpha is 0
            @button.find('div.content').addClass "disabled"
            @button.find("div.transparency").fadeTo 0, 0
        else
            @button.find('div.content').removeClass "disabled"
            @button.find("div.transparency").fadeTo 0, (100 - alpha) / 100
        @change e

    clearOpacity: (e) =>
        e.preventDefault()
        @$("div.nitpicker_rgb_a input").val("0").trigger "keyup"
