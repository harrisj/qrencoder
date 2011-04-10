require 'qrencoder/png'

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
      PNG.new(self, options)
    end

    def canvas(options={})
      png(options).canvas
    end
  end
end
