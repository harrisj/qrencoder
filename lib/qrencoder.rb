require 'qrencoder/qrencoder_ext'
require 'png'

class QRCode
  GEM_VERSION = '1.0.1'

  # Encoding modes
  QR_MODE_NUM = 0
  QR_MODE_AN = 1
  QR_MODE_8 = 2
  QR_MODE_KANJI = 3

  # Error correction
  QR_ECLEVEL_L = 0
  QR_ECLEVEL_M = 1
  QR_ECLEVEL_Q = 2
  QR_ECLEVEL_H = 3

  ##
  # Version of the symbol. A QR Code version indicates the size of the 2-D
  # barcode in modules. See #qrencode_string for a more detailed description of
  # the version. Note that the version returned might be larger than the version
  # specified for an encode_string if the requested version is for a barcode too
  # small to encode the data.
  # def version; end;

  ##
  # Width of the symbol in modules. This value usually corresponds to 1 module
  # is 1 pixel, but you could conceivably scale it up if you wanted to.
  # def width; end;

  ##
  # Returns the raw data of the QRcode within a single array of width*width
  # elements. Each item is a byte of data of which only the least significant
  # bit is the pixel. The full use of each bit from Least Significant to Most is
  # as follows
  #
  # * 1=black/0=white
  # * data and ecc code area
  # * format information
  # * version information
  # * timing pattern
  # * alignment pattern
  # * finder pattern and separator
  # * non-data modules (format, timing, etc.)
  #
  # This structure allows the QRcode spec to store multiple types of information
  # within the allocated output buffers, but you usually only care about the pixel
  # color. For those cases, just use the #pixels or #points methods.
  # def data; end;

  ##
  # Returns the QRcode as an array of rows where each item in a row represents
  # the value of the pixel (1=black, 0=white)
  # def pixels; end;

  ##
  # Returns the black pixels of the encoded image as an array of coordinate pairs.
  # def points; end;

  ##
  # Encodes a QR code from a string. This version of the method assumes the
  # input data is 8-bit ASCII, case sensitive, and that you want the most basic error
  # correction. For more detailed control over those parameters, use
  # #encode_string_ex. This method takes 2 arguments: a string to encode and a QRCode
  # <tt>version</tt> which essentially determines the size of the QRCode.
  #
  # What is the version? Each QRCode is made up
  # of <b>modules</b> which are the basic display element of a QRCode and may
  # be made up of 1 or more pixels (here, it's just 1 module is 1 pixel).
  # Version 1 is a 21x21
  # module square, while the maximum version 40 is 177x177 modules. The full
  # module reference is here http://www.denso-wave.com/qrcode/vertable1-e.html
  #
  # Should you encode more text than can fit in a module, the encoder will scale
  # up to the smallest version able to contain your data. Unless you want to
  # specifically fix your barcode to a certain version, it's fine to just set
  # the version argument to 1 and let #encode_string figure out the proper size.
  # def encode_string; end;

  ##
  # This function is similar in purpose to #encode_string, but it allows you to
  # explicitly specify the encoding and error correction level. There are 4
  # arguments to this function:
  #
  # * <tt>string</tt> the string to encode
  # * <tt>version</tt> the version of the QR Code (see #encode_string for explanation)
  # * <tt>error correction level</tt>
  # * <tt>encoding mode</tt>
  #
  # The following four Constants can be specified for error correction levels, each
  # specified with the maximum approximate error rate they can compensate for, as
  # well as the maximum capacity of an 8-bit data QR Code with the error encoding:
  #
  # * <tt>QR_ECLEVEL_L</tt> - 7%/2953 [default]
  # * <tt>QR_ECLEVEL_M</tt> - 15%/2331
  # * <tt>QR_ECLEVEL_Q</tt> - 25%/1663
  # * <tt>QR_ECLEVEL_H</tt> - 30%/1273
  #
  # Higher error rates are suitable for applications where the QR Code is likely
  # to be smudged or damaged, but as is apparent here, they can radically reduce
  # the maximum data capacity of a QR Code.
  #
  # There are also 4 possible encodings for a QR Code which can modify the
  # maximum data capacity. These are specified with four possible Constants, each
  # listed here with the maximum capacity available for that encoding at the lowest
  # error correction rate.
  #
  # * <tt>QR_MODE_NUM</tt> - Numeric/7089
  # * <tt>QR_MODE_AN</tt> - Alphanumeric/4296
  # * <tt>QR_MODE_8</tt> - 8-bit ASCII/2953 [default]
  # * <tt>QR_MODE_KANJI</tt>  - Kanji (JIS-1 & 2)/1817
  #
  # Note that the QR Code specification seemingly predates the rise and triumph
  # of UTF-8, and the specification makes no requirement that writers and readers
  # use ISO-8859-1 or UTF-8 or whatever to interpret the data in a barcode. If you
  # encode in UTF-8, it might be read as ISO-8859-1 or not.
  #
  # Finally, encoding can either be case sensitive (1) or not (0).
  # def encode_string_ex; end;

  ##
  # Height of the symbol. Since QR Codes are square, this is the same as the
  # width but this alias is provided if you want to avoid confusion.
  alias :height :width

  ##
  # Save the QRcode to a PNG file. You can also specify a margin in pixels around
  # the image, although the specification requests it should be at least 4 px.
  def save_png(path, margin=4)
    canvas = PNG::Canvas.new(width + (2*margin), width+(2*margin), PNG::Color::White)
    points.each do |p|
      x, y = png_coordinates_for_point(p, margin)
      canvas[x,y] = PNG::Color::Black
    end
    png = PNG.new canvas
    png.save path
  end

  private
  def png_coordinates_for_point(point, margin)
    x = point[0] + margin
    y = width - 1 - point[1] + margin
    [x,y]
  end
end
