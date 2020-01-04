require 'vips'

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

def calc_otsu_th(input_image)
    pixels = input_image.to_a
    width = input_image.width
    height = input_image.height

    (0..255).to_h { |i| [i, now_sb(width, height, pixels, i)] }.max_by(&:last).first
end

def now_sb(width, height, pixels, th)
    sum = Hash.new { |h, k| h[k] = 0 }
    klass = Hash.new { |h, k| h[k] = 0 }

    (0..height - 1).each do |y|
        (0..width - 1).each do |x|
            value = pixels[y][x][0]
            over_th = value < th

            sum[over_th] += value
            klass[over_th] += 1
        end
    end

    m0 = klass[true].zero? ? 0 : (sum[true] / klass[true])
    m1 = klass[false].zero? ? 0 : (sum[false] / klass[false])
    (klass[true] / 16_384.to_f) * (klass[false] / 16_384.to_f) * (m0 - m1).to_i.pow(2)
end

def binarize(input_image, th)
    pixels = input_image.to_a
    width = input_image.width
    height = input_image.height
    new_pixels = []

    (0..height - 1).each do |y|
        line = []
        (0..width - 1).each do |x|
            line.push(pixels[y][x][0] > th ? 255 : 0)
        end
        new_pixels.push(line)
    end

    Vips::Image.new_from_array new_pixels
end

input_image = Vips::Image.new_from_file('../lenna.png')
gray_image = grayscale_at(input_image)
th = calc_otsu_th(gray_image)
convert_image = binarize(gray_image, th)
convert_image.write_to_file('section_4_output.png')