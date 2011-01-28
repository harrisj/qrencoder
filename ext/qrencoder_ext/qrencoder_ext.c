#include "qrencode.h"
#include "ruby.h"

/* :no-doc: */
static void qrcode_free(void *p) {
  QRcode *qrcode = (QRcode *) p;
  QRcode_free(qrcode);
}

/*
 * call-seq:
 *   width
 *
 * Width of the symbol in modules. This value usually corresponds to 1 module
 * is 1 pixel, but you could conceivably scale it up if you wanted to.
 */
static VALUE _width(VALUE self) {
  QRcode *qrcode;
  Data_Get_Struct(self, QRcode, qrcode);
  return INT2FIX(qrcode->width);
}


/*
 * call-seq:
 *   version
 *
 * Version of the symbol. A QR Code version indicates the size of the 2-D
 * barcode in modules. See +qrencode_string+ for a more detailed description of
 * the version. Note that the version returned might be larger than the version
 * specified for an encode_string if the requested version is for a barcode too
 * small to encode the data.
 */
static VALUE _version(VALUE self) {
  QRcode *qrcode;
  Data_Get_Struct(self, QRcode, qrcode);
  return INT2FIX(qrcode->version);
}

/*
 * call-seq:
 *   data
 *
 * Returns the raw data of the QRcode within a single array of width*width
 * elements. Each item is a byte of data of which only the least significant
 * bit is the pixel. The full use of each bit from Least Significant to Most is
 * as follows
 *
 * - 1=black / 0=white
 * - data and ecc code area
 * - format information
 * - version information
 * - timing pattern
 * - alignment pattern
 * - finder pattern and separator
 * - non-data modules (format, timing, etc.)
 *
 * This structure allows the QRcode spec to store multiple types of information
 * within the allocated output buffers, but you usually only care about the pixel
 * color. For those cases, just use the +pixels+ or +points+ methods.
 */
static VALUE _data(VALUE self) {
  QRcode *qrcode;
  VALUE out;
  unsigned char *p, b;
  int i, max;

  Data_Get_Struct(self, QRcode, qrcode);
  p = qrcode->data;
  max = qrcode->width * qrcode->width;
  out = rb_ary_new2(max);

  for (i=0; i < max; i++) {
    b = *p;
    rb_ary_push(out, INT2FIX(b));
    p++;
  }

  return out;
}

/*
 * call-seq:
 *   pixels
 *
 * Returns the QRcode as an array of rows where each item in a row represents
 * the value of the pixel (1 = black, 0 = white)
 */
static VALUE _pixels(VALUE self) {
  QRcode *qrcode;
  VALUE out, row;
  unsigned char *p;
  int x, y, bit;

  Data_Get_Struct(self, QRcode, qrcode);
  p = qrcode->data;
  out = rb_ary_new2(qrcode->width);

  for (y=0; y < qrcode->width; y++) {
    row = rb_ary_new2(qrcode->width);

    for (x=0; x < qrcode->width; x++) {
      bit = *p & 1;
      rb_ary_push(row, INT2FIX(bit));
      p++;
    }

    rb_ary_push(out, row);
  }

  return out;
}

/*
 * call-seq:
 *   points
 *
 * Returns the black pixels of the encoded image as an array of coordinate pairs.
 */
static VALUE _points(VALUE self) {
  QRcode *qrcode;
  VALUE out, point;
  unsigned char *p;
  int x, y, bit;

  Data_Get_Struct(self, QRcode, qrcode);
  p = qrcode->data;
  out = rb_ary_new2(qrcode->width);

  for (y=0; y < qrcode->width; y++) {
    for (x=0; x < qrcode->width; x++) {
      bit = *p & 1;

      if (bit) {
        point = rb_ary_new2(2);
        rb_ary_push(point, INT2FIX(x));
        rb_ary_push(point, INT2FIX(y));
        rb_ary_push(out, point);
      }

      p++;
    }
  }

  return out;
}


