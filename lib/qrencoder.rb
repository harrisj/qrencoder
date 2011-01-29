require 'qrencoder/version'
require 'qrencoder/qrencoder_ext'
require 'png'

module QREncoder

  # Stores and represents data, points, and/or pixels for a QRCode
  class QRCode
    # Numeric-only encoding mode
    QR_MODE_NUM = 0

    # Alphanumeric-only encoding mode
    QR_MODE_AN = 1

    # 8-bit ASCII encoding mode
    QR_MODE_8 = 2

    # Kanji encoding mode
    QR_MODE_KANJI = 3

    # Low error correction
    QR_ECLEVEL_L = 0

    # Medium error correction
    QR_ECLEVEL_M = 1

    # Medium-high error correction
    QR_ECLEVEL_Q = 2

    # High error correction
    QR_ECLEVEL_H = 3

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
end
