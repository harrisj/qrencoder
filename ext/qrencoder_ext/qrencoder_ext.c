#include "qrencode.h"
#include "ruby.h"

static void qrcode_free(void *p) {
  QRcode *qrcode = (QRcode *) p;
  QRcode_free(qrcode);
}

static VALUE _width(VALUE self) {
  QRcode *qrcode;
  Data_Get_Struct(self, QRcode, qrcode);
  return INT2FIX(qrcode->width);
}

static VALUE _version(VALUE self) {
  QRcode *qrcode;
  Data_Get_Struct(self, QRcode, qrcode);
  return INT2FIX(qrcode->version);
}

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

static VALUE _encode_string(VALUE self, VALUE _string, VALUE _version) {
  const char *string = StringValuePtr(_string);
  int version = FIX2INT(_version);

  QRcode *code;
  VALUE klass;

  code = QRcode_encodeString(string, version, QR_ECLEVEL_L, QR_MODE_8, 1);
  klass = rb_const_get_at(rb_cObject, rb_intern("QRCode")); 
  return Data_Wrap_Struct(klass, NULL, qrcode_free, code);
}

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
