require 'vips'

def rgb_to_hsv(input_image)
    pixels = input_image.to_a
    width = input_image.width
    height = input_image.height
    new_h_pixels = []
    new_s_pixels = []
    new_v_pixels = []

    r = nil
    g = nil
    b = nil

    h = nil
    s = nil
    v = nil

    _max = nil
    _min = nil

    (0..height - 1).each do |y|
        h_line = []
        s_line = []
        v_line = []
        (0..width - 1).each do |x|
            r = (pixels[y][x][0].to_f / 255).to_f
            g = (pixels[y][x][1].to_f / 255).to_f
            b = (pixels[y][x][2].to_f / 255).to_f

            _max = [r, g, b].max
            _min = [r, g, b].min

            # get Hue
            if _max == _min
                h = 0
            elsif _min == r
                h = 60 * (b - g) / (_max - _min) + 180
            elsif _min == g
                h = 60 * (r - b) / (_max - _min) + 300
            elsif _min == b
                h = 60 * (g - r) / (_max - _min) + 60
            end

            # get Saturation
            s = _max - _min

            # get Value
            v = _max

            h_line.push(h)
            s_line.push(s)
            v_line.push(v)
        end
        new_h_pixels.push(h_line)
        new_s_pixels.push(s_line)
        new_v_pixels.push(v_line)
    end

    Vips::Image.bandjoin([new_h_pixels, new_s_pixels, new_v_pixels])
end

def hsv_to_rgb(input_image)
    pixels = input_image.to_a
    width = input_image.width
    height = input_image.height
    new_r_pixels = []
    new_g_pixels = []
    new_b_pixels = []

    h = nil
    s = nil
    v = nil

    c = nil
    _h = nil
    _x = nil

    r = nil
    g = nil
    b = nil

    (0..height - 1).each do |y|
        r_line = []
        g_line = []
        b_line = []
        (0..width - 1).each do |x|
            h = pixels[y][x][0].to_f
            s = pixels[y][x][1].to_f
            v = pixels[y][x][2].to_f

            c = s
            _h = h / 60
            
            _x = c * (1 - ((_h % 2) - 1).abs)

            r = g = b = v - c
            
            if (_h < 1)
                r += c
                g += _x
            elsif (_h < 2)
                r += _x
                g += c
            elsif (_h < 3)
                g += c
                b += _x
            elsif (_h < 4)
                g += _x
                b += c
            elsif (_h < 5)
                r += _x
                b += c
            elsif (_h < 6)
                r += c
                b += _x
            end

            r_line.push(r*255)
            g_line.push(g*255)
            b_line.push(b*255)
        end
        new_r_pixels.push(r_line)
        new_g_pixels.push(g_line)
        new_b_pixels.push(b_line)
    end

    Vips::Image.bandjoin([new_r_pixels, new_b_pixels, new_b_pixels])
end

def inverse_hue(input_image)
    pixels = input_image.to_a
    width = input_image.width
    height = input_image.height
    new_h_pixels = []
    new_s_pixels = []
    new_v_pixels = []

    (0..height - 1).each do |y|
        h_line = []
        s_line = []
        v_line = []
        (0..width - 1).each do |x|
            h_line.push((pixels[y][x][0].to_f + 180) % 360)
            s_line.push(pixels[y][x][1].to_f)
            v_line.push(pixels[y][x][2].to_f)
        end
        new_h_pixels.push(h_line)
        new_s_pixels.push(s_line)
        new_v_pixels.push(v_line)
    end

    Vips::Image.bandjoin([new_h_pixels, new_s_pixels, new_v_pixels])
end


input_image = Vips::Image.new_from_file('../lenna.png')
hsv = rgb_to_hsv(input_image)
hsv = inverse_hue(hsv)
convert_image = hsv_to_rgb(hsv)
convert_image.write_to_file('section_5_output.png')