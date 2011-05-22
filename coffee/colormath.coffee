class this.ColorMath
    @hexToRGB = (hex) ->
        hex = parseInt (if hex.indexOf '#' > -1 then hex.substring 1 else hex), 16
        {
            r: hex >> 16
            g: (hex & 0x00FF00) >> 8
            b: hex & 0x0000FF
        }
    
    @hexToHSB = (hex) ->
        return @rgbToHSB(@hexToRGB hex)
    
    @rgbToHSB = (rgb) ->
        hsb =
            h: 0
            s: 0
            b: 0
        min = Math.min rgb.r, rgb.g, rgb.b
        max = Math.max rgb.r, rgb.g, rgb.b
        delta = max - min
        hsb.b = max
        hsb.s = if max != 0 then 255 * delta / max else 0
        if hsb.s != 0
            if rgb.r == max
                hsb.h = (rgb.g - rgb.b) / delta
            else if rgb.g == max
                hsb.h = 2 + (rgb.b - rgb.r) / delta
            else
                hsb.h = 4 + (rgb.r - rgb.g) / delta
        else
            hsb.h = -1
        hsb.h *= 60
        if hsb.h < 0
            hsb.h += 360
        hsb.s *= 100/255
        hsb.b *= 100/255
        hsb
    
    @hsbToRGB = (hsb) ->
        rgb = {}
        h = Math.round hsb.h
        s = Math.round hsb.s * 255/100
        v = Math.round hsb.b * 255/100
        if s == 0
            rgb.r = rgb.g = rgb.b = v
        else
            t1 = v
            t2 = (255 - s) * v / 255
            t3 = (t1 - t2) * (h % 60) / 60
            if h == 360
                h = 0
            if h < 60
                rgb.r = t1
                rgb.b = t2
                rgb.g = t2 + t3
            else if h < 120
                rgb.g = t1
                rgb.b = t2
                rgb.r = t1 - t3
            else if h < 180
                rgb.g = t1
                rgb.r = t2
                rgb.b = t2 + t3
            else if h < 240
                rgb.b = t1
                rgb.r = t2
                rgb.g = t1 - t3
            else if h < 300
                rgb.b = t1
                rgb.g = t2
                rgb.r = t2 + t3
            else if h < 360
                rgb.r = t1
                rgb.g = t2
                rgb.b = t1 - t3
            else
                rgb.r = 0
                rgb.g = 0
                rgb.b = 0
        {
            r: Math.round rgb.r
            g: Math.round rgb.g
            b: Math.round rgb.b
        }

    @hsbToHex = (hsb) ->
        @rgbToHex(@hsbToRGB hsb)

    
    @rgbToHex = (rgb) ->
        hex = [
            rgb.r.toString(16)
            rgb.g.toString(16)
            rgb.b.toString(16)
        ]

        $.each hex, (nr, val) ->
            if val.length == 1
                hex[nr] = '0' + val

        hex.join ''
