require 'vips'
require "pry"

def average_pooling(input_image)
    pixels = input_image.to_a
    width = input_image.width
    height = input_image.height
    bands = input_image.bands
    channels = input_image.bandsplit

    r = 4

    new_r_pixels = channels[0].to_a
    new_g_pixels = channels[1].to_a
    new_b_pixels = channels[2].to_a

    (0..height - 1).each do |y|
        r_line = []
        g_line = []
        b_line = []
        (0..width - 1).each do |x|
            (0..bands - 1).each do |band|
                r_v = 0
                g_v = 0
                b_v = 0
                (0..r - 1).each do |dy|
                    (0..r - 1).each do |dx|
                        iy = (y + dy).to_i
                        ix = (x + dx).to_i
                        break if (ix) >= 512 || (iy) >= 512
                        
                        if band == 0
                            r_v += new_r_pixels[iy][ix][0]
                        elsif band == 1
                            g_v += new_g_pixels[iy][ix][0]
                        else
                            b_v += new_b_pixels[iy][ix][0]
                        end
                    end
                end

                # p "band:#{band}, r_v:#{r_v}, g_v:#{g_v}, b_v:#{b_v}, r:#{r}, result:#{r_v /= (r * r)}"

                r_v /= (r * r)
                g_v /= (r * r)
                b_v /= (r * r)

                (0..r - 1).each do |dy2|
                    (0..r - 1).each do |dx2|
                        iy = (y + dy2).to_i
                        ix = (x + dx2).to_i
                        break if (ix) >= 512 || (iy) >= 512

                        if band == 0
                            new_r_pixels[iy][ix][0] = r_v
                        elsif band == 1
                            new_g_pixels[iy][ix][0] = g_v
                        else
                            new_b_pixels[iy][ix][0] = b_v
                        end
                    end
                end
            end
        end
    end

    Vips::Image.bandjoin([new_r_pixels, new_b_pixels, new_b_pixels])
end

input_image = Vips::Image.new_from_file('../lenna.png')
convert_image = average_pooling(input_image)
convert_image.write_to_file('section_7_output.png')
