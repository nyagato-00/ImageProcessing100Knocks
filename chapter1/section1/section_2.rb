require 'vips'

# Convert a color image to a grayscale image
# How to calculate grayscale value
# Y = 0.2126 R + 0.7152 G + 0.0722 B

def grayscale_at(input_image)
    pixels = input_image.to_a
    width = input_image.width
    height = input_image.height
    new_pixels = []

    (0..height - 1).each do |y|
        line = []
        (0..width - 1).each do |x|
            line.push(0.2126 * pixels[y][x][0] + 0.7152 * pixels[y][x][1] + 0.0722 * pixels[y][x][2])
        end
        new_pixels.push(line)
    end

    Vips::Image.new_from_array new_pixels
end

input_image = Vips::Image.new_from_file('../lenna.png')
convert_image = grayscale_at(input_image)
convert_image.write_to_file('section_2_output.png')