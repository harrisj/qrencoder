require 'mkmf'

dir_config("qrencoder")

if have_header("qrencode.h") && have_library("qrencode", "QRinput_new")
  create_makefile("qrencoder/qrencoder_ext")
end
