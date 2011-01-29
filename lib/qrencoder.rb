require 'qrencoder/version'
require 'qrencoder/qrencoder_ext'
require 'qrencoder/qrcode'

module QREncoder

  def self.encode(string, options={})
    version = options[:version] || 1
    correction = corrections[options[:correction] || :low]
    mode = modes[options[:mode] || :ascii]
    case_sensitive = options[:case_sensitive] ? 1 : 0
    QRCode.encode_string_ex(string, version, correction, mode, case_sensitive)
  end

  def self.corrections
    {
      :low => QREncoder::QRCode::QR_ECLEVEL_L,
      :medium => QREncoder::QRCode::QR_ECLEVEL_M,
      :high => QREncoder::QRCode::QR_ECLEVEL_H
    }
  end

  def self.modes
    {
      :numeric => QREncoder::QRCode::QR_MODE_NUM,
      :alphanumeric => QREncoder::QRCode::QR_MODE_AN,
      :ascii => QREncoder::QRCode::QR_MODE_8,
      :kanji => QREncoder::QRCode::QR_MODE_KANJI
    }
  end

end
