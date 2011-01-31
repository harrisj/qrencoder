require 'png'

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
    # converted to a blob for inline file transfer with PNG#to_blob. For more
    # information, see http://seattlerb.rubyforge.org/png/
    #
    # Options:
    #
    # [:margin] A pixel value for the margin around each side of the code. This should be 4 or greater. (default: +4+)
    # [:transparent] Background transparency. Can be true or false. (default: +false+)
    #
    def png(options={})
      PNG.new(canvas(options))
    end

    ##
    # Returns an instance of PNG::Canvas
    #
    # Takes an optional hash of options. See QRCode#png for details.
    def canvas(options={})
      @margin = options[:margin] || 4
      background = options[:transparent] ? PNG::Color::Background : PNG::Color::White
      png_width = width + (2 * @margin)

      canvas = PNG::Canvas.new(png_width, png_width, background)

      points.each do |p|
        x, y = png_coordinates_for_point(p)
        canvas[x,y] = PNG::Color::Black
      end

      canvas
    end

    private
    def png_coordinates_for_point(point)
      x = point[0] + @margin
      y = width - 1 - point[1] + @margin
      [x,y]
    end
  end
end
