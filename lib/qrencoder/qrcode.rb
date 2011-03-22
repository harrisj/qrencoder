require 'chunky_png'

module QREncoder
  # Stores and represents data, points, and/or pixels for a QRCode
  class QRCode
    ##
    # Shortcut to save the QRcode as a PNG at +path+ using default options.
    #
    # For more control, or to specify non-default options, see QRCode#png
    def save_png(path)
      png.save(path)
    end

    ##
    # Returns an instance of PNG, which can be saved to a file with PNG#save or
    # converted to a blob for inline file transfer with PNG#to_blob.
    #
    # Options:
    #
    # [:margin] A pixel value for the margin around each side of the code. This should be 4 or greater. (default: +4+)
    # [:transparent] Background transparency. Can be true or false. (default: +false+)
    # [:pixels_per_module] Adjusts the entire PNG image by the given factor, integer. (default: +1+)
    #
    def png(options={})
      canvas(options)
    end

    ##
    # Returns an instance of PNG::Canvas
    #
    # Takes an optional hash of options. See QRCode#png for details.
    def canvas(options={})
      @margin = options[:margin] || 4
      ppm = options[:pixels_per_module] || 1
      background = options[:transparent] ? ChunkyPNG::Color::TRANSPARENT : ChunkyPNG::Color::WHITE
      png_width = (width + (2 * @margin)) * ppm

      canvas = ChunkyPNG::Image.new(png_width, png_width, background)

      points.each do |point|
        ppm.times do |x_offset|
          x = (point[0] + @margin) * ppm + x_offset
          ppm.times do |y_offset|
            y = (point[1] + @margin) * ppm + y_offset
            canvas[x,y] = ChunkyPNG::Color::BLACK
          end
        end
      end

      canvas
    end
  end
end
