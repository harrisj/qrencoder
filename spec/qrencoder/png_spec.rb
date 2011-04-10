require 'spec_helper'

describe QREncoder::PNG do
  let(:png) { QREncoder::PNG.new(qrcode, options) }
  let(:qrcode) { QREncoder.encode("hi") }
  let(:options) { Hash.new }

  describe "#points" do
    it "is initialized from QRCode points" do
      points = []
      qrcode.stub(:points => points)
      png.points.should == points
    end
  end

  describe "#width" do
    before { qrcode.stub(:width => qrcode_width) }
    let(:qrcode_width) { 21 }
    subject { png.width }

    context "with a QRCode width of 21, default margin" do
      it { should == 29 }
    end

    context "with a QRCode width of 21, margin of 8" do
      let(:options) { {:margin => 8} }
      it { should == 37 }
    end

    context "with QRCode width of 21, pixels-per-module of 2" do
      let(:qrcode_width) { 21 }
      let(:options) { {:pixels_per_module => 2} }
      it { should == 58 }
    end

    context "with QRCode width of 25, pixels-per-module of 5, margin of 5" do
      let(:qrcode_width) { 25 }
      let(:options) { {:pixels_per_module => 5, :margin => 5} }
      it { should == (10 + 25) * 5 }
    end
  end

  describe "#background" do
    subject { png }

    context "with default options" do
      it "should be white" do
        subject.get_pixel(1,1).should == ChunkyPNG::Color::WHITE
      end
    end

    context "with transparent set to true" do
      subject { png.canvas() }
      let(:options) { {:transparent => true} }
      it "should be transparent" do
        subject.get_pixel(1,1).should == ChunkyPNG::Color::TRANSPARENT
      end
    end
  end

  describe "#canvas" do
    subject { png.canvas }
    it { should be_kind_of(ChunkyPNG::Image) }
  end

  describe "#save" do
    it "is delegated to canvas" do
      path = 'a/path.png'
      png.canvas.should_receive(:save).with(path)
      png.save(path)
    end
  end

  describe "#to_datastream" do
    it "is delegated to canvas" do
      png.canvas.should_receive(:to_datastream)
      png.to_datastream
    end
  end

  describe "#to_blob" do
    it "is delegated to canvas" do
      png.canvas.should_receive(:to_blob)
      png.to_blob
    end
  end

  describe "#respond_to?" do
    context "when method exists" do
      it "returns true" do
        png.should respond_to(:width)
      end
    end

    context "when method does not exist but is defined on ChunkyPNG::Canvas" do
      it "returns true" do
        png.should respond_to(:to_datastream)
      end
    end
    :w

    context "when method exists on neither self or canvas" do
      it "returns false" do
        png.should_not respond_to(:a_method_that_does_not_exist)
      end
    end
  end
end
