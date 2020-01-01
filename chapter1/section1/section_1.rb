require 'vips'

#     output          input
#   New[2]:B   <==  Array[0]:R
#   New[1]:G   <==  Array[1]:G
#   New[0]:R   <==  Array[2]:B

def rgb_to_bgr(image)
    bands = image.bandsplit

    new_bands = Array.new(3)
    new_bands[0] = bands[2]
    new_bands[1] = bands[1]
    new_bands[2] = bands[0]

    Vips::Image.bandjoin(new_bands)
end

input_image = Vips::Image.new_from_file('../lenna.png')
convert_image = rgb_to_bgr(input_image)
convert_image.write_to_file('section_1_output.png')
