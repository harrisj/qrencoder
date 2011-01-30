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


  def self.encode(string, options={})
    version = options[:version] || 1
    correction = corrections[options[:correction] || :low]
    mode = modes[options[:mode] || :ascii]
    case_sensitive = options[:case_sensitive] ? 1 : 0
    QRCode.new(string, version, correction, mode, case_sensitive)
  end

  def self.corrections
    {
      :low => QR_ECLEVEL_L,
      :medium => QR_ECLEVEL_M,
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
