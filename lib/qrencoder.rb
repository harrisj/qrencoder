require 'qrencoder/version'
require 'qrencoder/qrencoder_ext'
require 'qrencoder/qrcode'

module QREncoder
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

  # Encode a string, return a QRCode object
  #
  # This method takes 2 arguments: the string you wish to encode, and a hash of
  # options. The options are as follows:
  #
  # [:version] An integer representing the minimum QRCode version (default: +1+)
  # [:correction] The amount of error correction to apply. One of +:low+, +:medium+, +:quarter+, +:high+. (default: +:low+)
  # [:mode] The encoding mode to use. Must be one of +:numeric+, +:alphanumeric+, +:ascii+, +:kanji+. (default: +:ascii+)
  # [:case_sensitive] Set to +false+ if case does not matter. (default: +true+)
  #
  # For more information about what each of these modes and correction levels
  # mean, see QRCode.new
  #
  def self.encode(string, options={})
    version = options[:version] || 1
    correction = corrections[options[:correction] || :low]
    mode = modes[options[:mode] || :ascii]
    case_sensitive = options[:case_sensitive] == false ? 0 : 1
    string.upcase! if mode == QR_MODE_AN
    QRCode.new(string.to_s, version, correction, mode, case_sensitive)
  end

  def self.corrections
    {
      :low => QR_ECLEVEL_L,
      :medium => QR_ECLEVEL_M,
      :quarter => QR_ECLEVEL_Q,
      :high => QR_ECLEVEL_H
    }
  end

  def self.modes
    {
      :numeric => QR_MODE_NUM,
      :alphanumeric => QR_MODE_AN,
      :ascii => QR_MODE_8,
      :kanji => QR_MODE_KANJI
    }
  end

end
