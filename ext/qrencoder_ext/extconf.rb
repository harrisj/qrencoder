require 'mkmf'

dir_config("qrencode")

if have_header("qrencode.h") && have_library("qrencode", "QRinput_new")
  create_makefile("qrencoder_ext")
end
