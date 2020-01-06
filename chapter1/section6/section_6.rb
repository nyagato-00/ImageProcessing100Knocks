require 'vips'

def decrease_color(input_image)
    pixels = input_image.to_a
    width = input_image.width
    height = input_image.height
    bands = input_image.bands

    new_r_pixels = []
    new_g_pixels = []
    new_b_pixels = []

    (0..height - 1).each do |y|
        r_line = []
        g_line = []
        b_line = []
        (0..width - 1).each do |x|
            (0..bands - 1).each do |band|
                if band == 0
                    r_line.push(((pixels[y][x][band] / 64) * 64 + 32).floor)
                elsif band == 1
                    g_line.push(((pixels[y][x][band] / 64) * 64 + 32).floor)
                else
                    b_line.push(((pixels[y][x][band] / 64) * 64 + 32).floor)
                end
            end
        end
        new_r_pixels.push(r_line)
        new_g_pixels.push(g_line)
        new_b_pixels.push(b_line)
    end

    Vips::Image.bandjoin([new_r_pixels, new_b_pixels, new_b_pixels])
end


input_image = Vips::Image.new_from_file('../lenna.png')
convert_image = decrease_color(input_image)
convert_image.write_to_file('section_6_output.png')