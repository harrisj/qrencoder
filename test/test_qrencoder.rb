require 'rubygems'
require 'inline'
require 'enumerator'
require 'test/unit' unless defined? $ZENTEST and $ZENTEST
require './lib/qrencoder.rb'

class TestQRCode < Test::Unit::TestCase
  inline do |builder|
    builder.add_link_flags "-lqrencode"
    builder.include '"qrencode.h"'
  
    builder.c <<-"END"
      VALUE test_img_data(const char *string, int version) {
        QRcode *code;
        VALUE out;
        int i, width;
        unsigned char *p;
        
        code = QRcode_encodeString(string, version, QR_ECLEVEL_L, QR_MODE_8);
        
        p = code->data;
        width = code->width;
    		out = rb_ary_new2(width*width);
        
    		for (i=0; i < width*width; i++) {
            unsigned char bit;
    				bit = *p;
    				rb_ary_push(out, INT2FIX(bit));
    				p++;
    		}

    		return out;      	
      }
    END
  end
  
  def setup
    @q = QRCode.encode_string("hi", 1)
  end
  
  def test_class_encode_string
    assert_equal 1, @q.version
    assert_equal 21, @q.width
  end

  def test_class_encode_string_ex
    #raise NotImplementedError, 'Need to write test_class_encode_string_ex'
  end

  def test_data
    assert_equal test_img_data("hi", 1), @q.data
  end

  def test_height
    assert_equal @q.width, @q.height
  end

  def test_pixels
    arr = []
    test_img_data("hi", 1).each_slice(@q.width) do |a|
      arr << a.map { |p| p & 0x1 }
    end
    
    assert_equal arr, @q.pixels
  end

  def test_points
    arr = []
    y = 0
    
    test_img_data("hi", 1).each_slice(@q.width) do |r|
      x = 0;
      
      r.each do |p|
        if (p & 0x1) == 1
          arr << [x, y]
        end
        
        x += 1
      end
      
      y += 1
    end
    
    assert_equal arr, @q.points
  end

#  def test_save_png
#    raise NotImplementedError, 'Need to write test_save_png'
#  end

  def test_version
    assert_equal 1, @q.version
  end

  def test_width
    assert_equal 21, @q.width
  end
end