/*
 * call-seq:
 *   encode_string_ex(string, version, eclevel, hint, case_sensitive = 0)

 * This function is similar in purpose to +encode_string+, but it allows you to
 * explicitly specify the encoding and error correction level. There are 4
 * arguments to this function:
 *
 * - <tt>string</tt> the string to encode
 * - <tt>version</tt> the version of the QR Code (see +encode_string+ for explanation)
 * - <tt>error correction level</tt>
 * - <tt>encoding mode</tt>
 *
 * The following four Constants can be specified for error correction levels, each
 * specified with the maximum approximate error rate they can compensate for, as
 * well as the maximum capacity of an 8-bit data QR Code with the error encoding:
 *
 * - <tt>QR_ECLEVEL_L</tt> - 7%/2953 [default]
 * - <tt>QR_ECLEVEL_M</tt> - 15%/2331
 * - <tt>QR_ECLEVEL_Q</tt> - 25%/1663
 * - <tt>QR_ECLEVEL_H</tt> - 30%/1273
 *
 * Higher error rates are suitable for applications where the QR Code is likely
 * to be smudged or damaged, but as is apparent here, they can radically reduce
 * the maximum data capacity of a QR Code.
 *
 * There are also 4 possible encodings for a QR Code which can modify the
 * maximum data capacity. These are specified with four possible Constants, each
 * listed here with the maximum capacity available for that encoding at the lowest
 * error correction rate.
 *
 * - <tt>QR_MODE_NUM</tt> - Numeric/7089
 * - <tt>QR_MODE_AN</tt> - Alphanumeric/4296
 * - <tt>QR_MODE_8</tt> - 8-bit ASCII/2953 [default]
 * - <tt>QR_MODE_KANJI</tt>  - Kanji (JIS-1 & 2)/1817
 *
 * Note that the QR Code specification seemingly predates the rise and triumph
 * of UTF-8, and the specification makes no requirement that writers and readers
 * use ISO-8859-1 or UTF-8 or whatever to interpret the data in a barcode. If you
 * encode in UTF-8, it might be read as ISO-8859-1 or not.
 *
 * Finally, encoding can either be case sensitive (1) or not (0).
 */
static VALUE _encode_string_ex(VALUE self, VALUE _string, VALUE _version, VALUE _eclevel, VALUE _hint, VALUE _casesensitive) {
  const char *string = StringValuePtr(_string);
  int version = FIX2INT(_version);
  int eclevel = FIX2INT(_eclevel);
  int hint = FIX2INT(_hint);
  int casesensitive = FIX2INT(_casesensitive);

  QRcode *code;
  VALUE klass;

  code = QRcode_encodeString(string, version, eclevel, hint, casesensitive);
  klass = rb_const_get_at(rb_cObject, rb_intern("QRCode"));
  return Data_Wrap_Struct(klass, NULL, qrcode_free, code);
}

/*
 * call-seq:
 *   encode_string(string, version)
 *
 * Encodes a QR code from a string. This version of the method assumes the
 * input data is 8-bit ASCII, case sensitive, and that you want the most basic
 * error correction. For more detailed control over those parameters, use
 * +encode_string_ex+. This method takes 2 arguments: a string to encode and a
 * QRCode +version+ which essentially determines the size of the QRCode.
 *
 * What is the version? Each QRCode is made up of <b>modules</b> which are the
 * basic display element of a QRCode and may be made up of 1 or more pixels
 * (here, it's just 1 module is 1 pixel). Version 1 is a 21x21  module square,
 * while the maximum version 40 is 177x177 modules.  The full module reference
 * is here http://www.denso-wave.com/qrcode/vertable1-e.html
 *
 * Should you encode more text than can fit in a module, the encoder will scale
 * up to the smallest version able to contain your data. Unless you want to
 * specifically fix your barcode to a certain version, it's fine to just set
 * the version argument to 1 and let +encode_string+ figure out the proper size.
 */
static VALUE _encode_string(VALUE self, VALUE _string, VALUE _version) {
  const char *string = StringValuePtr(_string);
  int version = FIX2INT(_version);

  QRcode *code;
  VALUE klass;

  code = QRcode_encodeString(string, version, QR_ECLEVEL_L, QR_MODE_8, 1);
  klass = rb_const_get_at(rb_cObject, rb_intern("QRCode"));
  return Data_Wrap_Struct(klass, NULL, qrcode_free, code);
}

/* :no-doc: */
void Init_qrencoder_ext()
{
    VALUE cQRCode = rb_define_class("QRCode", rb_cObject);

    rb_define_method(cQRCode, "width", _width, 0);
    rb_define_method(cQRCode, "version", _version, 0);
    rb_define_method(cQRCode, "data", _data, 0);
    rb_define_method(cQRCode, "pixels", _pixels, 0);
    rb_define_method(cQRCode, "points", _points, 0);

    rb_define_singleton_method(cQRCode, "encode_string_ex", _encode_string_ex, 5);
    rb_define_singleton_method(cQRCode, "encode_string", _encode_string, 2);
}
