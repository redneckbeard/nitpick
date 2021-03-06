template = """
<div class="nitpicker_nav">
    <a class="nitpicker_accept" href="#">&#x2714;</a>
    <a class="nitpicker_cancel" href="#">&#x2718;</a>
</div>
<div class="nitpicker_color" style="background-color: rgb(255, 0, 0); ">
    <div>
        <div></div>
    </div>
    <div class="alpha_channel"></div>
</div>

<div class="nitpicker_hue">
    <div style="top: 150px; ">
    </div>
</div>

<div class="nitpicker_fields">
    <div class="rgb_row">
        <div class="nitpicker_rgb_r">
        <label>R</label>
        <input class="rgb" type="text" maxlength="3" size="3" value="<%= r %>" />
        </div>
        <div class="nitpicker_rgb_g">
        <label>G</label>
        <input class="rgb" type="text" maxlength="3" size="3" value="<%= g %>" />
        </div>
        <div class="nitpicker_rgb_b">
        <label>B</label>
        <input class="rgb" type="text" maxlength="3" size="3" value="<%= b %>" />
        </div>
        <div class="nitpicker_rgb_a">
        <label>A</label>
        <input class="rgb" type="text" maxlength="3" size="3" value="<%= a %>" /><label>%</label>
        </div>
    </div>

    <div class="hex_row">
        <div class="button_wrap">
        <a href="#"></a>
        </div>
        <div>
            <label>#</label>
            <input class="hex" type="text" maxlength="6" size="6" value="<%= hex %>">
        </div>
    </div>

    </div>
</div>
"""

